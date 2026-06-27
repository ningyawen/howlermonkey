#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/enrichment && mkdir positivegenes && cd positivegenes

#cp the positive selection genes to the current directory
cp ${WORKDIR}/gene_evolution/PSG_all_geneID.txt .


#functional enrichment analysis
/home/liunyw/miniforge3/envs/gprofiler/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/positivegenes/gprofiler.r

#tissue-specific expression analysis
/home/liunyw/miniforge3/envs/tissueenrich/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/positivegenes/tissueenrichment.r

