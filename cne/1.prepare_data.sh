#!/bin/bash

WORKDIR=/home//liunyw/project/howler_monkey
cd ${WORKDIR}/cne

#hal convert to maf
screen -R cactus-hal2maf
bash cactus-hal2maf.sh &> cactus-hal2maf.log
#move to the hal2maf folder
mkdir hal2maf && mv howlermonkey.maf cactus-hal2maf.* tmpdir/ workdir/ hal2maf/
sbatch ${WORKDIR}/cne/hal2maf/mafDuplicateFilter.sh

#keep those blocks with at least 80%
echo -e '#!/bin/bash\n#SBATCH -J 'mafFilter'\n#SBATCH -N 1\n#SBATCH -p FAT\n#SBATCH --ntasks-per-node=1\n#SBATCH --cpus-per-task=1\n#SBATCH --output='${WORKDIR}/cne/hal2maf/mafFilter.log'\n#SBATCH --error='${WORKDIR}/cne/hal2maf/mafFilter.err'\n\n' > ${WORKDIR}/cne/hal2maf/mafFilter.sh; echo -e "cd ${WORKDIR}/cne/hal2maf\n\n/home/liunyw/miniforge3/envs/phygenomics/bin/mafFilter  howlermonkey.maf -minRow=36 > howlermonkey.36way.maf " >> ${WORKDIR}/cne/hal2maf/mafFilter.sh

grep 'homSap' howlermonkey.36way.maf | awk '{print $2}' | sort | uniq > Homo.Chr.txt
if [ ! -d ../mafsplit ]; then mkdir ../mafsplit; else rm ../mafsplit/*; fi
cd ../mafsplit

/home/liunyw/miniforge3/envs/phygenomics/bin/mafSplit -byTarget ../maf/Homo.Chr.txt -useFullSequenceName Homo ../maf/howlermonkey.36way.maf
for i in Homo*; do mv $i ${i#*mo}; done
mkdir no_chr_maf
mv *alt.maf *dom.maf chrUn_* no_chr_maf/