#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/gene_evolution/

awk '{print $2}' ${WORKDIR}/gene_evolution/representativetrans/human_gene2representativetrans.txt > ${WORKDIR}/gene_evolution/representativetransID.txt
mkdir ${WORKDIR}/gene_evolution/shell_getmaf && cd ${WORKDIR}/gene_evolution/shell_getmaf
split -l 100 ../representativetransID.txt transID
for i in *; do mv $i ${i}.txt; done
cd ../ && mkdir raw_maf

#mkdir the input file for TOGA to extract codon fasta
for i in $(cat ${WORKDIR}/assemblyStats/futher_analysis_TOGA.txt); do echo "${WORKDIR}/TOGA_data/human_hg38_data/${i}" >> ${WORKDIR}/gene_evolution/human.msa.inputdir.txt; done
gunzip */*.gz
for i in $(cat ${WORKDIR}/assemblyStats/futher_analysis_TOGA.txt); do gunzip ${WORKDIR}/TOGA_data/human_hg38_data/${i}/geneInactivatingMutations.tsv.gz; ${WORKDIR}/software/TOGA/supply/mut_index.py ${WORKDIR}/TOGA_data/human_hg38_data/${i}/geneInactivatingMutations.tsv ${WORKDIR}/TOGA_data/human_hg38_data/${i}/inact_mut_data.hdf5; gunzip ${WORKDIR}/TOGA_data/human_hg38_data/${i}/codonAlignments.fa.gz; cp ${WORKDIR}/TOGA_data/human_hg38_data/${i}/codonAlignments.fa ${WORKDIR}/TOGA_data/human_hg38_data/${i}/codon.fasta; gunzip ${WORKDIR}/TOGA_data/human_hg38_data/${i}/orthologsClassification.tsv.gz; cp ${WORKDIR}/TOGA_data/human_hg38_data/${i}/orthologsClassification.tsv ${WORKDIR}/TOGA_data/human_hg38_data/${i}/orthology_classification.tsv; done


#run the command on the cluster
for i in $(ls ${WORKDIR}/gene_evolution/shell_getmaf); do echo -e '#!/bin/bash\n#SBATCH -J 'maf_${i%.txt}'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_getmaf/${i%.txt}.out'\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_getmaf/${i%.txt}.err'\n\n' > ${WORKDIR}/gene_evolution/shell_getmaf/${i%.txt}.sh; echo -e "cd ${WORKDIR}/gene_evolution\n\nfor transID in \$(cat ${WORKDIR}/gene_evolution/shell_getmaf/$i); do ${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/gene_evolution/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed \${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --macse_caller \"java -jar ${WORKDIR}/software/macse_v2.07.jar\" -o ${WORKDIR}/gene_evolution/raw_maf/\${transID}.fasta &> ${WORKDIR}/gene_evolution/raw_maf/\${transID}.log; done" >> ${WORKDIR}/gene_evolution/shell_getmaf/${i%.txt}.sh; done



#######################################################################################################################################
#HmmCleaner.pl trimming
cd ${WORKDIR}/gene_evolution/raw_maf
ls | grep fasta | sed 's/.fasta//g' > ../maf_hg_transIDforhmmcleaner.txt
cd .. && mkdir shell_hmmcleaner && cd shell_hmmcleaner && split -l 100 ../maf_hg_transIDforhmmcleaner.txt human_transID
for i in human_transID*; do mv ${i} ${i}.txt; done
for txt in $(ls | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${txt%.txt}_hmmcleaner'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_hmmcleaner/${txt%.txt}_hmmcleaner.out'\n#SBATCH --output='${WORKDIR}/gene_evolution/shell_hmmcleaner/${txt%.txt}_hmmcleaner.err'\n\n' > ${WORKDIR}/gene_evolution/shell_hmmcleaner/${txt%.txt}_hmmcleaner.sh; echo -e "cd ${WORKDIR}/gene_evolution/raw_maf \n\nfor transcript_id in \$(cat ${WORKDIR}/gene_evolution/shell_hmmcleaner/${txt}); do singularity exec --bind ${WORKDIR}/gene_evolution/raw_maf:/test_container ${WORKDIR}/software/hmmcleaner.sif HmmCleaner.pl /test_container/\${transcript_id}.fasta; done" >> ${WORKDIR}/gene_evolution/shell_hmmcleaner/${txt%.txt}_hmmcleaner.sh; done
for i in hg38trans*_hmmcleaner.sh; do sbatch ${i}; done
mkdir ${WORKDIR}/gene_evolution/hmmcleaner_maf
mv ${WORKDIR}/gene_evolution/raw_maf/*_hmm.fasta ${WORKDIR}/gene_evolution/hmmcleaner_maf
mv ${WORKDIR}/gene_evolution/raw_maf/*_hmm.log ${WORKDIR}/gene_evolution/hmmcleaner_maf
mv ${WORKDIR}/gene_evolution/raw_maf/*_hmm.score ${WORKDIR}/gene_evolution/hmmcleaner_maf


#check the maf files are qualified, and modify the fasta name
#make the TOGA name and scientific name corresponding file, use the scientific name as the name of the maf file
awk -v FS="\/" '{print $NF}' human.msa.inputdir.txt | awk -v FS="__" '{print $0"\t"$1}' > TOGAname2sciname.txt
echo -e "REFERENCE\tHomo_sapiens" >> ${WORKDIR}/gene_evolution/TOGAname2sciname.txt
mkdir ${WORKDIR}/gene_evolution/check_maf
ls ${WORKDIR}/gene_evolution/hmmcleaner_maf | grep hmm.fasta | sed 's/_hmm.fasta//g' > ${WORKDIR}/gene_evolution/hmmcleaner2check.txt
#
python3 ${WORKDIR}/gene_evolution/script/check_maf.py ${WORKDIR}/gene_evolution/hmmcleaner2check.txt ${WORKDIR}/gene_evolution/TOGAname2sciname.txt ${WORKDIR}/gene_evolution/hmmcleaner_maf ${WORKDIR}/gene_evolution/check_maf
#######################################################################################################################################


