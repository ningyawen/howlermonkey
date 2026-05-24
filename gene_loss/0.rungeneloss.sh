#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey


${WORKDIR}/software/make_lastz_chains/make_chains.py human aloMac ${WORKDIR}/gene_loss/2bit/hg38.2bit ${WORKDIR}/gene_loss/2bit/aloMac.2bit --project_dir human_aloMac --cluster_executor slurm --cluster_queue CU

${WORKDIR}/software/TOGA/toga.py ${WORKDIR}/gene_loss/human.aloMac.final.chain.gz ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.transcripts.bed ${WORKDIR}/gene_loss/2bit/hg38.2bit ${WORKDIR}/gene_loss/2bit/aloMac.2bit --kt --pn Alouatta_macconnelli__Guyanan_red_howler__HLaloMac1 -i ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.isoforms.tsv --nc ${WORKDIR}/software/TOGA/nextflow_config_files --cb 5,15,50,100,250 --cjn 1000 --u12 ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/toga.U12introns.tsv --ms