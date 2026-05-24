#!/usr/bin/env python3
import os
import glob
import pandas as pd
import re

# set the working directory
BASE_DIR = "/home/liunyw/project/howler_monkey/gene_evolution/structure"
OUTPUT_DIR = "/home/liunyw/project/howler_monkey/gene_evolution"

results = []
print("Start parsing FoldX results...")

# traverse all gene folders
for genename in os.listdir(BASE_DIR):
    gene_dir = os.path.join(BASE_DIR, genename)
    if not os.path.isdir(gene_dir):
        continue
        
    list_file = os.path.join(gene_dir, "individual_list.txt")
    # find the corresponding Dif_ file starting with the result file
    dif_files = glob.glob(os.path.join(gene_dir, "Dif_*.fxout"))
    
    if os.path.exists(list_file) and dif_files:
        dif_file = dif_files[0] # usually there is only one Dif_ file in each gene folder
        
        # 1. read the mutation list (keep the order)
        with open(list_file, 'r') as f:
            # filter empty lines, extract the mutation instruction from each line, remove the semicolon at the end
            mutations = [line.strip().strip(';') for line in f if line.strip()]
        
        # 2. read the Dif file, extract the ddG value
        # the first column of the Dif file is usually the PDB file name of the mutant (e.g. xxx_1.pdb), the second column is the total energy (ddG)
        ddg_dict = {}
        with open(dif_file, 'r') as f:
            for line in f:
                parts = line.strip().split('\t')
                if len(parts) > 1 and parts[0].endswith('.pdb'):
                    pdb_name = parts[0]
                    try:
                        # use regex to extract the number at the end of the file name, for example, extract the number 1 from "AF-xxx_Repair_1.pdb"
                        mut_num_match = re.search(r'_(\d+)\.pdb$', pdb_name)
                        if mut_num_match:
                            mut_num = int(mut_num_match.group(1))
                            ddg = float(parts[1])
                            ddg_dict[mut_num] = ddg
                    except (AttributeError, ValueError):
                        continue
        
        # 3. map the mutation instruction to the ddG result
        for i, mut_str in enumerate(mutations):
            mut_num = i + 1 # the i-th instruction corresponds to _(i+1).pdb
            
            # parse the mutation information, if there are multiple chain mutations (e.g. KA67E,KB67E), take the first one to extract the site and amino acid
            first_mut = mut_str.split(',')[0].strip()
            
            # regex parsing: WT amino acid (1 letter) + chain (1 letter) + site (number) + mutated amino acid (1 letter)
            # e.g. "KA67E" -> wt: K, chain: A, site: 67, mut: E
            match = re.match(r'^([A-Za-z])([A-Za-z])(\d+)([A-Za-z])$', first_mut)
            if match:
                wt_aa = match.group(1)
                site = match.group(3)
                mut_aa = match.group(4)
            else:
                wt_aa, site, mut_aa = ("?", "?", "?")
            
            ddg = ddg_dict.get(mut_num, "N/A")
            
            # 4. evaluate the mutation result (based on ddG)
            # common structural biology experience thresholds:
            # ddG > 0.5 kcal/mol is usually considered to be destabilizing
            # ddG < -0.5 kcal/mol is usually considered to be stabilizing
            if ddg != "N/A":
                if ddg >= 1.0:
                    # (highly destabilizing)
                    effect = "Highly Destabilizing"
                elif ddg >= 0.5:
                    # (destabilizing)
                    effect = "Destabilizing"
                elif ddg <= -0.5:
                    # (stabilizing)
                    effect = "Stabilizing"
                else:
                    #(neutral/not significant)
                    effect = "Neutral"
            else:
                effect = "Error/Not Computed"
                
            results.append({
                "gene_name": genename,
                "original_mutation": mut_str,
                "mutation_site": site,
                "from": wt_aa,
                "to": mut_aa,
                "ΔΔG (kcal/mol)": ddg,
                "mutation_result": effect,
                "pdb_ID": pdb_name.split('_Repair')[0]
            })

# save as CSV file
df = pd.DataFrame(results)

# ================= sorting logic =================
# replace with the actual desired order list
# I use the order in your Bash script as an example:
gene_order = [
    'MMP13', 'PAX6', 
    'LCT', 'TAS1R3', 'SLC23A1', 'SLC46A1', 'AMN', 'SLC51A',
    'RNASE4', 'RNASE7', 'RNASEL',
    'TPI1', 'ADH7', 'ACAT1'
]

# convert the "gene_name" column to Categorical type, and force the order we just defined
df['gene_name'] = pd.Categorical(df['gene_name'], categories=gene_order, ordered=True)

# ensure the site column is numeric type, so the site sorting is 9, 10, 11 (instead of 10, 11, 9)
# because the regex extraction is a string, here convert it to an integer, if it is '?' (not matched) then fill 0 or other placeholder
df['site_for_sorting'] = pd.to_numeric(df['mutation_site'], errors='coerce').fillna(0)

# sort by "gene_name" (custom order) and "site" (numeric size)
df = df.sort_values(by=['gene_name', 'site_for_sorting'])

# drop the temporary column for auxiliary sorting
df = df.drop(columns=['site_for_sorting'])
# ===============================================

output_csv = os.path.join(OUTPUT_DIR, "foldx_mutation_summary.txt")
df.to_csv(output_csv, index=False, encoding='utf-8-sig', sep='\t') 

print(f"Parsing completed! Total {len(results)} mutation records parsed.")
print(f"Results saved to: {output_csv}")