#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily

########################################
mkdir purifying_selection && cd purifying_selection
cp ${WORKDIR}/gene_evolution/human.msa.inputdir.txt .
for transID in ENST00000415431.FBP1; do ${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/FBP_genefamily/purifying_selection/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --macse_caller "java -jar ${WORKDIR}/software/macse_v2.07.jar" -o ${WORKDIR}/FBP_genefamily/purifying_selection/${transID}.fasta &> ${WORKDIR}/FBP_genefamily/purifying_selection/${transID}.log; done
cp /home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/ENST00000415431.FBP1.fasta /home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/checked_ENST00000415431.FBP1.fasta
########################################


awk '{ if ($0 ~ /^>/) { split($0, a, "__"); print a[1]; } else { print $0; } }' ${WORKDIR}/FBP_genefamily/purifying_selection/ENST00000415431.FBP1.fasta > ${WORKDIR}/FBP_genefamily/purifying_selection/checked_ENST00000415431.FBP1.fasta
sed -i 's/REFERENCE/Human/g' checked_ENST00000415431.FBP1.fasta

grep 'ENST00000415431.FBP1' -A 1 /home/liunyw/project/howler_monkey/TOGA_data/human_hg38_data/Alouatta_seniculus__Colombian_red_howler__HLaloSen1/codon.fasta | grep 'QUERY' -A 1 | sed 's/ //g' >> checked_ENST00000415431.FBP1.fasta

#align
java -jar ${WORKDIR}/software/macse_v2.07.jar -prog alignSequences -seq checked_ENST00000415431.FBP1.fasta
python3 /home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/triming.py
#

#build tree
mkdir iqtree && cd iqtree
/home/liunyw/project/howler_monkey/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s /home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/checked_ENST00000415431.FBP1.trimmed.fasta -pre howlerFBPMFP -m MFP


mkdir FitMG94 && cd FitMG94
#primate.divergent.tree

/home/liunyw/project/howler_monkey/software/hyphy/hyphy LIBPATH=/home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/FitMG94/hyphy/res /home/liunyw/project/howler_monkey/FBP_genefamily/purifying_selection/FitMG94/hyphy-analyses/FitMG94/FitMG94.bf --alignment ../checked_ENST00000415431.FBP1.trimmed.fasta -tree primate.divergent.tree --type local --output FitMG94_results.json
~/miniforge3/bin/jq -r '["Branch", "dN/dS"], (.["branch attributes"]["0"] | to_entries | map ([.key,.value["Confidence Intervals"].MLE])[]) | @csv '  FitMG94_results.json


#PAML branch model
WORKDIR=/home/liunyw/project/howler_monkey
mkdir branch_model && cd branch_model
cp ../RELAX/*tree .

${WORKDIR}/software/catfasta2phyml/catfasta2phyml.pl ${WORKDIR}/FBP_genefamily/purifying_selection/checked_ENST00000415431.FBP1.trimmed.fasta > FBP1.phy
sed -i '/^$/d' FBP1.phy
sed -i '/[0-9]/G' FBP1.phy
sed -i 's/\!/N/g' FBP1.phy


for i in HMFBP1ACD HMFBP1B HMFBP1CD; do mkdir ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}; echo -e "      seqfile = ../FBP1.phy\n     treefile = ../primate.divergent.${i}.tree\n      outfile = out_${i}_branch.txt\n\n        noisy = 3              * How much rubbish on the screen\n      verbose = 1                         * More or less detailed report\n\n      seqtype = 1              * Data type\n        ndata = 1             * Number of data sets or loci\n        icode = 0              * Genetic code\n    cleandata = 0              * Remove sites with ambiguity data?\n\n        model = 2         * Models for ω varying across lineages\n      NSsites = 0          * Models for ω varying across sites\n    CodonFreq = 2        * Codon frequencies\n      estFreq = 0        * Use observed freqs or estimate freqs by ML\n        clock = 0          * Clock model\n    fix_omega = 0         * Estimate or fix omega\n        omega = 0.5        * Initial or fixed omega" > ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}/codeml-branch.ctl; done



for i in HMFBP1ACD HMFBP1B HMFBP1CD; do echo -e '#!/bin/bash\n#SBATCH -J '${i}'_branch\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}'/FBP_genefamily/purifying_selection/branch_model/'${i}'/out_'${i}'_branch.out\n#SBATCH --error='${WORKDIR}'/FBP_genefamily/purifying_selection/branch_model/'${i}'/err_'${i}'_branch.err\n\n' > ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}/branch.sh; echo -e "cd ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}\n${WORKDIR}/software/paml-4.10.7/bin/codeml codeml-branch.ctl | tee logfile_codeml-branch.txt > /dev/null" >> ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}/branch.sh; done

cd branch_model
for i in HMFBP1ACD HMFBP1B HMFBP1CD; do sbatch ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/${i}/branch.sh; done
grep 'w (dN/dS) for branches' ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/HMFBP1ACD/out_HMFBP1ACD_branch.txt
grep 'w (dN/dS) for branches' ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/HMFBP1CD/out_HMFBP1CD_branch.txt
grep 'w (dN/dS) for branches' ${WORKDIR}/FBP_genefamily/purifying_selection/branch_model/HMFBP1B/out_HMFBP1B_branch.txt
