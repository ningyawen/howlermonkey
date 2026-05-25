#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/population

mkdir Dsuite && cd Dsuite

#exclude the results of Alouatta juara and Alouatta seniculus puruensis 3 and Alouatta seniculus puruensis 4
bcftools view -S SampleID.txt /home/liunyw/project/howler_monkey/population/secondfiltervcf/Howlermonkey.snp.nomaf.clean.vcf.gz -Ov > Howlermonkey.snp.nomaf.clean.dsuite.vcf
bgzip Howlermonkey.snp.nomaf.clean.dsuite.vcf

#calculate Dsuite
sbatch /home/liunyw/project/howler_monkey/population/shell/shell_Dsuite/Dsuite.sh

#calculate f-branch value
cd ${WORKDIR}/population/Dsuite
/home/liunyw/project/howler_monkey/software/Dsuite/Build/Dsuite Fbranch HowlerSpecies.nwk sample_tree.txt > fbranch.out
#plot f-branch figure
/home/liunyw/project/howler_monkey/software/Dsuite/utils/dtools.py fbranch.out HowlerSpecies.nwk --outgroup Outgroup --use_distances --dpi 1200 --tree-label-size 30

