#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/population


################################################################################################
#use vcftools to filter the vcf file
mkdir ${WORKDIR}/population/shell/shell_secondfiltervcf && mkdir ${WORKDIR}/population/secondfiltervcf
echo -e '#!/bin/bash\n#SBATCH -J 'secondfiltervcf'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.err'\n\n' > ${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.sh; echo "${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/VariantFiltration/Howlermonkey.snp.filter.vcf.gz --recode --recode-INFO-all --stdout --maf 0.05 --max-missing 0.7 --minDP 4 --maxDP 1000 --minQ 30 --minGQ 0 --min-alleles 2 --max-alleles 2 --remove-indels | gzip - > ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.clean.vcf.gz" >> ${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.sh;

echo -e '#!/bin/bash\n#SBATCH -J 'secondfiltervcf'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.maxmissing.0.5.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.maxmissing.0.5.err'\n\n' > ${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.maxmissing.0.5.sh; echo "${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/VariantFiltration/Howlermonkey.snp.filter.vcf.gz --recode --recode-INFO-all --stdout --maf 0.05 --max-missing 0.5 --minDP 4 --maxDP 1000 --minQ 30 --minGQ 0 --min-alleles 2 --max-alleles 2 --remove-indels | gzip - > ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.clean.maxmissing0.5.vcf.gz" >> ${WORKDIR}/population/shell/shell_secondfiltervcf/secondfiltervcf.maxmissing.0.5.sh;


# --gzvc: input vcf file
# clean.vcf.gz is the final filtered vcf file
gunzip Howlermonkey.snp.clean.vcf.gz
gunzip Howlermonkey.snp.clean.maxmissing0.5.vcf.gz
# compress again
bgzip Howlermonkey.snp.clean.vcf
bgzip Howlermonkey.snp.clean.maxmissing0.5.vcf
# index
bcftools index Howlermonkey.snp.clean.vcf.gz
bcftools index Howlermonkey.snp.clean.maxmissing0.5.vcf.gz
# convert vcf file to fasta
${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.nomaf.clean.vcf.gz --plink --out Howlermonkey.snp.nomaf.clean.ped
python ${WORKDIR}/software/ped2fa.py Howlermonkey.snp.nomaf.clean.ped Howlermonkey.snp.nomaf.clean.fasta
${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.clean.maxmissing0.5.vcf.gz --plink --out Howlermonkey.snp.clean.maxmissing0.5.clean.ped
python ${WORKDIR}/software/ped2fa.py Howlermonkey.snp.nomaf.clean.ped Howlermonkey.snp.nomaf.clean.fasta
python ${WORKDIR}/software/ped2fa.py Howlermonkey.snp.clean.maxmissing0.5.ped Howlermonkey.snp.nomaf.clean.maxmissing0.5.fasta

################################################################################################



################################################################################################
#iqtree tree building
mkdir ${WORKDIR}/population/snptree && cd ${WORKDIR}/population/snptree && mkdir iqtree && cd iqtree
cp ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.nomaf.clean.fasta .
#convert fasta to phylip
${WORKDIR}/population/snptree/Fasta2Phylip.pl Howlermonkey.snp.nomaf.clean.fasta Howlermonkey.snp.nomaf.clean.phylip
echo -e '#!/bin/bash\n#SBATCH -J iqtree\n#SBATCH -N 1\n#SBATCH -p TMP\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=20\n#SBATCH --output='${WORKDIR}/population/snptree/iqtree/snptree_iqtree.log'\n#SBATCH --error='${WORKDIR}'/population/snptree/iqtree/snptree_iqtree.err\n\ncd '${WORKDIR}'/population/snptree/iqtree\n\n' > ${WORKDIR}/population/snptree/iqtree/snptree_iqtree.sh; echo "${WORKDIR}/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s Howlermonkey.snp.nomaf.clean.phylip -m MFP -st DNA -bb 1000 -nt 20" >> ${WORKDIR}/population/snptree/iqtree/snptree_iqtree.sh
sbatch  ${WORKDIR}/population/snptree/iqtree/snptree_iqtree.sh
cp Howlermonkey.snp.nomaf.clean.fasta.treefile Howlermonkey.species.tree
while read Species SampleID; do sed -i "s/${SampleID}/${Species}_${SampleID}/g" Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySpecies2SampleID.txt
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi_ERS12091884 > Howlermonkey.species.rooted.tree


#rapidNJ tree building
cd ${WORKDIR}/population/snptree && mkdir rapidNJ && cd rapidNJ
cp ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.nomaf.clean.fasta .
echo -e '#!/bin/bash\n#SBATCH -J rapidNJ\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/snptree/rapidNJ/snptree_rapidNJ.log'\n#SBATCH --error='${WORKDIR}'/population/snptree/rapidNJ/snptree_rapidNJ.err\n\ncd '${WORKDIR}'/population/snptree/rapidNJ\n\n' > ${WORKDIR}/population/snptree/rapidNJ/snptree_rapidNJ.sh; echo "${WORKDIR}/software/rapidNJ/bin/rapidnj -i fa Howlermonkey.snp.nomaf.clean.fasta -b 1000" >> ${WORKDIR}/population/snptree/rapidNJ/snptree_rapidNJ.sh
sbatch  ${WORKDIR}/population/snptree/rapidNJ/snptree_rapidNJ.sh
sed "s/'//g" snptree_rapidNJ.log | sed '/^$/d' > Howlermonkey.species.tree
while read Species SampleID; do sed -i "s/${SampleID}/${Species}_${SampleID}/g" Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySpecies2SampleID.txt
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi_ERS12091884 > Howlermonkey.species.rooted.tree




#VCF2Dis tree building
cd ${WORKDIR}/population/snptree && mkdir vcf2dis && cd vcf2dis
echo -e '#!/bin/bash\n#SBATCH -J vcf2dis\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/snptree/vcf2dis/snptree_vcf2dis.log'\n#SBATCH --error='${WORKDIR}'/population/snptree/vcf2dis/snptree_vcf2dis.err\n\ncd '${WORKDIR}'/population/snptree/vcf2dis\n\n' > ${WORKDIR}/population/snptree/vcf2dis/snptree_vcf2dis.sh; echo -e "singularity exec ${WORKDIR}/software/vcf2dis_1.53e.sif VCF2Dis -InPut ${WORKDIR}/population/secondfiltervcf/Howlermonkey.snp.nomaf.clean.vcf.gz -OutPut ${WORKDIR}/population/snptree/vcf2dis/Howlermonkey_p_dis.mat\n" >> ${WORKDIR}/population/snptree/vcf2dis/snptree_vcf2dis.sh

cp Howlermonkey_p_dis_2.nwk Howlermonkey.species.tree
while read Species SampleID; do sed -i "s/${SampleID}/${Species}_${SampleID}/g" Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySpecies2SampleID.txt
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi > Howlermonkey.species.rooted.tree
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi_ERS12091884 > Howlermonkey.species.rooted.tree
################################################################################################

#the species of the samples are as follows
# ERS12091834	Alouatta belzebul
# ERS12091835	Alouatta caraya
# ERS12091836	Alouatta caraya
# ERS12091837	Alouatta discolor
# ERS12091838	Alouatta discolor
# ERS12091839	Alouatta juara
# ERS12091840	Alouatta juara
# ERS12091841	Alouatta macconnelli
# ERS12091842	Alouatta macconnelli
# ERS12091843	Alouatta macconnelli
# ERS12091844	Alouatta macconnelli
# ERS12091845	Alouatta macconnelli
# ERS12091846	Alouatta belzebul
# ERS12091847	Alouatta belzebul
# ERS12091848	Alouatta palliata
# ERS12091849	Alouatta seniculus puruensis
# ERS12091850	Alouatta seniculus puruensis
# ERS12091851	Alouatta seniculus puruensis
# ERS12091852	Alouatta seniculus puruensis
# ERS12091853	Alouatta seniculus puruensis
# ERS12091854	Alouatta seniculus puruensis
# ERS12091855	Alouatta seniculus
# ERS12091856	Alouatta seniculus
# ERS12091857	Alouatta seniculus
# ERS12091858	Alouatta seniculus
# ERS12091859	Alouatta seniculus
# ERS12091860	Alouatta seniculus
# ERS12091861	Alouatta seniculus
# ERS12091862	Alouatta seniculus
# ERS12091863	Alouatta seniculus
# ERS12091864	Alouatta seniculus
# ERS12091865	Alouatta seniculus
# ERS12091866	Alouatta seniculus
# ERS12091867	Alouatta seniculus
# ERS12091868	Alouatta seniculus
# ERS12091869	Alouatta seniculus
# ERS12091884	Ateles geoffroyi

#change sample ID to species name + number
#the file is in /home/liunyw/project/howler_monkey/population/HowlermonkeySampleID2Species.txt
#so we need to replace sample ID to species name + number
cp Howlermonkey.tree Howlermonkey.species.tree
while read SampleID Species_Number; do sed -i "s/$SampleID/$Species_Number/g" Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySampleID2Species.txt
sed -i "s/'//g" Howlermonkey.species.tree
#delete empty lines
sed -i '/^$/d' Howlermonkey.species.tree
#put Ateles_geoffroyi at the outside
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi > Howlermonkey.species.rooted.tree

cp Howlermonkey.tree Artical_Howlermonkey.species.tree
while read Species_Number SampleID; do sed -i "s/$SampleID/$Species_Number/g" Artical_Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySampleID2Species_Artical.txt



#window tree building
#using parallel method to build tree
################################################################################################
#window tree building
WORKDIR=/home/liunyw/project/howler_monkey
mkdir windowtree10kb windowtree50kb windowtree100kb
cd ${WORKDIR}/population/windowtree500kb && bedtools makewindows -g ../aloMac.sm.fa.fai -w 500000 > howlermonkey500kb.bed && bash ${WORKDIR}/population/windowtree500kb/split_500kb_windowvcf.sh
cd ${WORKDIR}/population/windowtree50kb && bedtools makewindows -g ../aloMac.sm.fa.fai -w 50000 > howlermonkey50kb.bed && bash ${WORKDIR}/population/windowtree50kb/split_50kb_windowvcf.sh
cd ${WORKDIR}/population/windowtree100kb && bedtools makewindows -g ../aloMac.sm.fa.fai -w 100000 > howlermonkey100kb.bed && bash ${WORKDIR}/population/windowtree100kb/split_100kb_windowvcf.sh
#run the script to split the window
#convert vcf to fasta
mkdir ${WORKDIR}/population/windowtree500kb/split_500kb_fasta && cd ${WORKDIR}/population/windowtree500kb/split_500kb_fasta
for vcf in $(ls ${WORKDIR}/population/windowtree500kb/split_500kb_vcfs); do ${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/windowtree500kb/split_500kb_vcfs/${vcf} --plink --out ${vcf%.vcf.gz*} &> ${vcf%.vcf.gz*}.out; python ${WORKDIR}/software/ped2fa.py ${vcf%.vcf.gz*}.ped ${vcf%.vcf.gz*}.fasta; done
mkdir ${WORKDIR}/population/windowtree100kb/split_100kb_fasta && cd ${WORKDIR}/population/windowtree100kb/split_100kb_fasta
for vcf in $(ls ${WORKDIR}/population/windowtree100kb/split_100kb_vcfs); do ${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/windowtree100kb/split_100kb_vcfs/${vcf} --plink --out ${vcf%.vcf.gz*} &> ${vcf%.vcf.gz*}.out; python ${WORKDIR}/software/ped2fa.py ${vcf%.vcf.gz*}.ped ${vcf%.vcf.gz*}.fasta; done
mkdir ${WORKDIR}/population/windowtree50kb/split_50kb_fasta && cd ${WORKDIR}/population/windowtree50kb/split_50kb_fasta
for vcf in $(ls ${WORKDIR}/population/windowtree50kb/split_50kb_vcfs); do ${WORKDIR}/software/vcftools/vcftools --gzvcf ${WORKDIR}/population/windowtree50kb/split_50kb_vcfs/${vcf} --plink --out ${vcf%.vcf.gz*} &> ${vcf%.vcf.gz*}.out; python ${WORKDIR}/software/ped2fa.py ${vcf%.vcf.gz*}.ped ${vcf%.vcf.gz*}.fasta; done
#iqtree tree building
mkdir ${WORKDIR}/population/windowtree100kb/split_100kb_iqtree ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree && cd ${WORKDIR}/population/windowtree100kb 
ls ${WORKDIR}/population/windowtree100kb/split_100kb_fasta/ | grep fasta > ${WORKDIR}/population/windowtree100kb/howlermonkey100kb.ID.txt
cd ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree && split -l 200 ../howlermonkey100kb.ID.txt howlermonkey100kbsplit
for i in howlermonkey100kbsplit*; do mv $i ${i}.txt; done
for i in $(ls ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i%.txt*}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/${i%.txt*}.log'\n#SBATCH --error='${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/${i%.txt*}.err'\n\n' > ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/${i%.txt*}.sh; echo -e "cd  ${WORKDIR}/population/windowtree100kb/split_100kb_iqtree\n\nfor fasta in \$(cat ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/${i}); do ${WORKDIR}/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s ${WORKDIR}/population/windowtree100kb/split_100kb_fasta/\${fasta} -st DNA -m TEST -nt 10 -bb 1000 -pre \${fasta%.fasta*};  done" >> ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/${i%.txt*}.sh; done
for i in ${WORKDIR}/population/windowtree100kb/shell_100kb_iqtree/*.sh; do sbatch $i; done
#500kb window
mkdir ${WORKDIR}/population/windowtree500kb/split_500kb_iqtree ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree && cd ${WORKDIR}/population/windowtree500kb 
ls ${WORKDIR}/population/windowtree500kb/split_500kb_fasta/ | grep fasta > ${WORKDIR}/population/windowtree500kb/howlermonkey500kb.ID.txt
cd ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree && split -l 100 ../howlermonkey500kb.ID.txt howlermonkey500kbsplit
for i in howlermonkey500kbsplit*; do mv $i ${i}.txt; done
for i in $(ls ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i%.txt*}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/${i%.txt*}.log'\n#SBATCH --error='${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/${i%.txt*}.err'\n\n' > ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/${i%.txt*}.sh; echo -e "cd  ${WORKDIR}/population/windowtree500kb/split_500kb_iqtree\n\nfor fasta in \$(cat ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/${i}); do ${WORKDIR}/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s ${WORKDIR}/population/windowtree500kb/split_500kb_fasta/\${fasta} -st DNA -m TEST -nt 10 -bb 1000 -pre \${fasta%.fasta*};  done" >> ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/${i%.txt*}.sh; done
for i in ${WORKDIR}/population/windowtree500kb/shell_500kb_iqtree/*.sh; do sbatch $i; done
#50kb window
mkdir ${WORKDIR}/population/windowtree50kb/split_50kb_iqtree ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree && cd ${WORKDIR}/population/windowtree50kb 
ls ${WORKDIR}/population/windowtree50kb/split_50kb_fasta/ | grep fasta > ${WORKDIR}/population/windowtree50kb/howlermonkey50kb.ID.txt
cd ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree && split -l 200 ../howlermonkey50kb.ID.txt howlermonkey50kbsplit
for i in howlermonkey50kbsplit*; do mv $i ${i}.txt; done
for i in $(ls ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree | grep txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i%.txt*}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/${i%.txt*}.log'\n#SBATCH --error='${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/${i%.txt*}.err'\n\n' > ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/${i%.txt*}.sh; echo -e "cd  ${WORKDIR}/population/windowtree50kb/split_50kb_iqtree\n\nfor fasta in \$(cat ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/${i}); do ${WORKDIR}/software/iqtree-3.0.0-Linux-intel/bin/iqtree3 -s ${WORKDIR}/population/windowtree50kb/split_50kb_fasta/\${fasta} -st DNA -m TEST -nt 10 -bb 1000 -pre \${fasta%.fasta*};  done" >> ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/${i%.txt*}.sh; done
for i in ${WORKDIR}/population/windowtree50kb/shell_50kb_iqtree/*.sh; do sbatch $i; done




######Astral tree building######
#total 28503 trees
#filter Bootstrap values
for window in 50kb 100kb 500kb; do cat ${WORKDIR}/population/windowtree${window}/split_${window}_iqtree/*treefile > ${WORKDIR}/population/windowtree${window}/all.treefile; /home/miniforge3/envs/phygenomics/bin/nw_ed ${WORKDIR}/population/windowtree${window}/all.treefile 'i & b<=10' o > ${WORKDIR}/population/windowtree${window}/all-BS10.treefile; mkdir ${WORKDIR}/population/windowtree${window}/astral ; mv ${WORKDIR}/population/windowtree${window}/all-BS10.treefile  ${WORKDIR}/population/windowtree${window}/astral; done

#Astral tree building
for window in 50kb 100kb 500kb; do echo -e '#!/bin/bash\n#SBATCH -J astral_'${window}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/population/windowtree'${window}'/astral.log\n#SBATCH --error='${WORKDIR}'/population/windowtree'${window}'/astral.err\n\ncd '${WORKDIR}'/population/windowtree'${window}'/astral\n\n' > ${WORKDIR}/population/windowtree${window}/astral.sh; echo "java -jar ${WORKDIR}/software/Astral/astral.5.7.8.jar -i all-BS10.treefile -o astral-BS10.treefile" >> ${WORKDIR}/population/windowtree${window}/astral.sh; done

cp astral-BS10.treefile Howlermonkey.species.tree
while read Species SampleID; do sed -i "s/${SampleID}/${Species}_${SampleID}/g" Howlermonkey.species.tree; done < /home/liunyw/project/howler_monkey/population/HowlermonkeySpecies2SampleID.txt
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi > Howlermonkey.species.rooted.tree
/home/miniforge3/envs/phygenomics/bin/nw_reroot Howlermonkey.species.tree Ateles_geoffroyi_ERS12091884 > Howlermonkey.species.rooted.tree
######Astral tree building######










































