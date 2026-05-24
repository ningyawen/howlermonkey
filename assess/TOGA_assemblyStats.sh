#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/assemblyStats

mkdir assemblyStats && cd assemblyStats

####################################################################################################################################################
#make a directory to store the data
mkdir vs_hg_all
#copy all the files
for i in $(ls ${WORKDIR}/TOGA_data/human_hg38_data); do mkdir vs_hg_all/${i}; cp ${WORKDIR}/TOGA_data/human_hg38_data/${i}/loss_summ_data.tsv.gz vs_hg_all/${i}; echo "vs_hg_all/"$i >> primate_all_TOGA_basehg38.txt; gunzip vs_hg_all/${i}/loss_summ_data.tsv.gz; done

awk -v FS="__" '{print $0"\t"$3}' primate_all_TOGA_basehg38.txt | sed 's/vs_hg_all\///g' > namemap_basehg38.txt

python3 ${WORKDIR}/software/TOGA/supply/TOGA_assemblyStats.py primate_all_TOGA_basehg38.txt -m stats -aN namemap_basehg38.txt -ances ${WORKDIR}/software/TOGA/TOGAInput/human_hg38/Ancestral_placental.txt -i

#plot the bar chart sorted by the number of intact genes
awk -v FS="__" '{print $3"\t"$1"_"$3}' primate_all_TOGA_basehg38.txt | sed 's/vs_hg_all\///g' > HillerID2Speciesname_basehg38.txt

#plot the bar chart sorted by the number of intact genes
python3 /lustre/home/luyizheng/liunyw/project/howler_monkey/assemblyStats/plot_sorted_assembly.py

#select the assemblies to analyze
awk '{if($2>=15000)print $0}' primate_all_TOGA_basehg38_stats.tsv > checked_primate_all_TOGA_basehg38_stats.tsv
#manually delete some duplicate species, and only keep one species per genus
#manual_checked_primate_all_TOGA_basehg38_stats.tsv
awk '{print $1}' manual_checked_primate_all_TOGA_basehg38_stats.tsv | grep -v 'intact' > manual_checked_primate_all_TOGA_basehg38_stats.HillerID.txt

#plot the main figure
grep -wf manual_checked_primate_all_TOGA_basehg38_stats.HillerID.txt namemap_basehg38.txt | awk '{print $2"\t"$1}' > manual_checked_primate_species_HillerID2onlySpeciesname_basehg38.txt
python3 ${WORKDIR}/assemblyStats/plot_mainfig_assemblyStats.py
####################################################################################################################################################


