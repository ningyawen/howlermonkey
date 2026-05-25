#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/population
#create the shell directory for all the shell scripts
mkdir shell


#download the SraRunInfo.csv from the website
#https://www.ncbi.nlm.nih.gov/sra?linkname=bioproject_sra_all&from_uid=979529
#then rename it to Primate_233_SraRunInfo.csv
mkdir sra && cd sra
#download the second-generation data of howlermonkey
grep Alou ../Primate_233_SraRunInfo.csv | awk -v FS="," '{print $1}' > howlermonkey.sra.txt
grep "Ateles geoffroyi" ../Primate_233_SraRunInfo.csv | awk -v FS="," '{print $1}' >> howlermonkey.sra.txt
split -l 10 howlermonkey.sra.txt howlermonkey.sra.tmp
for i in howlermonkey.sra.tmp*; do mv $i ${i}.txt; done
#download these data
for i in howlermonkey.sra.tmp*; do echo "${WORKDIR}/software/sratoolkit.3.1.1-centos_linux64/bin/prefetch --option-file $i &> ${i%.txt*}.log &"; done


#build the index of the genome
cd ${WORKDIR}/population
mkdir index && cd index
ln -s ${WORKDIR}/aloMac.sm.fa howlermonkey.fa
echo -e '#!/bin/bash\n#SBATCH -J 'howler_index'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/population/shell/index.howlermonkey.log'\n#SBATCH --error='${WORKDIR}/population/shell/index.howlermonkey.err'\n\n' > ${WORKDIR}/population/shell/index.howlermonkey.sh; echo -e "cd ${WORKDIR}/population/index\n\n${WORKDIR}/software/bwa/bwa index a bwtsw howlermonkey.fa" >> ${WORKDIR}/population/shell/index.howlermonkey.sh


#sra2fastq
mkdir ${WORKDIR}/population/shell/shell_sra2fastq && mkdir ${WORKDIR}/population/raw_data
cd ${WORKDIR}/population/shell/shell_sra2fastq
for i in $(cat ${WORKDIR}/population/sra/howlermonkey.sra.txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i}_sra2fq'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_sra2fastq/${i}.sra2fasta.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_sra2fastq/${i}.sra2fasta.err'\n\n' > ${WORKDIR}/population/shell/shell_sra2fastq/${i}.sra2fastq.sh; echo "${WORKDIR}/software/sratoolkit.3.1.1-centos_linux64/bin/fastq-dump --gzip --split-3 -O ${WORKDIR}/population/raw_data ${WORKDIR}/population/sra/${i}/${i}.sra" >> ${WORKDIR}/population/shell/shell_sra2fastq/${i}.sra2fastq.sh; done


#trim
mkdir ${WORKDIR}/population/shell/shell_trim && mkdir ${WORKDIR}/population/clean_data
for i in $(cat ${WORKDIR}/population/sra/howlermonkey.sra.txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i}_trim'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_trim/${i}.trim.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_trim/${i}.trim.err'\n\n' > ${WORKDIR}/population/shell/shell_trim/${i}.trim.sh; echo -e "export PATH=${WORKDIR}/software/FastQC:\$PATH\n\n${WORKDIR}/software/TrimGalore-0.6.10/trim_galore -q 25 --phred33 --length 50 -e 0.1 --stringency 3 --paired ${WORKDIR}/population/raw_data/${i}_1.fastq.gz ${WORKDIR}/population/raw_data/${i}_2.fastq.gz --gzip -o ${WORKDIR}/population/clean_data/" >> ${WORKDIR}/population/shell/shell_trim/${i}.trim.sh; done


#mapping && convert bam && sort
mkdir ${WORKDIR}/population/shell/shell_rawmapping && mkdir ${WORKDIR}/population/rawmapping
grep -f ${WORKDIR}/population/sra/howlermonkey.sra.txt ${WORKDIR}/population/Primate_233_SraRunInfo.csv | awk -v FS="," '{print $1"\t"$25}' | while read ERRID ERSID; do echo -e '#!/bin/bash\n#SBATCH -J '${ERRID}_rawmapping'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/shell/shell_rawmapping/${ERRID}.rawmapping.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_rawmapping/${ERRID}.rawmapping.err'\n\n' > ${WORKDIR}/population/shell/shell_rawmapping/${ERRID}.rawmapping.sh; echo "${WORKDIR}/software/bwa/bwa mem ${WORKDIR}/population/index/howlermonkey.fa -R '@RG\\tID:${ERSID}WES\\tLB:WES\\tPL:ILLUMINA\\tSM:${ERSID}' -t 10 ${WORKDIR}/population/clean_data/${ERRID}_1_val_1.fq.gz  ${WORKDIR}/population/clean_data/${ERRID}_2_val_2.fq.gz > ${WORKDIR}/population/rawmapping/${ERRID}.sam "  >> ${WORKDIR}/population/shell/shell_rawmapping/${ERRID}.rawmapping.sh; done


#convert bam && sort
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir ${WORKDIR}/population/shell/shell_samtools
for i in $(cat ${WORKDIR}/population/sra/howlermonkey.sra.txt); do echo -e '#!/bin/bash\n#SBATCH -J '${i}_samtools'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/shell/shell_samtools/${i}.samtools.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_samtools/${i}.samtools.err'\n\n' > ${WORKDIR}/population/shell/shell_samtools/${i}.samtools.sh; echo -e "/lustre/software/mambaforge/bin/samtools view -@10 -b -S ${WORKDIR}/population/rawmapping/${i}.sam -o ${WORKDIR}/population/rawmapping/${i}.bam \n/lustre/software/mambaforge/bin/samtools sort ${WORKDIR}/population/rawmapping/${i}.bam -@ 10 -o ${WORKDIR}/population/rawmapping/${i}.sorted.bam \n/lustre/software/mambaforge/bin/samtools index ${WORKDIR}/population/rawmapping/${i}.sorted.bam ${WORKDIR}/population/rawmapping/${i}.sorted.bam.bai" >>  ${WORKDIR}/population/shell/shell_samtools/${i}.samtools.sh; done



#merge indivual bam
mkdir ${WORKDIR}/population/shell/shell_mergebam ${WORKDIR}/population/individualbam
cd ${WORKDIR}/population
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -e '#!/bin/bash\n#SBATCH -J '${i}_mergebam'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=4\n#SBATCH --output='${WORKDIR}/population/shell/shell_mergebam/${i}.mergebam.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_mergebam/${i}.mergebam.err'\n\n' > ${WORKDIR}/population/shell/shell_mergebam/${i}.mergebam.sh; echo -e 'cd '${WORKDIR}'/population/rawmapping\n' >> ${WORKDIR}/population/shell/shell_mergebam/${i}.mergebam.sh; echo "/lustre/software/mambaforge/bin/samtools merge -@ 4 -h $(grep ${i} ${WORKDIR}/population/Primate_233_SraRunInfo.csv | head -n 1 | awk -v FS="," '{print $1".sorted.bam"}') ${i}.bam $(grep ${i} ${WORKDIR}/population/Primate_233_SraRunInfo.csv | awk -v FS="," '{print $1".sorted.bam"}' | xargs)" >> ${WORKDIR}/population/shell/shell_mergebam/${i}.mergebam.sh; done
mv ${WORKDIR}/population/rawmapping/ERS* ${WORKDIR}/population/individualbam/


#sort
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -e '#!/bin/bash\n#SBATCH -J '${i}_samtools'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/shell/shell_samtools/${i}.samtools.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_samtools/${i}.samtools.err'\n\n' > ${WORKDIR}/population/shell/shell_samtools/${i}.samtools.sh; echo -e "/lustre/software/mambaforge/bin/samtools sort -@ 10 -o ${WORKDIR}/population/individualbam/${i}.sorted.bam ${WORKDIR}/population/individualbam/${i}.bam"  >>  ${WORKDIR}/population/shell/shell_samtools/${i}.samtools.sh; done



######################################################################################################
##markduplicate
mkdir ${WORKDIR}/population/shell/shell_markduplicate
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -e '#!/bin/bash\n#SBATCH -J '${i}_markduplicate'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/shell/shell_markduplicate/${i}.markduplicate.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_markduplicate/${i}.markduplicate.err'\n\n' > ${WORKDIR}/population/shell/shell_markduplicate/${i}.markduplicate.sh; echo -e "cd ${WORKDIR}/population/individualbam\njava -jar ${WORKDIR}/software/picard.jar MarkDuplicates I=${i}.sorted.bam O=${i}.sorted.markdup.bam M=${i}.sorted.markdup.txt REMOVE_DUPLICATES=true" >> ${WORKDIR}/population/shell/shell_markduplicate/${i}.markduplicate.sh; done
######################################################################################################



######################################################################################################
#index bam
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir ${WORKDIR}/population/shell/shell_bamindex
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -e '#!/bin/bash\n#SBATCH -J '${i}_markduplicateindex'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=10\n#SBATCH --output='${WORKDIR}/population/shell/shell_bamindex/${i}.bamindex.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_bamindex/${i}.bamindex.err'\n\n' > ${WORKDIR}/population/shell/shell_bamindex/${i}.bamindex.sh; echo -e "cd ${WORKDIR}/population/individualbam\n/lustre/software/mambaforge/bin/samtools index ${WORKDIR}/population/individualbam/${i}.sorted.markdup.bam" >> ${WORKDIR}/population/shell/shell_bamindex/${i}.bamindex.sh; done
######################################################################################################


bcftools mpileup -q 20 -Q 20 -C 50 -a "DP,AD" -f ../aloMac.sm.fa -Ou ERS12091836.sorted.markdup.bam | bcftools call -m -A -V indels | grep "1/2"


#GATK
######################################################################################################
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
cd ${WORKDIR}/population
ln -s ${WORKDIR}/population/aloMac.sm.fa .
gatk-launch CreateSequenceDictionary -R aloMac.sm.fa
java -jar ${WORKDIR}/software/picard.jar CreateSequenceDictionary R=aloMac.sm.fa O=aloMac.sm.dict
awk '{print $1}' ${WORKDIR}/population/aloMac.sm.fa.fai > ctg.txt

/lustre/software/mambaforge/bin/samtools faidx aloMac.sm.fa
######################################################################################################


######################################################################################################
mkdir ${WORKDIR}/population/shell/shell_gvcf
mkdir ${WORKDIR}/population/gvcf
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do for chrom in $(cat ${WORKDIR}/population/ctg.list); do echo -e '#!/bin/bash\n#SBATCH -J '${i}_HaplotypeCaller'\n#SBATCH -p TMP\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.err'\n\n' > ${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.sh; echo "${WORKDIR}/software/gatk-4.6.2.0/gatk HaplotypeCaller -R ${WORKDIR}/population/aloMac.sm.fa -I ${WORKDIR}/population/mapping/${i}.sorted.markdup.bam -O ${WORKDIR}/population/gvcf/${i}.${chrom}.g.vcf -L ${chrom} -ERC GVCF" >> ${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.sh; done; done

for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do for chrom in $(cat ${WORKDIR}/population/ctg.list); do echo -e '#!/bin/bash\n#SBATCH -J '${i}_${chrom}_HaplotypeCaller'\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.err'\n\n' > ${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.sh; echo "${WORKDIR}/software/gatk-4.6.2.0/gatk HaplotypeCaller -R ${WORKDIR}/population/aloMac.sm.fa -I ${WORKDIR}/population/individualbam/${i}.sorted.markdup.bam -O ${WORKDIR}/population/gvcf/${i}.${chrom}.g.vcf -L ${chrom} -ERC GVCF" >> ${WORKDIR}/population/shell/shell_gvcf/${i}.${chrom}.gvcf.sh; done; done


######################################################################################################
#merge VCF files
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir ${WORKDIR}/population/shell/shell_mergeGVCFs ${WORKDIR}/population/mergeGVCFs
for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -e '#!/bin/bash\n#SBATCH -J 'mergeGVCFs_${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.err'\n\n' > ${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.sh; echo -n "${WORKDIR}/software/gatk-4.6.2.0/gatk MergeVcfs -R ${WORKDIR}/population/aloMac.sm.fa " >> ${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.sh; for chrom in $(cat ${WORKDIR}/population/ctg.list); do echo -n " -I ${WORKDIR}/population/gvcf/${i}.${chrom}.g.vcf " >> ${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.sh; done; echo -e " -O ${WORKDIR}/population/mergeGVCFs/${i}.g.vcf.gz" >> ${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.sh; echo -e "\n" >> ${WORKDIR}/population/shell/shell_mergeGVCFs/${i}.mergeGVCFs.sh; done
######################################################################################################





######################################################################################################
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir ${WORKDIR}/population/shell/shell_combineallGVCFs
mkdir ${WORKDIR}/population/combineallGVCF
echo -e '#!/bin/bash\n#SBATCH -J 'combineallGVCFs'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.err'\n\n' > ${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.sh; echo -n "${WORKDIR}/software/gatk-4.6.2.0/gatk CombineGVCFs -R ${WORKDIR}/population/aloMac.sm.fa " >> ${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.sh; for i in ERS12091834 ERS12091835 ERS12091836 ERS12091837 ERS12091838 ERS12091839 ERS12091840 ERS12091841 ERS12091842 ERS12091843 ERS12091844 ERS12091845 ERS12091846 ERS12091847 ERS12091848 ERS12091849 ERS12091850 ERS12091851 ERS12091852 ERS12091853 ERS12091854 ERS12091855 ERS12091856 ERS12091857 ERS12091858 ERS12091859 ERS12091860 ERS12091861 ERS12091862 ERS12091863 ERS12091864 ERS12091865 ERS12091866 ERS12091867 ERS12091868 ERS12091869 ERS12091884; do echo -n " --variant ${WORKDIR}/population/mergeGVCFs/${i}.g.vcf.gz " >> ${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.sh; done; echo -n " --output ${WORKDIR}/population/combineallGVCF/Howlermonkey.all.g.vcf.gz" >> ${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.sh; echo -e "\n" >> ${WORKDIR}/population/shell/shell_combineallGVCFs/combineallGVCFs.sh


mkdir ${WORKDIR}/population/shell/shell_GenotypeGVCFs
mkdir ${WORKDIR}/population/GenotypeGVCFs
echo -e '#!/bin/bash\n#SBATCH -J 'GenotypeGVCFs'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_GenotypeGVCFs/GenotypeGVCFs.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_GenotypeGVCFs/GenotypeGVCFs.err'\n\n' > ${WORKDIR}/population/shell/shell_GenotypeGVCFs/GenotypeGVCFs.sh; echo -n "${WORKDIR}/software/gatk-4.6.2.0/gatk GenotypeGVCFs -R ${WORKDIR}/population/aloMac.sm.fa -V ${WORKDIR}/population/combineallGVCF/Howlermonkey.all.g.vcf.gz -O ${WORKDIR}/population/GenotypeGVCFs/Howlermonkey.all.raw.vcf.gz" >> ${WORKDIR}/population/shell/shell_GenotypeGVCFs/GenotypeGVCFs.sh; echo -e "\n" >> ${WORKDIR}/population/shell/shell_GenotypeGVCFs/GenotypeGVCFs.sh
######################################################################################################



######################################################################################################
#extract SNP sites
WORKDIR=/lustre/home/luyizheng/liunyw/project/howler_monkey
mkdir ${WORKDIR}/population/shell/shell_SelectVariants && mkdir ${WORKDIR}/population/SelectVariants
echo -e '#!/bin/bash\n#SBATCH -J 'SelectVariants'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_SelectVariants/SelectVariants.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_SelectVariants/SelectVariants.err'\n\n' > ${WORKDIR}/population/shell/shell_SelectVariants/SelectVariants.sh; echo -n "${WORKDIR}/software/gatk-4.6.2.0/gatk SelectVariants -R ${WORKDIR}/population/aloMac.sm.fa -V ${WORKDIR}/population/GenotypeGVCFs/Howlermonkey.all.raw.vcf.gz --select-type-to-include SNP -O ${WORKDIR}/population/SelectVariants/Howlermonkey.snp.raw.vcf.gz" >> ${WORKDIR}/population/shell/shell_SelectVariants/SelectVariants.sh; echo -e "\n" >> ${WORKDIR}/population/shell/shell_SelectVariants/SelectVariants.sh
s
#filter SNP sites
mkdir ${WORKDIR}/population/shell/shell_VariantFiltration && mkdir ${WORKDIR}/population/VariantFiltration
echo -e '#!/bin/bash\n#SBATCH -J 'VariantFiltration'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/population/shell/shell_VariantFiltration/VariantFiltration.log'\n#SBATCH --error='${WORKDIR}/population/shell/shell_VariantFiltration/VariantFiltration.err'\n\n' > ${WORKDIR}/population/shell/shell_VariantFiltration/VariantFiltration.sh; echo -n "${WORKDIR}/software/gatk-4.6.2.0/gatk VariantFiltration -R ${WORKDIR}/population/aloMac.sm.fa -V ${WORKDIR}/population/SelectVariants/Howlermonkey.snp.raw.vcf.gz --filter-expression \"QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 3.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0\" --filter-name \"SNP_FILTER\" -O ${WORKDIR}/population/VariantFiltration/Howlermonkey.snp.filter.vcf.gz"  >> ${WORKDIR}/population/shell/shell_VariantFiltration/VariantFiltration.sh; echo -e "\n" >> ${WORKDIR}/population/shell/shell_VariantFiltration/VariantFiltration.sh
######################################################################################################


