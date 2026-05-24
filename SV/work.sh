#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR} && mkdir SV && cd SV

cd ${WORKDIR}/SV/target_genome
# cat CHIA.hg38.fasta CHIA.hylPil.fasta CHIA.macMul.reverse.fasta CHIA.rhiRox.fasta CHIA.calJac.fasta CHIA.aloMac.reverse.fasta > CHIA.all.fasta
cat CHIA.hg38.fasta CHIA.hylPil.fasta CHIA.rhiRox.fasta CHIA.calJac.fasta CHIA.aloMac.fasta > CHIA.all.fasta
cat ASIP.hg38.fasta ASIP.hylPil.reverse.fasta ASIP.rhiRox.fasta ASIP.calJac.reverse.fasta ASIP.aloMac.fasta > ASIP.all.fasta



#minimap2 alignment
WORKDIR=${WORKDIR}
${WORKDIR}/software/minimap2-2.29_x64-linux/minimap2 -x asm20 -c -eqx -D -P -dual=no -t 10 ${WORKDIR}/SV/target_genome/CHIA.all.fasta ${WORKDIR}/SV/target_genome/CHIA.all.fasta > ${WORKDIR}/SV/plot_ava/CHIA.target.ava.paf
${WORKDIR}/software/minimap2-2.29_x64-linux/minimap2 -k 17 -w 15 -c -eqx -D -P -dual=no -t 10 ${WORKDIR}/SV/target_genome/ASIP.all.fasta ${WORKDIR}/SV/target_genome/ASIP.all.fasta > ${WORKDIR}/SV/plot_ava/ASIP.target.ava.loose.paf


cat ${WORKDIR}/SV/target_gtf/CHIA* > ${WORKDIR}/SV/plot_ava/CHIA.anno.bed
cat ${WORKDIR}/SV/target_repeat/CHIA* > ${WORKDIR}/SV/plot_ava/CHIA.repeat.bed

cat $(ls ${WORKDIR}/SV/target_gtf/ASIP* | grep -Ev 'ASIP.calJac.gtf|ASIP.macMul.gtf|ASIP.ateGeo.gtf') > ${WORKDIR}/SV/plot_ava/ASIP.anno.bed
cat $(ls ${WORKDIR}/SV/target_repeat/ASIP* | grep -Ev 'ASIP.calJac.repeat.gff|ASIP.macMul|ASIP.ateGeo.repeat.gff') > ${WORKDIR}/SV/plot_ava/ASIP.repeat.bed

/home/liunyw/miniforge3/envs/R-base/bin/Rscript ${WORKDIR}/SV/plot_ava/plot_CHIA.r
/home/liunyw/miniforge3/envs/R-base/bin/Rscript ${WORKDIR}/SV/plot_ava/plot_ASIP.r


####################################################################################################################################################################
WORKDIR=${WORKDIR}
#extract ASIP and CHIA genes, and compare the population data with the result of howler monkey
mkdir bam_ASIP bam_CHIA
#PVHS01021646	12470	17658	ENST00000568305.ASIP.29960
#PVHS01005655	35810	37794	ENST00000369740.CHIA.6145
#convert to bedgraph, then to bw
samtools faidx ${WORKDIR}/population/Ateles_geoffroyi/rawgenome/ncbi_dataset/data/GCA_004024785.1/GCA_004024785.1_AteGeo_v1_BIUU_genomic.fna
cut -f1,2 ${WORKDIR}/population/Ateles_geoffroyi/rawgenome/ncbi_dataset/data/GCA_004024785.1/GCA_004024785.1_AteGeo_v1_BIUU_genomic.fna.fai > ateGeo.chrom.sizes

#extract bam alignment results of CHIA and ASIP
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do samtools view -h ${WORKDIR}/population/Ateles_geoffroyi/individualbam/${i}.sorted.markdup.bam PVHS01021646.1:8000-22000 > ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.bam; samtools sort ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.bam -@ 10 -o ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.sorted.bam; samtools index ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.sorted.bam ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.sorted.bam.bai; bedtools genomecov -ibam  ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.sorted.bam -bg -scale 1 >  ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.bedgraph; ${WORKDIR}/software/ucsc_tools/bedGraphToBigWig ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.bedgraph ${WORKDIR}/SV/ateGeo.chrom.sizes ${WORKDIR}/SV/bam_ASIP/ASIP.${i}.bw; done
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do samtools view -h ${WORKDIR}/population/Ateles_geoffroyi/individualbam/${i}.sorted.markdup.bam PVHS01005655.1:5000-40000 > ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.bam; samtools sort ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.bam -@ 10 -o ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.sorted.bam; samtools index ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.sorted.bam ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.sorted.bam.bai; bedtools genomecov -ibam  ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.sorted.bam -bg -scale 1 >  ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.bedgraph; ${WORKDIR}/software/ucsc_tools/bedGraphToBigWig ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.bedgraph ${WORKDIR}/SV/ateGeo.chrom.sizes ${WORKDIR}/SV/bam_CHIA/CHIA.${i}.bw; done


#plot
cd ${WORKDIR}/SV
mkdir plot_genometracks && cd plot_genometracks
grep -w PVHS01021646 ${WORKDIR}/TOGA_data/human_hg38_data/Ateles_geoffroyi__black-handed_spider_monkey__HLateGeo1/geneAnnotation.bed | sed 's/PVHS01021646/PVHS01021646.1/g' > ASIP.ateGeo.bed
grep -w PVHS01005655 ${WORKDIR}/TOGA_data/human_hg38_data/Ateles_geoffroyi__black-handed_spider_monkey__HLateGeo1/geneAnnotation.bed |  sed 's/PVHS01005655/PVHS01005655.1/g' > CHIA.ateGeo.bed
#make config files for pyGenomeTracks
mkdir track_config

for GENE in CHIA; do for ID in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do cat <<EOF > ${WORKDIR}/SV/plot_genometracks/track_config/track_config_${GENE}_${ID}.ini
[x-axis]
where = top
#title = where =top
fontsize = 10

[genes]
file = ${WORKDIR}/SV/plot_genometracks/${GENE}.ateGeo.bed
height = 0.4
title = Gene Annotation
arrow_interval = 10
style = UCSC
fontsize = 9
color = #305199

[spacer]

[bigwig file]
file = ${WORKDIR}/SV/bam_${GENE}/${GENE}.${ID}.bw
# height of the track in cm (optional value)
height = 3
title = Genome Reads
min_value = 0
max_value = 100
color = #d5927b
EOF
echo "Generated track_config_${GENE}_${ID}.ini"; done; done

for GENE in ASIP; do for ID in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do cat <<EOF > ${WORKDIR}/SV/plot_genometracks/track_config/track_config_${GENE}_${ID}.ini
[x-axis]
where = top
#title = where =top
fontsize = 10

[genes]
file = ${WORKDIR}/SV/plot_genometracks/${GENE}.ateGeo.bed
height = 0.4
title = Gene Annotation
arrow_interval = 10
style = UCSC
fontsize = 9
color = #305199

[spacer]

[bigwig file]
file = ${WORKDIR}/SV/bam_${GENE}/${GENE}.${ID}.bw
# height of the track in cm (optional value)
height = 3
title = Genome Reads
min_value = 0
max_value = 100
color = #e3e497
EOF
echo "Generated track_config_${GENE}_${ID}.ini"; done; done


for ID in ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091884; do /home/liunyw/miniforge3/envs/pygenometracks/bin/pyGenomeTracks --tracks  ${WORKDIR}/SV/plot_genometracks/track_config/track_config_ASIP_${ID}.ini --width 9 --fontSize 9 --region PVHS01021646.1:8000-22000 -o ${WORKDIR}/SV/plot_genometracks/ASIP.${ID}.bigwig.pdf; /home/liunyw/miniforge3/envs/pygenometracks/bin/pyGenomeTracks --tracks ${WORKDIR}/SV/plot_genometracks/track_config/track_config_CHIA_${ID}.ini --width 19 --fontSize 9  --region PVHS01005655.1:5000-40000 -o ${WORKDIR}/SV/plot_genometracks/CHIA.${ID}.bigwig.pdf; done

for ID in  ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do /home/liunyw/miniforge3/envs/pygenometracks/bin/pyGenomeTracks --tracks  ${WORKDIR}/SV/plot_genometracks/track_config/track_config_ASIP_${ID}.ini --width 9 --fontSize 9 --region PVHS01021646.1:8000-22000 -o ${WORKDIR}/SV/plot_genometracks/ASIP.${ID}.bigwig.pdf; /home/liunyw/miniforge3/envs/pygenometracks/bin/pyGenomeTracks --tracks ${WORKDIR}/SV/plot_genometracks/track_config/track_config_CHIA_${ID}.ini --width 19 --fontSize 9  --region PVHS01005655.1:5000-40000 -o ${WORKDIR}/SV/plot_genometracks/CHIA.${ID}.bigwig.pdf; done
####################################################################################################################################################################

