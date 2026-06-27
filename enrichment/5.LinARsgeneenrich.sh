#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/enrichment && mkdir LinARs && cd LinARs

awk '{print $1}' ${WORKDIR}/cne/GREAT/20250713-public-4.0.4-pjYupe-hg38-all-gene.txt | grep -v '#' > ${WORKDIR}/enrichment/LinARs/LinARs.genename.txt

grep -wf ${WORKDIR}/enrichment/LinARs/LinARs.genename.txt ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.isoforms.tsv | awk '{print $1}' | sort -u > ${WORKDIR}/enrichment/LinARs/LinARs.geneID.txt

/home/liunyw/miniforge3/envs/gprofiler/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/LinARs/gprofiler.r
/home/liunyw/miniforge3/envs/tissueenrich/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/LinARs/tissueenrichment.r


