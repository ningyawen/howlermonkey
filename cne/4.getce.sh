#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cne


mkdir ELEMENTS SCORES

mkdir ${WORKDIR}/cne/ELEMENTS ${WORKDIR}/cne/SCORES ${WORKDIR}/cne/shell/getce

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY; do echo -e '#!/bin/bash\n#SBATCH -J getce_'${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/shell/getce/'${i}'.getce.log\n#SBATCH --error='${WORKDIR}'/cne/shell/getce/'${i}'.getce.err\n\ncd '${WORKDIR}'/cne\n\n' > ${WORKDIR}/cne/shell/getce/${i}.getce.sh; echo "${WORKDIR}/software/phast/bin/phastCons --most-conserved ${WORKDIR}/cne/ELEMENTS/${i}.maf.bed --score ${WORKDIR}/cne/mafsplit/${i}.maf primate.ave.cons.mod,primate.ave.noncons.mod > ${WORKDIR}/cne/SCORES/${i}.maf.wig" >> ${WORKDIR}/cne/shell/getce/${i}.getce.sh; done

#merge ce
mkdir ${WORKDIR}/cne/mergece && cd ${WORKDIR}/cne/ELEMENTS
for i in *bed; do bedtools merge -i ${WORKDIR}/cne/ELEMENTS/$i -d 10 > ${WORKDIR}/cne/mergece/$i; done

#extract cne, exclude the coding region
mkdir ${WORKDIR}/cne/cne
cd ${WORKDIR}/cne/representativetrans
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ensGene.gtf.gz
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.knownGene.gtf.gz
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz
wget -c https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.refGene.gtf.gz

gunzip hg38.ensGene.gtf.gz hg38.knownGene.gtf.gz  hg38.ncbiRefSeq.gtf.gz  hg38.refGene.gtf.gz
for gtf in hg38.ensGene.gtf hg38.knownGene.gtf  hg38.ncbiRefSeq.gtf  hg38.refGene.gtf; do grep -v  awk '{if($3=="exon")print $1"\t"$4-1-50"\t"$5+50}' ${WORKDIR}/cne/representativetrans/${gtf} > ${WORKDIR}/cne/representativetrans/${gtf%.gtf*}.exon.bed; done

#exon 30bp 
for gtf in hg38.ensGene.gtf hg38.knownGene.gtf hg38.ncbiRefSeq.gtf hg38.refGene.gtf; do
  awk 'BEGIN{OFS="\t"} $3=="exon" {
    start = $4 - 1 - 30;
    end = $5 + 30;
    if (start < 0) start = 0;
    print $1, start, end
  }' ${WORKDIR}/cne/representativetrans/${gtf} > ${WORKDIR}/cne/representativetrans/${gtf%.gtf*}.exonflanking30bp.bed
done

cat hg38*flanking30bp.bed > hg38.allexon.exonflanking30bp.bed

for i in $(ls ${WORKDIR}/cne/mergece); do bedtools subtract -a ${WORKDIR}/cne/mergece/$i -b ${WORKDIR}/cne/representativetrans/hg38.allexon.exonflanking30bp.bed -A > ${WORKDIR}/cne/cne/${i%maf*}cne.exonflanking30bp.bed; done

