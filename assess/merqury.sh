#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
cd ${WORKDIR}/assess
mkdir ${WORKDIR}/assess/merqury && cd ${WORKDIR}/assess/merqury
export MERQURY=${WORKDIR}/software/merqury
export PATH=${WORKDIR}/software/meryl-1.4.1/bin:$PATH


#evaluate the kmer of aloMac
###########################################################################################################################
${WORKDIR}/software/seqkit stat aloMac.fa &> ./aloMac.length.log
${WORKDIR}/software/merqury/best_k.sh 3176659810 &> ./aloMac.kmer.log
#the result is 20.7646
###########################################################################################################################
#HiFi
#reads are in the HiFi/fasta directory
echo -e '#!/bin/bash\n#SBATCH -J build_db_hifi\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=24\n#SBATCH --output='${WORKDIR}/assess/merqury/shell_build_db/build_db_hifi.log'\n#SBATCH --error='${WORKDIR}/assess/merqury/shell_build_db/build_db_hifi.err'\n\n' > ${WORKDIR}/assess/merqury/shell_build_db/build_db_hifi.sh; echo -e "export PATH=${WORKDIR}/software/meryl-1.4.1/bin:\$PATH \nexport PATH=${WORKDIR}/software/merqury:\$PATH \ncd ${WORKDIR}/assess/merqury/meryl_db \nmeryl k=21 count ${WORKDIR}/assess/merqury/HiFi/fasta/*.fasta output hifi.meryl" >> ${WORKDIR}/assess/merqury/shell_build_db/build_db_hifi.sh
sbatch ${WORKDIR}/assess/merqury/shell_build_db/build_db_hifi.sh
###########################################################################################################################

###########################################################################################################################
#run merqury
#merqury.sh  read.meryl  <fasta_file>  <prefix>
##use hifi.meryl to evaluate
echo -e '#!/bin/bash\n#SBATCH -J assess_hifi\n#SBATCH -N 1\n#SBATCH --ntasks-per-node=1\n#SBATCH --output='${WORKDIR}/assess/merqury/shell_assess/assess_hifi.log'\n#SBATCH --error='${WORKDIR}/assess/merqury/shell_assess/assess_hifi.err'\n\n' > ${WORKDIR}/assess/merqury/shell_assess/assess_hifi.sh; echo -e "export PATH=${WORKDIR}/software/meryl-1.4.1/bin:\$PATH \nexport PATH=${WORKDIR}/software/merqury:\$PATH\nexport MERQURY=${WORKDIR}/software/merqury\ncd ${WORKDIR}/assess/merqury/assess_hifi \n\$MERQURY/merqury.sh ${WORKDIR}/assess/merqury/meryl_db/hifi.meryl ${WORKDIR}/assess/merqury/aloMac.fa assess_hifi" >> ${WORKDIR}/assess/merqury/shell_assess/assess_hifi.sh
sbatch ${WORKDIR}/assess/merqury/shell_assess/assess_hifi.sh
###########################################################################################################################
