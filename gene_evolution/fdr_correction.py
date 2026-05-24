import pandas as pd
from statsmodels.stats.multitest import multipletests

# 1. read the CSV file containing the raw p-values
# please ensure the file name and column names match your actual data
print("Reading data...")
# df = pd.read_csv("PSG_codeml_raw_results.txt")
df = pd.read_csv("/home/liunyw/project/howler_monkey/gene_evolution/PSG_codeml_raw_results.txt", sep='\t', header=None, names=['Gene_Name', 'raw_p_value'])

# check if there are missing values and clean them (to prevent errors)
initial_count = len(df)
df = df.dropna(subset=['raw_p_value'])
if len(df) < initial_count:
    print(f"Warning: removed {initial_count - len(df)} rows with missing p-values.")

# 2. execute Benjamini-Hochberg (BH) FDR correction
print("Executing FDR correction...")
# multipletests function returns four values, we mainly extract the second one: corrected p-values (i.e. q-values)
# the alpha parameter is mainly used to generate the reject boolean array, it does not affect the calculation of q_values itself
reject, q_values, alphacSidak, alphacBonf = multipletests(
    pvals=df['raw_p_value'], 
    alpha=0.05, 
    method='fdr_bh'
)

# 3. add the calculated q-value as a new column to the dataframe
df['fdr_q_value'] = q_values

# 4. sort by q-value
df = df.sort_values(by='fdr_q_value')

# 5. save the complete results (including all 10000+ genes and their corrected values)
output_all = "/home/liunyw/project/howler_monkey/gene_evolution/PSG_codeml_results_FDR_all.csv"
df.to_csv(output_all, index=False)
print(f"Complete analysis results saved to: {output_all}")

# 6. set the FDR threshold and filter the significant genes under positive selection
fdr_threshold_005 = 0.05  
fdr_threshold_01 = 0.1  
significant_genes_005 = df[df['fdr_q_value'] < fdr_threshold_005]
significant_genes_01 = df[df['fdr_q_value'] < fdr_threshold_01]

# 7. save the independent files for the significant genes
output_sig_005 = f"/home/liunyw/project/howler_monkey/gene_evolution/PSG_codeml_results_FDR_significant_q{fdr_threshold_005}.csv"
significant_genes_005.to_csv(output_sig_005, index=False)
output_sig_01 = f"/home/liunyw/project/howler_monkey/gene_evolution/PSG_codeml_results_FDR_significant_q{fdr_threshold_01}.csv"
significant_genes_01.to_csv(output_sig_01, index=False)

# 8. print the result summary
print("-" * 30)
print(f"Total number of tested genes: {len(df)}")
print(f"Number of genes with raw p < 0.05: {len(df[df['raw_p_value'] < 0.05])}")
print(f"Number of genes with FDR q < {fdr_threshold_005} under positive selection: {len(significant_genes_005)}")
print(f"Number of genes with FDR q < {fdr_threshold_01} under positive selection: {len(significant_genes_01)}")
print("-" * 30)