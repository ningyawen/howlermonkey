#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/enrichment && mkdir reg && cd reg

#functional enrichment analysis
/home/liunyw/miniforge3/envs/gprofiler/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/reg/gprofiler.r

#tissue-specific expression analysis
/home/liunyw/miniforge3/envs/tissueenrich/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/reg/tissueenrichment.r

