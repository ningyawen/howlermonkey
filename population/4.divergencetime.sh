#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/population

######################################################################################################
#filter
WORKDIR=/home/liunyw/project/howler_monkey

mkdir ${WORKDIR}/population/shell/shell_4divergence ${WORKDIR}/population/4divergence

echo -e '#!/bin/bash\n#SBATCH -J 'Howler_VCF_filter'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --mem=300G\n#SBATCH --output='${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_filter.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_filter.err'\n\n' > ${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_filter.sh; echo "${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/VariantFiltration/Howlermonkey.snp.filter.vcf.gz --recode --recode-INFO-all --stdout --max-missing 0.8 --minDP 4 --maxDP 120 --minQ 30 --minGQ 30 --min-alleles 2 --max-alleles 2 --remove-indels | gzip - > ${WORKDIR}/population/4divergence/Howlermonkey.snp.clean.vcf.gz" >> ${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_filter.sh;

#calculate sequencing depth
mkdir ${WORKDIR}/population/shell/shell_4divergence

echo -e '#!/bin/bash\n#SBATCH -J 'Howler_VCF_depth'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --mem=300G\n#SBATCH --output='${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_depth.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_depth.err'\n\n' > ${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_depth.sh; echo "${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/4divergence/Howlermonkey.snp.clean.vcf.gz --depth --out ${WORKDIR}/population/4divergence/Howlermonkey.snp.clean.depth" >> ${WORKDIR}/population/shell/shell_4divergence/Howler_VCF_depth.sh;
#
grep -v INDV Howlermonkey.snp.clean.depth.idepth | sort -k1,1 > Howlermonkey.snp.clean.depth.txt    
awk '{print $2"\t"$1}' ../HowlermonkeySpecies2SampleID.txt | sort -k1,1 > HowlermonkeySampleID2Species.txt
paste HowlermonkeySampleID2Species.txt Howlermonkey.snp.clean.depth.txt  > Howlermonkey.snp.clean.depth.txt.tmp   
# the samples with the highest depth for each species
# Alouatta_seniculus      ERS12091863
# Alouatta_puruensis      ERS12091854
# Alouatta_macconnelli    ERS12091843
# Alouatta_nigerrima      ERS12091847
# Alouatta_caraya         ERS12091835
# Alouatta_belzebul       ERS12091834
# Alouatta_discolor       ERS12091837
# Alouatta_palliata       ERS12091848
# Ateles_geoffroyi        ERS12091884

#get cds sequence
python3 bed12ToFraction.py ${WORKDIR}/TOGA_data/human_hg38_data/Alouatta_macconnelli__Guyanan_red_howler__HLaloMac1/geneAnnotation.bed howlermonkey.transcripts.cdsonly.bed
python3 extract_longesttrans.py #get howler_monkey_gene2representativetrans.txt

awk '{print $2}' howler_monkey_gene2representativetrans.txt > howler_monkey_representativetrans.txt
# awk '{print $2}' /home/liunyw/project/howler_monkey/gene_evolution/representativetrans/human_gene2representativetrans.txt > human_representativetrans.txt
fgrep -wf howler_monkey_representativetrans.txt /home/liunyw/project/howler_monkey/TOGA_data/human_hg38_data/Alouatta_macconnelli__Guyanan_red_howler__HLaloMac1/geneAnnotation.gtf > howler_monkey_longest.gtf
#get_cds.py
#the file is in /home/liunyw/project/howler_monkey/gene_evolution/representativetrans/human_gene2representativetrans.txt
#write the script to extract cds and run, split each species into a sh
bash get_cds.sh
for i in /home/liunyw/project/howler_monkey/population/shell/shell_4divergence/get_cds_*.sh; do sbatch $i; done
#extract 4d site points
python3 extract_4D_and_split_genes.py



#calculate divergence time
cd ${WORKDIR}/population/4divergence/ && mkdir mcmctree && cd mcmctree
mv ../4dsite.* . && mv ../all.4dsite.* .

WORKDIR=/home/liunyw/project/howler_monkey
#fossil correction time
# Ateles geoffroyi VS Alouatta seniculus
# Median Time:
# 14.3 MYA
# CI: (13.1 - 16.8 MYA)

#Alouatta palliata VS Alouatta seniculus
# Median Time: 4.12 MYA
# CI: (2.9 - 6.8 MYA)

#make the script to run mcmctree
echo -e '#!/bin/bash\n#SBATCH -J mcmctree1\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_4divergence/mcmctree1.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_4divergence/mcmctree1.err'\n\n' > ${WORKDIR}/population/shell/shell_4divergence/mcmctree1.sh; echo -e "export PATH=${WORKDIR}/software/paml-4.10.7/bin:\$PATH\n\ncd ${WORKDIR}/population/4divergence/mcmctree\n\n${WORKDIR}/software/paml-4.10.7/bin/mcmctree mcmctree1.ctl" >> ${WORKDIR}/population/shell/shell_4divergence/mcmctree1.sh
#submit mcmctree1.sh
sbatch ${WORKDIR}/population/shell/shell_4divergence/mcmctree1.sh

#move the output files of mcmctree to run01 directory
mkdir run01
mv 2base.t lnf out* rst* rub SeedUsed tmp0001.* run01/


cp mcmctree1.ctl mcmctree2.ctl
sed -i 's/usedata = 3/usedata = 2/g' mcmctree2.ctl
cp ./run01/out.BV ./in.BV
#make the script to run mcmctree2
echo -e '#!/bin/bash\n#SBATCH -J mcmctree2\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_4divergence/mcmctree2.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_4divergence/mcmctree2.err'\n\n' > ${WORKDIR}/population/shell/shell_4divergence/mcmctree2.sh; echo -e "export PATH=${WORKDIR}/software/paml-4.10.7/bin:\$PATH\n\ncd ${WORKDIR}/population/4divergence/mcmctree\n\n${WORKDIR}/software/paml-4.10.7/bin/mcmctree mcmctree2.ctl" >> ${WORKDIR}/population/shell/shell_4divergence/mcmctree2.sh
#submit mcmctree2.sh
sbatch ${WORKDIR}/population/shell/shell_4divergence/mcmctree2.sh



#plot the tree
python3 plot_tree.py

