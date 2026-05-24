#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cne

${WORKDIR}/software/phast/bin/tree_doctor --name-ancestors 4d.ave.noncons.mod  > 4d.ancestor.ave.noncons.mod
#for more information please check LinARs

#for more information please check LinARs
##################################################################################
mkdir ${WORKDIR}/cne/LinARs && cd ${WORKDIR}/cne/LinARs

for spe in aloMac; do mkdir ${WORKDIR}/cne/LinARs/$spe && mkdir ${WORKDIR}/cne/LinARs/$spe/shell ${WORKDIR}/cne/LinARs/$spe/wig; for chrom in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX chrY; do echo -e '#!/bin/bash\n#SBATCH -J LinARs_'${chrom}'\n#SBATCH -N 1\n#SBATCH -p CU\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/LinARs/'${spe}'/shell/LinARs.'${spe}.${chrom}'.log\n#SBATCH --error='${WORKDIR}'/cne/LinARs/'${spe}'/shell/LinARs.'${spe}.${chrom}'.err\n\n' > ${WORKDIR}/cne/LinARs/${spe}/shell/LinARs.${spe}.${chrom}.sh; echo -e  "cd ${WORKDIR}/cne/LinARs/${spe}\n${WORKDIR}/software/phast/bin/phyloP --mode CONACC --method LRT --features ${WORKDIR}/cne/cne/${chrom}.cne.exonflanking10bp.bed --branch ${spe} ${WORKDIR}/cne/4d.ave.noncons.mod ${WORKDIR}/cne/mafsplit/${chrom}.maf > ${WORKDIR}/cne/LinARs/${spe}/wig/${chrom}.scores.wig" >> ${WORKDIR}/cne/LinARs/$spe/shell/LinARs.${spe}.${chrom}.sh; done; done
##################################################################################

##################################################################################
cd ${WORKDIR}/cne/LinARs


for i in aloMac;
        do
                cd $i;
                mkdir fdr
                echo -e "rm(list = ls())\nsetwd('${WORKDIR}/cne/LinARs/${i}/wig')\nx<-c(1:22,\"X\")\nfor ( i in x) {" > fdr.R
                echo -en "\t" >> fdr.R
                echo -n "phylop <- read.table(paste(\"acc.chr\",i,\".scores.wig\",sep=\"\"), sep='" >> fdr.R
                echo -n "\t" >> fdr.R
                echo -en "')\n\tphylop\$BH <- p.adjust(abs(phylop\$V9),method = 'fdr')\n\tphylop_filter <- phylop[phylop\$BH<0.05,]\n\twrite.table(phylop_filter, file = paste(\"../fdr/acc.chr\",i,\".filter.txt\", sep = \"\"), sep = \"" >> fdr.R
                echo -n "\t" >> fdr.R
                echo -e "\", row.names=F, col.names=F, quote = FALSE)\n}" >> fdr.R
                echo -e "cd ${WORKDIR}/cne/LinARs/${i}/wig\nfor i in *; do grep '-' \$i > acc.\${i} ; done\ncd ..\n/lustre/software/mambaforge/bin/Rscript fdr.R &> fdr.log" > fdr.sh
                cd ../
        done

cat ${WORKDIR}/cne/LinARs/aloMac/fdr/acc* | awk '{print $1"\t"$2"\t"$3}' > ${WORKDIR}/cne/LinARs/aloMac/acc.noncoding.bed
##################################################################################


