#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cne

WORKDIR=/home/liunyw/project/howler_monkey
mkdir ${WORKDIR}/cne/representativetrans && cd ${WORKDIR}/cne/representativetrans


#use bed12ToFraction.py to extract the transcripts with only cds
python3 ${WORKDIR}/cne/representativetrans/bed12ToFraction.py ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${WORKDIR}/cne/representativetrans/toga.transcripts.cdsonly.hg38.bed
#get toga.transcripts.cdsonly.hg38.bed
#then extract the longest transcripts based on the length
python3 ${WORKDIR}/cne/representativetrans/extract_longesttrans.py
#finally get human_gene2representativetrans.txt
/home/liunyw/miniforge3/envs/phygenomics/bin/bedToGenePred ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed stdout | /home/liunyw/miniforge3/envs/phygenomics/bin/genePredToGtf file stdin toga.transcripts.hg38.gtf


mkdir ${WORKDIR}/cne/shell && mkdir ${WORKDIR}/cne/shell/4d_sites && mkdir ${WORKDIR}/cne/4d_sites
for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX; do echo -e '#!/bin/bash\n#SBATCH -J 4dsite_'${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/shell/4d_sites/'${i}'.4dsite.log\n#SBATCH --error='${WORKDIR}'/cne/shell/4d_sites/'${i}'.4dsite.err\n\ncd '${WORKDIR}'/cne\n\n' > ${WORKDIR}/cne/shell/4d_sites/${i}.4dsite.sh; echo "${WORKDIR}/software/phast/bin/msa_view  ${WORKDIR}/cne/mafsplit/${i}.maf --in-format MAF --4d --features ${WORKDIR}/cne/representativetrans/${i}.gff > ${WORKDIR}/cne/4d_sites/${i}.codon.ss" >> ${WORKDIR}/cne/shell/4d_sites/${i}.4dsite.sh; done;



mkdir ${WORKDIR}/cne/shell/ss2fasta && mkdir ${WORKDIR}/cne/ss2fasta
for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX; do echo -e '#!/bin/bash\n#SBATCH -J ss2fasta_'${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/shell/ss2fasta/'${i}'.ss2fasta.log\n#SBATCH --error='${WORKDIR}'/cne/shell/ss2fasta/'${i}'.ss2fasta.err\n\ncd '${WORKDIR}'/cne\n\n' > ${WORKDIR}/cne/shell/ss2fasta/${i}.ss2fasta.sh; echo "${WORKDIR}/software/phast/bin/msa_view  ${WORKDIR}/cne/4d_sites/${i}.codon.ss --in-format SS --out-format FASTA --tuple-size 1 > ${WORKDIR}/cne/ss2fasta/${i}.4dsite.fa" >> ${WORKDIR}/cne/shell/ss2fasta/${i}.ss2fasta.sh; done;

#shell files for calculating the non-conserved model
mkdir ${WORKDIR}/cne/shell/nonconmod && mkdir ${WORKDIR}/cne/nonconmod
for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX; do echo -e '#!/bin/bash\n#SBATCH -J nonconmod_'${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/shell/nonconmod/'${i}'.nonconmod.log\n#SBATCH --error='${WORKDIR}'/cne/shell/nonconmod/'${i}'.nonconmod.err\n\ncd '${WORKDIR}'/cne\n\n' > ${WORKDIR}/cne/shell/nonconmod/${i}.nonconmod.sh; echo "${WORKDIR}/software/phast/bin/phyloFit --tree \"((((((((((homSap,panTro),gorGor),ponAbe),(nomLeu,(symSyn,hylPil))),((((macMul,macFas),(manLeu,((papAnu,lopAte),theGel))),(cerMon,((chlAet,eryPat),allNig))),((colGue,pilTep),(traGer,(pygNem,rhiRox))))),((((((calJac,leoRos),sagOed),aotNan),((cebAlb,sapApe),saiBol)),aloMac),((pitPit,cacAyr),pleCup))),cepBan),((dauMad,(((lemCat,proSim),eulFla),(mirCoq,micMur))),((lorTar,nycCou),(galMoh,otoCra)))),galVar),musMus)\" --msa-format FASTA --out-root ${WORKDIR}/cne/nonconmod/${i}.nonconserved-4d ${WORKDIR}/cne/ss2fasta/${i}.4dsite.fa" >> ${WORKDIR}/cne/shell/nonconmod/${i}.nonconmod.sh; done


ls ${WORKDIR}/cne/nonconmod/* > 4d.noncons.txt
${WORKDIR}/software/phast/bin/phyloBoot --read-mods '*4d.noncons.txt' --output-average 4d.ave.noncons.mod