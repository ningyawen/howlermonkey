#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_evolution/check_maf

awk '{print $2}' ${WORKDIR}/gene_evolution/TOGAname2sciname.txt > allTOGAsciname.txt


#制作准备文件
for i in $(ls ${WORKDIR}/gene_evolution/check_maf); do cd ${WORKDIR}/gene_evolution/check_maf/; mkdir ${i%_hmm.fasta} && mv ${i} ${i%_hmm.fasta}; ${WORKDIR}/software/catfasta2phyml/catfasta2phyml.pl ${i%_hmm.fasta}/${i} > ${i%_hmm.fasta}/${i%_hmm.fasta}.phy; sed -i '/^$/d' ${i%_hmm.fasta}/${i%_hmm.fasta}.phy; sed -i '/[0-9]/G' ${i%_hmm.fasta}/${i%_hmm.fasta}.phy; sed -i 's/\!/N/g' ${i%_hmm.fasta}/${i%_hmm.fasta}.phy; mkdir ${i%_hmm.fasta}/modelA ${i%_hmm.fasta}/null; echo -e "      seqfile = ../${i%_hmm.fasta}.phy\n     treefile = ../howlermonkey.tree\n      outfile = out_branchsite.txt\n\n        noisy = 3              * How much rubbish on the screen\n      verbose = 1                         * More or less detailed report\n\n      seqtype = 1              * Data type\n        ndata = 1             * Number of data sets or loci\n        icode = 0              * Genetic code\n    cleandata = 0              * Remove sites with ambiguity data?\n\n        model = 2         * Models for ω varying across lineages\n      NSsites = 2          * Models for ω varying across sites\n    CodonFreq = 7        * Codon frequencies\n      estFreq = 0        * Use observed freqs or estimate freqs by ML\n        clock = 0          * Clock model\n    fix_omega = 0         * Estimate or fix omega\n        omega = 0.5        * Initial or fixed omega" > ${i%_hmm.fasta}/modelA/codeml-branchsite.ctl; echo -e "      seqfile = ../${i%_hmm.fasta}.phy\n     treefile = ../howlermonkey.tree\n      outfile = out_branchsite.txt\n\n        noisy = 3              * How much rubbish on the screen\n      verbose = 1                         * More or less detailed report\n\n      seqtype = 1              * Data type\n        ndata = 1             * Number of data sets or loci\n        icode = 0              * Genetic code\n    cleandata = 0              * Remove sites with ambiguity data?\n\n        model = 2         * Models for ω varying across lineages\n      NSsites = 2          * Models for ω varying across sites\n    CodonFreq = 7        * Codon frequencies\n      estFreq = 0        * Use observed freqs or estimate freqs by ML\n        clock = 0          * Clock model\n    fix_omega = 1         * Estimate or fix omega\n        omega = 1          * Initial or fixed omega" > ${i%_hmm.fasta}/null/codeml-branchsite_null.ctl; grep '>' ${i%_hmm.fasta}/${i} | sed 's/>//g' > ${i%_hmm.fasta}/${i%_hmm.fasta}.species.txt; echo -ne ' ' $(wc -l ${i%_hmm.fasta}/${i%_hmm.fasta}.species.txt | awk '{print $1}') "\t1" > ${i%_hmm.fasta}/howlermonkey.tree; echo -e '\n' >> ${i%_hmm.fasta}/howlermonkey.tree; if [ ! -n "$(grep -vf ${i%_hmm.fasta}/${i%_hmm.fasta}.species.txt ../allTOGAsciname.txt)" ]; then cat ${WORKDIR}/gene_evolution/howlermonkey.tree >> ${i%_hmm.fasta}/howlermonkey.tree; else /lustre/home/luyizheng/miniforge3/envs/phygenomics/bin/nw_prune -v ${WORKDIR}/gene_evolution/howlermonkey.tree $(cat ${i%_hmm.fasta}/${i%_hmm.fasta}.species.txt) >> ${i%_hmm.fasta}/howlermonkey.tree; fi; sed -i 's/Alouatta_macconnelli/Alouatta_macconnelli #1/g' ${i%_hmm.fasta}/howlermonkey.tree; done


#制作shell文件
mkdir ${WORKDIR}/gene_evolution/shell_postv && cd ${WORKDIR}/gene_evolution/check_maf/
ls > ../shell_postv.txt && cd ../shell_postv
split -l 75 ../shell_postv.txt postv
for i in *; do mv $i ${i}.txt; done

for postv_file in $(ls ${WORKDIR}/gene_evolution/shell_postv | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${postv_file%.txt}_postv'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_postv/${postv_file%.txt}_postv.out'\n#SBATCH --error='${WORKDIR}/gene_evolution/shell_postv/${postv_file%.txt}_postv.err'\n\n' > ${WORKDIR}/gene_evolution/shell_postv/${postv_file%.txt}_postv.sh; echo -e "cd ${WORKDIR}/gene_evolution/check_maf/ \nfor i in \$(cat ${WORKDIR}/gene_evolution/shell_postv/$postv_file);\n\tdo\n\t\tcd ${WORKDIR}/gene_evolution/check_maf/\${i}/modelA\n\t\t${WORKDIR}/software/paml-4.10.7/bin/codeml codeml-branchsite.ctl | tee logfile_codeml-branchsite.txt > /dev/null\n\t\tcd ../null\n\t\t${WORKDIR}/software/paml-4.10.7/bin/codeml codeml-branchsite_null.ctl | tee logfile_codeml-branchsite_null.txt > /dev/null\n\tdone " >> ${WORKDIR}/gene_evolution/shell_postv/${postv_file%.txt}_postv.sh; done
cd shell_postv
#submit tasks
for postv_file in $(ls ${WORKDIR}/gene_evolution/shell_postv | grep txt); do sbatch ${WORKDIR}/gene_evolution/shell_postv/${postv_file%.txt}_postv.sh; done

#calculate significance
WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_evolution/check_maf

#calculate significance
bash chi2.sh &> chi2.log

#calculate significance, use BH to correct
cd ${WORKDIR}/gene_evolution/check_maf
for i in $(ls); do cd ${WORKDIR}/gene_evolution/check_maf/${i}; pro=$(cat ${i}.chi2.log | grep df | awk '{print $6}'); echo -e $i"\t"$pro >> ${WORKDIR}/gene_evolution/PSG_codeml_raw_results.txt; done



#find the positive selected genes
cd ${WORKDIR}/gene_evolution/check_maf
for i in *; do cd ${WORKDIR}/gene_evolution/check_maf/${i}; pro=$(cat ${i}.chi2.log | grep df | awk '{print $6}'); if [ `echo "$pro < 0.05" | bc` -eq 1 ]; then echo $i >> ${WORKDIR}/gene_evolution/check_maf/PSG_paml.txt; fi; done

