#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily

########################################
mkdir maf && cd maf
for transID in ENST00000415431.FBP1 ENST00000375337.FBP2; do ${WORKDIR}/software/TOGA/supply/extract_codon_alignment.py ${WORKDIR}/FBP_genefamily/maf/human.msa.inputdir.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${transID} --reference_2bit ${WORKDIR}/software/TOGA/hg38.2bit --macse_caller "java -jar ${WORKDIR}/software/macse_v2.07.jar" -o ${WORKDIR}/FBP_genefamily/maf/${transID}.fasta &> ${WORKDIR}/FBP_genefamily/maf/${transID}.log; done
########################################

awk '{ if ($0 ~ /^>/) { split($0, a, "__"); print a[1]"_FBP2"; } else { print $0; } }' ${WORKDIR}/FBP_genefamily/maf/ENST00000375337.FBP2.fasta > ${WORKDIR}/FBP_genefamily/maf/checked_ENST00000375337.FBP2.fasta
awk '{ if ($0 ~ /^>/) { split($0, a, "__"); print a[1]"_FBP1"; } else { print $0; } }' ${WORKDIR}/FBP_genefamily/maf/ENST00000415431.FBP1.fasta > ${WORKDIR}/FBP_genefamily/maf/checked_ENST00000415431.FBP1.fasta
sed -i 's/REFERENCE/Human/g' checked_ENST00000375337.FBP2.fasta
sed -i 's/REFERENCE/Human/g' checked_ENST00000415431.FBP1.fasta

grep 'ENST00000415431.FBP1' -A 1 codon.fasta | grep 'QUERY' -A 1 | sed 's/ //g' >> checked_ENST00000415431.FBP1.fasta
grep 'ENST00000375337.FBP2.1328' -A 1 codon.fasta | grep 'QUERY' -A 1 | sed 's/ //g' >> checked_ENST00000375337.FBP2.fasta


cat checked_ENST00000415431.FBP1.fasta checked_ENST00000375337.FBP2.fasta | sed 's/-//g' | sed 's/XXX/NNN/g' > primate.FBP.fasta
java -jar ${WORKDIR}/software/macse_v2.07.jar -prog alignSequences -seq primate.FBP.fasta
