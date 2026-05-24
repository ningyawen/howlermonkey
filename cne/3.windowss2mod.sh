#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/cne

mkdir ${WORKDIR}/cne/split_MSA && mkdir ${WORKDIR}/cne/shell/split_MSA

for i in chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX; do mkdir ${WORKDIR}/cne/split_MSA/${i}; echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/shell/split_MSA/'${i}'.split_MSA.log\n#SBATCH --error='${WORKDIR}'/cne/shell/split_MSA/'${i}'.split_MSA.err\n\ncd '${WORKDIR}'/cne\n\n' > ${WORKDIR}/cne/shell/split_MSA/${i}.split_MSA.sh; echo "${WORKDIR}/software/phast/bin/msa_split  ${WORKDIR}/cne/mafsplit/${i}.maf --in-format MAF --windows 1000000,0 --out-root ${WORKDIR}/cne/split_MSA/${i}/${i} --out-format SS --min-informative 1000 --between-blocks 5000" >> ${WORKDIR}/cne/shell/split_MSA/${i}.split_MSA.sh; done;



#for more information please see split_MSA directory
#Run phastCons with an alignment and mod file to estimate free parameters of the phylogenetic models.
cd ${WORKDIR}/cne/split_MSA
for i in *; do cd $i; mkdir shell cal uncal; cd ../; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr1 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr1/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr1/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr1\n\n' > ${WORKDIR}/cne/split_MSA/chr1/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr1/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr2 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr2/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr2/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr2\n\n' > ${WORKDIR}/cne/split_MSA/chr2/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr2/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr3 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr3/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr3/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr3\n\n' > ${WORKDIR}/cne/split_MSA/chr3/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr3/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr4 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr4/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr4/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr4\n\n' > ${WORKDIR}/cne/split_MSA/chr4/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr4/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr5 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr5/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr5/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr5\n\n' > ${WORKDIR}/cne/split_MSA/chr5/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr5/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr6 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr6/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr6/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr6\n\n' > ${WORKDIR}/cne/split_MSA/chr6/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr6/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr7 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr7/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr7/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr7\n\n' > ${WORKDIR}/cne/split_MSA/chr7/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr7/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr8 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr8/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr8/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr8\n\n' > ${WORKDIR}/cne/split_MSA/chr8/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr8/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr9 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr9/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr9/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr9\n\n' > ${WORKDIR}/cne/split_MSA/chr9/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr9/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr10 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr10/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr10/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr10\n\n' > ${WORKDIR}/cne/split_MSA/chr10/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr10/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr11 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr11/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr11/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr11\n\n' > ${WORKDIR}/cne/split_MSA/chr11/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr11/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr12 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr12/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr12/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr12\n\n' > ${WORKDIR}/cne/split_MSA/chr12/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr12/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr13 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr13/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr13/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr13\n\n' > ${WORKDIR}/cne/split_MSA/chr13/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr13/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr14 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr14/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr14/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr14\n\n' > ${WORKDIR}/cne/split_MSA/chr14/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr14/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr15 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr15/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr15/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr15\n\n' > ${WORKDIR}/cne/split_MSA/chr15/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr15/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr16 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr16/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr16/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr16\n\n' > ${WORKDIR}/cne/split_MSA/chr16/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr16/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr17 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr17/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr17/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr17\n\n' > ${WORKDIR}/cne/split_MSA/chr17/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr17/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr18 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr18/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr18/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr18\n\n' > ${WORKDIR}/cne/split_MSA/chr18/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr18/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr19 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr19/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr19/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr19\n\n' > ${WORKDIR}/cne/split_MSA/chr19/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr19/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr20 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr20/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr20/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr20\n\n' > ${WORKDIR}/cne/split_MSA/chr20/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr20/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr21 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr21/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr21/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr21\n\n' > ${WORKDIR}/cne/split_MSA/chr21/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr21/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chr22 | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chr22/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chr22/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chr22\n\n' > ${WORKDIR}/cne/split_MSA/chr22/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chr22/shell/${i%.ss*}.sh; done


for i in $(ls ${WORKDIR}/cne/split_MSA/chrX | grep ss); do echo -e '#!/bin/bash\n#SBATCH -J split_MSA'${i%.ss*}'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}'/cne/split_MSA/chrX/shell/'${i%.ss*}'.estmod.log\n#SBATCH --error='${WORKDIR}'/cne/split_MSA/chrX/shell/'${i%.ss*}'.estmod.err\n\ncd '${WORKDIR}'/cne/split_MSA/chrX\n\n' > ${WORKDIR}/cne/split_MSA/chrX/shell/${i%.ss*}.sh ; echo "${WORKDIR}/software/phast/bin/phastCons --estimate-rho $i --no-post-probs $i ../../4d.ave.noncons.mod" >> ${WORKDIR}/cne/split_MSA/chrX/shell/${i%.ss*}.sh; done





for i in *noncons.mod; do mv ${i%.noncons.mod}* cal/; done

cd ${WORKDIR}/cne/
ls ${WORKDIR}/cne/split_MSA/chr*/cal/*.cons.mod > ${WORKDIR}/cne/all.cons.mod.list
${WORKDIR}/software/phast/bin/phyloBoot --read-mods '*all.cons.mod.list' --output-average primate.ave.cons.mod
ls ${WORKDIR}/cne/split_MSA/chr*/cal/*.noncons.mod > ${WORKDIR}/cne/all.noncons.mod.list
${WORKDIR}/software/phast/bin/phyloBoot --read-mods '*all.noncons.mod.list' --output-average primate.ave.noncons.mod


