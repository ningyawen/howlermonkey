#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_evolution && mkdir aBSREL

#check the maf files are qualified, and move to aBSREL directory
python3 ${WORKDIR}/gene_evolution/script/check_maf.py ${WORKDIR}/gene_evolution/hmmcleaner2check.txt ${WORKDIR}/gene_evolution/TOGAname2sciname.txt ${WORKDIR}/gene_evolution/hmmcleaner_maf ${WORKDIR}/gene_evolution/aBSREL

#prepare the files for calculation
for trans in $(ls ${WORKDIR}/gene_evolution/aBSREL | sed 's/_hmm.fasta//g');         do                 mkdir ${trans} && mv ${WORKDIR}/gene_evolution/aBSREL/${trans}_hmm.fasta ${trans}/${trans}.fasta;                 grep '>' ${trans}/${trans}.fasta | sed 's/>//g' > ${trans}/${trans}.species.txt;                 if [ ! -n "$(grep -vf ${trans}/${trans}.species.txt ${WORKDIR}/gene_evolution/allTOGAsciname.txt)" ]; then cat ${WORKDIR}/gene_evolution/howlermonkey.tree >> ${trans}/${trans}.prunnedtree; else /home/liunyw/miniforge3/envs/phygenomics/bin/nw_prune -v ${WORKDIR}/gene_evolution/howlermonkey.tree $(cat ${trans}/${trans}.species.txt) >> ${trans}/${trans}.prunnedtree; fi;         done




#make the shell files for calculation
mkdir ${WORKDIR}/gene_evolution/shell_aBSREL && cd ${WORKDIR}/gene_evolution/aBSREL/
ls > ../shell_aBSREL.txt && cd ../shell_aBSREL
split -l 150 ../shell_aBSREL.txt transIDfile
for i in *; do mv $i ${i}.txt; done

for txt in $(ls ${WORKDIR}/gene_evolution/shell_aBSREL | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${txt%.txt}_absrel'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_aBSREL/${txt%.txt}.out'\n#SBATCH --error='${WORKDIR}/gene_evolution/shell_aBSREL/${txt%.txt}.err'\n\n' > ${WORKDIR}/gene_evolution/shell_aBSREL/${txt%.txt}.sh; echo -e "for transID in \$(cat ${WORKDIR}/gene_evolution/shell_aBSREL/${txt}); do cd ${WORKDIR}/gene_evolution/aBSREL/\${transID}; ${WORKDIR}/software/hyphy/hyphy LIBPATH=${WORKDIR}/software/hyphy/res absrel --alignment ${WORKDIR}/gene_evolution/aBSREL/\${transID}/\${transID}.fasta --tree ${WORKDIR}/gene_evolution/aBSREL/\${transID}/\${transID}.prunnedtree --output ${WORKDIR}/gene_evolution/aBSREL/\${transID}/\${transID}.ABSREL.json &> ${WORKDIR}/gene_evolution/aBSREL/\${transID}/\${transID}.log; done" >> ${WORKDIR}/gene_evolution/shell_aBSREL/${txt%.txt}.sh; done
#batch run
for i in transIDfile*.sh; do sbatch ${i}; done