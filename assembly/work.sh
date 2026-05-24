#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey

cd ${WORKDIR}/assembly

hifiasm --primary -o howlermonkey -t 32 m64270e_220103_140417.hifi_reads.fasta.gz  m64270e_220104_200519.hifi_reads.fasta.gz  m64285e_211228_053543.hifi_reads.fasta.gz  m64291e_220105_041518.hifi_reads.fasta.gz

python3 nextPolish run_polish_aloMac.hifi.cfg
