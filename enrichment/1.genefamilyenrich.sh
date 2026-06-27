#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/enrichment && mkdir expansiongenes && cd expansiongenes


#copy the gene family expansion results to the current directory
cp /home/liunyw/project/howler_monkey/gene_family/gamma_results/Howlermonkey_Significant_Expansion_Allgene.txt .
cp /home/liunyw/project/howler_monkey/gene_family/gamma_results/Howlermonkey_Significant_Expansion_representgene.txt .

#functional enrichment analysis
/home/liunyw/miniforge3/envs/gprofiler/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/expansiongenes/gprofiler.r
#analyze the tissue enrichment of the expansion genes using tissueenrichment.r
/home/liunyw/miniforge3/envs/tissueenrich/bin/Rscript /home/liunyw/project/howler_monkey/enrichment/expansiongenes/tissueenrichment.r


