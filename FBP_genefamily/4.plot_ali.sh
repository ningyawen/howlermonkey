#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily

########################################
mkdir plot_align && cd plot_align
for transID in ENST00000415431.FBP1 ; do ${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/FBP_genefamily/plot_align/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --macse_caller "java -jar ${WORKDIR}/software/macse_v2.07.jar" -o ${WORKDIR}/FBP_genefamily/plot_align/${transID}.fasta &> ${WORKDIR}/FBP_genefamily/plot_align/${transID}.log; done
########################################

awk '{ if ($0 ~ /^>/) { split($0, a, "__"); print a[1]"_FBP1"; } else { print $0; } }' ${WORKDIR}/FBP_genefamily/plot_align/ENST00000415431.FBP1.fasta > ${WORKDIR}/FBP_genefamily/plot_align/checked_ENST00000415431.FBP1.fasta
sed -i 's/REFERENCE/Human/g' checked_ENST00000415431.FBP1.fasta

grep 'ENST00000415431.FBP1' -A 1 codon.fasta | grep 'QUERY' -A 1 | sed 's/ //g' >> checked_ENST00000415431.FBP1.fasta

cat checked_ENST00000415431.FBP1.fasta | sed 's/-//g' | sed 's/XXX/NNN/g' > primate.FBP1.fasta
java -jar ${WORKDIR}/software/macse_v2.07.jar -prog alignSequences -seq primate.FBP1.fasta

seqkit translate --frame 1 /home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.nucl.fa | seqkit seq -w 0 > /home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plot.aa.fa

/home/liunyw/miniforge3/envs/R-base/bin/Rscript /home/liunyw/project/howler_monkey/FBP_genefamily/plot_align/plotmsa.r
