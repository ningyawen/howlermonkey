#!/bin/bash


WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/FBP_genefamily && mkdir bam_FBP1 && cd bam_FBP1

#make chrom.sizes file
cut -f1,2 /home/liunyw/project/howler_monkey/aloSen.sm.fa.fai > aloMac.chrom.sizes
cp /home/liunyw/project/howler_monkey/assess/flagger/hmm_flagger_outputs/final_flagger_prediction.bed flagger_state.bed
#extract FBP1's flagger state bed file
grep ENST00000415431.FBP1 geneAnnotation.bed | awk '{print $1"\t"$2"\t"$3}' > target_regions.bed
# bedtools intersect -a flagger_state.bed -b target_regions.bed -wa -wb > FBP1_flagger.bed
bedtools intersect -a target_regions.bed -b flagger_state.bed -wb | awk 'BEGIN{OFS="\t"} {print $1, $2, $3, $7, $8, $9, $2, $3, $12}' > FBP1_flagger.bed

#calculate average depth
echo -e '#!/bin/bash\n#SBATCH -J Howler_hifi_baseline\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=20\n#SBATCH --mem=160G\n#SBATCH --output='${WORKDIR}'/FBP_genefamily/bam_FBP1/shell/hifi_baseline.log\n#SBATCH --error='${WORKDIR}'/FBP_genefamily/bam_FBP1/shell/hifi_baseline.err\n\n' > ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/hifi_baseline.sh; echo -e "singularity run /home/liunyw/project/howler_monkey/software/mosdepth_latest.sif mosdepth -n -t 20 -x -Q 20 hifi_baseline ${WORKDIR}/assess/flagger/aloMac.onestep.bam" >> ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/hifi_baseline.sh; 
sbatch ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/hifi_baseline.sh;
# singularity run /home/liunyw/project/howler_monkey/software/mosdepth_latest.sif mosdepth -n -x -Q 20 hifi_baseline ${WORKDIR}/assess/flagger/aloMac.onestep.bam

#extract four FBP1 bam alignment results
# grep ENST00000415431.FBP1 geneAnnotation.bed
# ptg000016l:97729276-97763435    ENST00000415431.FBP1.111
# ptg000003l:94465588-94485116    ENST00000415431.FBP1.662
# ptg000046l:14967583-15000958    ENST00000415431.FBP1.1328
# ptg000005l:136249994-136282770  ENST00000415431.FBP1.2946
#/home/liunyw/project/howler_monkey/assess/flagger/aloMac.onestep.bam


grep ENST00000415431.FBP1 geneAnnotation.bed | awk '{print $1":"$2"-"$3"\t"$4}' | sed 's/ENST00000415431.//g' | while read bed name; do echo -e '#!/bin/bash\n#SBATCH -J 'Howler_${name}_depth'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --mem=160G\n#SBATCH --output='${WORKDIR}/FBP_genefamily/bam_FBP1/shell/get_${name}_depth.log'\n#SBATCH --error='${WORKDIR}/FBP_genefamily/bam_FBP1/shell/get_${name}_depth.err'\n\n' > ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/get_${name}_depth.sh; echo -e "samtools view -h ${WORKDIR}/assess/flagger/aloMac.onestep.bam $bed > ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.bam\nsamtools sort ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.bam -@ 10 -o ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.sorted.bam\nsamtools index ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.sorted.bam ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.sorted.bam.bai\n/home/liunyw/project/howler_monkey/software/bedtools genomecov -ibam ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.sorted.bam -bg -scale 1 > ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.bedgraph\n${WORKDIR}/software/ucsc_tools/bedGraphToBigWig ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.bedgraph ${WORKDIR}/FBP_genefamily/bam_FBP1/aloMac.chrom.sizes ${WORKDIR}/FBP_genefamily/bam_FBP1/${name}.bw;" >> ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/get_${name}_depth.sh; done

for i in ${WORKDIR}/FBP_genefamily/bam_FBP1/shell/get_*_depth.sh; do sbatch $i; done


#plot genome tracks
cd ${WORKDIR}/FBP_genefamily/bam_FBP1
mkdir plot_genometracks && cd plot_genometracks
for i in ENST00000415431.FBP1.111 ENST00000415431.FBP1.662 ENST00000415431.FBP1.1328 ENST00000415431.FBP1.2946; do grep -w $i geneAnnotation.bed | sed 's/ENST00000415431.//g' > ${i#ENST00000415431.}.bed; done


mkdir track_config
WORKDIR=/home/liunyw/project/howler_monkey

for GENE in FBP1.111 FBP1.662 FBP1.1328 FBP1.2946; do cat <<EOF > ${WORKDIR}/FBP_genefamily/bam_FBP1/${GENE}.ini
[x-axis]
where = top
#title = where =top
fontsize = 10

[genes]
file = /home/liunyw/project/howler_monkey/FBP_genefamily/bam_FBP1/${GENE}.bed
height = 0.4
title = Gene Annotation
arrow_interval = 10
style = UCSC
fontsize = 9
color = #305199

[spacer]

[bigwig file]
file = /home/liunyw/project/howler_monkey/FBP_genefamily/bam_FBP1/${GENE}.bw
# height of the track in cm (optional value)
height = 3
title = HiFi Coverage
min_value = 0
max_value = 50
color = #d5927b

[HiFi_Baseline]
file_type = hlines
y_values = 38.6
color = gray
line_style = dashed
overlay_previous = yes
min_value = 0
max_value = 50

[spacer]

[Flagger_State]
file = /home/liunyw/project/howler_monkey/FBP_genefamily/bam_FBP1/FBP1_flagger.bed
height = 0.3
title = flagger state
color = bed_rgb
type = bed
display = collapsed

EOF
echo "Generated ${GENE}.ini"; done;




grep ENST00000415431.FBP1 geneAnnotation.bed | awk '{print $1":"$2"-"$3"\t"$4}' | sed 's/ENST00000415431.//g' | while read bed name; do echo "/home/liunyw/miniforge3/envs/pygenometracks/bin/pyGenomeTracks --tracks  ${WORKDIR}/FBP_genefamily/bam_FBP1/${name#ENST00000415431.}.ini --fontSize 9 --region $bed -o ${WORKDIR}/FBP_genefamily/bam_FBP1/${name#ENST00000415431.}.bigwig.pdf" | sh; done

