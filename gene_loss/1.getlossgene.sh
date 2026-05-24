#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/gene_loss

#get howlermonkey all loss genes
grep 'GENE' ${WORKDIR}/gene_loss/Alouatta_macconnelli__Guyanan_red_howler__HLaloMac1/loss_summ_data.tsv | grep 'L' | awk '{print $2}' > howlermonkey.geneloss.geneID.txt

#get OR genes
grep '\.OR[0-9]' ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.isoforms.tsv | awk '{print $1}' | sort -u > OR.geneID.txt 

#get howlermonkey loss genes without OR genes
grep -v -f OR.geneID.txt howlermonkey.geneloss.geneID.txt > howlermonkey.geneloss.noOR.geneID.txt

#geneID convert to genename
grep -f howlermonkey.geneloss.noOR.geneID.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.isoforms.tsv | awk '{print $2}' | awk -v FS="." '{print $2}' > howlermonkey.geneloss.noOR.genename.txt

