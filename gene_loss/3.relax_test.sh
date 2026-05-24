#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/gene_loss 

#geneID convert to genename
grep -f howlermonkey.geneloss.noOR.geneID.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.isoforms.tsv | awk '{print $2}'  > howlermonkey.geneloss.noOR.transID.genename.txt
#MUC is too long, so delete it
grep -v MUC howlermonkey.geneloss.noOR.transID.genename.txt > howlermonkey.geneloss.noOR.noMUC.transID.genename.txt

mkdir ${WORKDIR}/gene_loss/relax_test

cp ${WORKDIR}/gene_loss/relax_test/human.msa.inputdir.txt .
mkdir shell_getmaf && cd shell_getmaf

split -l 20 ${WORKDIR}/gene_loss/howlermonkey.geneloss.noOR.noMUC.transID.genename.txt lossgenetransID
for i in *; do mv $i ${i}.txt; done
cd ../ && mkdir raw_maf

for i in $(ls ${WORKDIR}/gene_loss/relax_test/shell_getmaf); do echo -e '#!/bin/bash\n#SBATCH -J 'maf_${i%.txt}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_getmaf/${i%.txt}.out'\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_getmaf/${i%.txt}.err'\n\n' > ${WORKDIR}/gene_loss/relax_test/shell_getmaf/${i%.txt}.sh; echo -e "cd ${WORKDIR}/gene_loss/relax_test\n\nfor transID in \$(cat ${WORKDIR}/gene_loss/relax_test/shell_getmaf/$i); do ${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/gene_loss/relax_test/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed \${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --allow_one2zero --macse_caller \"java -jar ${WORKDIR}/software/macse_v2.07.jar\" -o ${WORKDIR}/gene_loss/relax_test/raw_maf/\${transID}.fasta &> ${WORKDIR}/gene_loss/relax_test/raw_maf/\${transID}.log; done" >> ${WORKDIR}/gene_loss/relax_test/shell_getmaf/${i%.txt}.sh; done


for transID in ENST00000397910.MUC16 ENST00000536621.MUC12 ENST00000379442.MUC12; do echo -e '#!/bin/bash\n#SBATCH -J 'maf_${transID}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_getmaf/${transID}.out'\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_getmaf/${transID}.err'\n\n' > ${WORKDIR}/gene_loss/relax_test/shell_getmaf/${transID}.sh; echo -e "cd ${WORKDIR}/gene_loss/relax_test\n\n${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/gene_loss/relax_test/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --macse_caller \"java -jar ${WORKDIR}/software/macse_v2.07.jar\" -o ${WORKDIR}/gene_loss/relax_test/raw_maf/${transID}.fasta &> ${WORKDIR}/gene_loss/relax_test/raw_maf/${transID}.log" >> ${WORKDIR}/gene_loss/relax_test/shell_getmaf/${transID}.sh; done


#use HmmCleaner.pl to trim the maf file
cd ${WORKDIR}/gene_loss/relax_test/raw_maf
ls | grep fasta | sed 's/.fasta//g' > ../maf_hg_transIDforhmmcleaner.txt
cd .. && mkdir shell_hmmcleaner && cd shell_hmmcleaner && split -l 10 ../maf_hg_transIDforhmmcleaner.txt human_transID
for i in human_transID*; do mv ${i} ${i}.txt; done
for txt in $(ls | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${txt%.txt}_hmmcleaner'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_hmmcleaner/${txt%.txt}_hmmcleaner.out'\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_hmmcleaner/${txt%.txt}_hmmcleaner.err'\n\n' > ${WORKDIR}/gene_loss/relax_test/shell_hmmcleaner/${txt%.txt}_hmmcleaner.sh; echo -e "cd ${WORKDIR}/gene_loss/relax_test/raw_maf \n\nfor transcript_id in \$(cat ${WORKDIR}/gene_loss/relax_test/shell_hmmcleaner/${txt}); do singularity exec --bind ${WORKDIR}/gene_loss/relax_test/raw_maf:/test_container ${WORKDIR}/software/hmmcleaner.sif HmmCleaner.pl /test_container/\${transcript_id}.fasta; done" >> ${WORKDIR}/gene_loss/relax_test/shell_hmmcleaner/${txt%.txt}_hmmcleaner.sh; done
for i in hg38trans*_hmmcleaner.sh; do sbatch ${i}; done
mkdir ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf
mv ${WORKDIR}/gene_loss/relax_test/raw_maf/*_hmm.fasta ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf
mv ${WORKDIR}/gene_loss/relax_test/raw_maf/*_hmm.log ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf
mv ${WORKDIR}/gene_loss/relax_test/raw_maf/*_hmm.score ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf


#check if the maf files are qualified, and modify the fasta name
#make the TOGA name and latin name corresponding file, then use the latin name as the name in the maf file
echo -e "REFERENCE\tHomo_sapiens" >> ${WORKDIR}/gene_loss/relax_test/TOGAname2sciname.txt
mkdir ${WORKDIR}/gene_loss/relax_test/check_maf
ls ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf | grep hmm.fasta | sed 's/_hmm.fasta//g' > ${WORKDIR}/gene_loss/relax_test/hmmcleaner2check.txt
#check the maf files
python3 ${WORKDIR}/gene_loss/relax_test/check_maf.py ${WORKDIR}/gene_loss/relax_test/hmmcleaner2check.txt ${WORKDIR}/gene_loss/relax_test/TOGAname2sciname.txt ${WORKDIR}/gene_loss/relax_test/hmmcleaner_maf ${WORKDIR}/gene_loss/relax_test/check_maf


##
#the config files are from gene_evolution
for trans in $(ls ${WORKDIR}/gene_loss/relax_test/check_maf | sed 's/_hmm.fasta//g');         do                 mkdir ${trans} && mv ${WORKDIR}/gene_loss/relax_test/check_maf/${trans}_hmm.fasta ${trans}/${trans}.fasta;                 grep '>' ${trans}/${trans}.fasta | sed 's/>//g' > ${trans}/${trans}.species.txt;                 if [ ! -n "$(grep -vf ${trans}/${trans}.species.txt ${WORKDIR}/gene_loss/relax_test/allTOGAsciname.txt)" ]; then cat ${WORKDIR}/gene_loss/relax_test/howlermonkey.tree >> ${trans}/${trans}.prunnedtree; else /lustre/home/luyizheng/miniforge3/envs/phygenomics/bin/nw_prune -v ${WORKDIR}/gene_loss/relax_test/howlermonkey.tree $(cat ${trans}/${trans}.species.txt) >> ${trans}/${trans}.prunnedtree; fi;   sed -i 's/Alouatta_macconnelli/Alouatta_macconnelli{Foreground}/g' ${trans}/${trans}.prunnedtree;       done



#make the shell files for running the relax test
mkdir ${WORKDIR}/gene_loss/relax_test/shell_relax && cd ${WORKDIR}/gene_loss/relax_test/shell_relax/
ls ${WORKDIR}/gene_loss/relax_test/check_maf > ${WORKDIR}/gene_loss/relax_test/shell_relax.txt
split -l 10 ${WORKDIR}/gene_loss/relax_test/shell_relax.txt relax
for i in relax*; do mv $i ${i}.txt; done


for txt in $(ls ${WORKDIR}/gene_loss/relax_test/shell_relax | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${txt%.txt}_relax'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_loss/relax_test/shell_relax/${txt%.txt}.out'\n#SBATCH --error='${WORKDIR}/gene_loss/relax_test/shell_relax/${txt%.txt}.err'\n\n' > ${WORKDIR}/gene_loss/relax_test/shell_relax/${txt%.txt}.sh; echo -e "for transID in \$(cat ${WORKDIR}/gene_loss/relax_test/shell_relax/${txt}); do cd ${WORKDIR}/gene_loss/relax_test/check_maf/\${transID}; ${WORKDIR}/software/hyphy/hyphy LIBPATH=${WORKDIR}/software/hyphy/res relax --alignment ${WORKDIR}/gene_loss/relax_test/check_maf/\${transID}/\${transID}.fasta --tree ${WORKDIR}/gene_loss/relax_test/check_maf/\${transID}/\${transID}.prunnedtree --test Foreground --output ${WORKDIR}/gene_loss/relax_test/check_maf/\${transID}/\${transID}.RELAX.json &> ${WORKDIR}/gene_loss/relax_test/check_maf/\${transID}/\${transID}.log; done" >> ${WORKDIR}/gene_loss/relax_test/shell_relax/${txt%.txt}.sh; done

#run the relax test
for i in relax*.sh; do sbatch ${i}; done

