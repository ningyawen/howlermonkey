#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/enrichment && mkdir lossgenes && cd lossgenes

cp ${WORKDIR}/gene_loss/howlermonkey.geneloss.noOR.geneID.txt .

/home/liunyw/miniforge3/envs/tissueenrich/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/lossgenes/tissueenrichment.r
/home/liunyw/miniforge3/envs/gprofiler/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/lossgenes/gprofiler.r


