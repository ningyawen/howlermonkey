#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_evolution/check_maf


#make the preparation files
for i in $(ls ${WORKDIR}/gene_evolution/check_maf); do cd ${WORKDIR}/gene_evolution/check_maf/; 


for i in $(ls ${WORKDIR}/gene_evolution/check_maf); do mkdir ${WORKDIR}/gene_evolution/check_maf/${i}/M0 && mkdir ${WORKDIR}/gene_evolution/check_maf/${i}/M2; echo -e "      seqfile = ../${i}.phy\n     treefile = ../howlermonkey.tree\n      outfile = out_howlermonkey_branch.txt\n\n        noisy = 3              * How much rubbish on the screen\n      verbose = 1                         * More or less detailed report\n\n      seqtype = 1              * Data type\n        ndata = 1             * Number of data sets or loci\n        icode = 0              * Genetic code\n    cleandata = 0              * Remove sites with ambiguity data?\n\n        model = 2         * Models for ω varying across lineages\n      NSsites = 0          * Models for ω varying across sites\n    CodonFreq = 7        * Codon frequencies\n      estFreq = 0        * Use observed freqs or estimate freqs by ML\n        clock = 0          * Clock model\n    fix_omega = 0         * Estimate or fix omega\n        omega = 0.5        * Initial or fixed omega" > ${WORKDIR}/gene_evolution/check_maf/${i}/M2/codeml-branch.ctl; echo -e "      seqfile = ../${i}.phy\n     treefile = ../howlermonkey.tree\n      outfile = out_M0.txt\n\n        noisy = 3              * How much rubbish on the screen\n      verbose = 1                         * More or less detailed report\n\n      seqtype = 1              * Data type\n        ndata = 1             * Number of data sets or loci\n        icode = 0              * Genetic code\n    cleandata = 0              * Remove sites with ambiguity data?\n\n        model = 0         * Models for ω varying across lineages\n      NSsites = 0          * Models for ω varying across sites\n    CodonFreq = 7        * Codon frequencies\n      estFreq = 0        * Use observed freqs or estimate freqs by ML\n        clock = 0          * Clock model\n    fix_omega = 0         * Estimate or fix omega\n        omega = 0.5          * Initial or fixed omega" > ${WORKDIR}/gene_evolution/check_maf/${i}/M0/codeml-M0.ctl; done


#make the script for calculating the positive selection
for REG_file in $(ls shell_REG | grep txt); do echo -e "cd $WORKDIR/analysis_maf \nfor i in \$(cat $WORKDIR/shell_REG/$REG_file);\n\tdo\n\t\tcd \${i}/M2\n\t\t/gpfs/home/liunyw/biosoft/paml-4.10.7/bin/codeml codeml-branch.ctl | tee logfile_codeml-branch_aloCar.txt \n\t\tcd ../M0\n\t\t/gpfs/home/liunyw/biosoft/paml-4.10.7/bin/codeml codeml-M0.ctl | tee logfile_codemlM0.txt \n\t\tcd $WORKDIR/analysis_maf\n\tdone " > shell_REG/${REG_file%.txt*}.codeml.sh; done

mkdir ${WORKDIR}/gene_evolution/shell_reg && cd ${WORKDIR}/gene_evolution/check_maf/
ls > ../shell_reg.txt && cd ../shell_reg
split -l 75 ../shell_reg.txt reg
for i in *; do mv $i ${i}.txt; done
#print the scripts to run
for reg_file in $(ls ${WORKDIR}/gene_evolution/shell_reg | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${reg_file%.txt}_reg'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_reg/${reg_file%.txt}_reg.out'\n#SBATCH --error='${WORKDIR}/gene_evolution/shell_reg/${reg_file%.txt}_reg.err'\n\n' > ${WORKDIR}/gene_evolution/shell_reg/${reg_file%.txt}_reg.sh; echo -e "cd ${WORKDIR}/gene_evolution/check_maf/ \nfor i in \$(cat ${WORKDIR}/gene_evolution/shell_reg/$reg_file);\n\tdo\n\t\tcd ${WORKDIR}/gene_evolution/check_maf/\${i}/M2\n\t\t${WORKDIR}/software/paml-4.10.7/bin/codeml codeml-branch.ctl | tee logfile_codeml-branch.txt > /dev/null\n\t\tcd ../M0\n\t\t${WORKDIR}/software/paml-4.10.7/bin/codeml codeml-M0.ctl | tee logfile_codemlM0.txt > /dev/null\n\tdone " >> ${WORKDIR}/gene_evolution/shell_reg/${reg_file%.txt}_reg.sh; done

