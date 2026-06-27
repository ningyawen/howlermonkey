#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily

mkdir genetree && cd genetree

/home/liunyw/project/howler_monkey/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s ${WORKDIR}/FBP_genefamily/maf/primate.FBP_NT.fasta -pre howlerFBP
/home/liunyw/project/howler_monkey/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s ${WORKDIR}/FBP_genefamily/maf/primate.FBP_NT.fasta -pre howlerFBPMFP -m MFP


