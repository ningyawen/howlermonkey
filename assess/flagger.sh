#!/bin/bash

WORKDIR=/home/liunyw/project/howler_monkey
mkdir ${WORKDIR}/assess/flagger && cd ${WORKDIR}/assess/flagger && mkdir shell

#比对
################################################################################################################
echo -e '#!/bin/bash\n#SBATCH -J 'minimap2_onestep'\n#SBATCH -N 1\n#SBATCH --partition=FAT\n#SBATCH --ntasks-per-node=32\n#SBATCH --output='${WORKDIR}/assess/flagger/shell/minimap2_onestep.log'\n#SBATCH --error='${WORKDIR}/assess/flagger/shell/minimap2_onestep.err'\n\n' > ${WORKDIR}/assess/flagger/shell/minimap2_onestep.sh; echo -e "${WORKDIR}/software/minimap2-2.29_x64-linux/minimap2 -a -x map-hifi --cs -t 32 ${WORKDIR}/aloMac.sm.fa ${WORKDIR}/assess/merqury/HiFi/fasta/*.fasta | samtools view -h -b | samtools sort -@ 16 >  ${WORKDIR}/assess/flagger/aloMac.onestep.bam" >> ${WORKDIR}/assess/flagger/shell/minimap2_onestep.sh
################################################################################################################


# Create a whole-genome BED file
################################################################################################################
#建立基因组索引
FASTA_FILE=${WORKDIR}/aloMac.sm.fa
/lustre/software/mambaforge/bin/samtools faidx ${FASTA_FILE}
cat ${FASTA_FILE}.fai | awk '{print $1"\t0\t"$2}' > ${WORKDIR}/assess/flagger/whole_genome.bed
################################################################################################################


#Convert BAM to COV
################################################################################################################
# Put the path to the whole-genome bed file in a json file
echo "{" > ${WORKDIR}/assess/flagger/annotations_path.json
echo \"whole_genome\" : \"${WORKDIR}/assess/flagger/whole_genome.bed\" >> ${WORKDIR}/assess/flagger/annotations_path.json
echo "}" >> ${WORKDIR}/assess/flagger/annotations_path.json


echo -e '#!/bin/bash\n#SBATCH -J 'bam2cov'\n#SBATCH -N 1\n#SBATCH --partition=FAT\n#SBATCH --ntasks-per-node=24\n#SBATCH --output='${WORKDIR}/assess/flagger/shell/bam2cov.log'\n#SBATCH --error='${WORKDIR}/assess/flagger/shell/bam2cov.err'\n\n' > ${WORKDIR}/assess/flagger/shell/bam2cov.sh; echo -e "cd ${WORKDIR}/assess/flagger \nBAM_FILE=aloMac.align.sorted.bam \nWORKING_DIR=${WORKDIR}/assess/flagger \nsingularity exec --bind \${WORKING_DIR}:\${WORKING_DIR} ${WORKDIR}/software/flagger_v1.2.0.sif bam2cov --bam \${WORKING_DIR}/\${BAM_FILE} --output \${WORKING_DIR}/coverage_file.cov.gz --annotationJson \${WORKING_DIR}/annotations_path.json --threads 16 --baselineAnnotation whole_genome" >> ${WORKDIR}/assess/flagger/shell/bam2cov.sh
################################################################################################################


#Run HMM-Flagger
################################################################################################################
mkdir -p ${WORKDIR}/assess/flagger/hmm_flagger_outputs
echo -e '#!/bin/bash\n#SBATCH -J 'flagger'\n#SBATCH -N 1\n#SBATCH --partition=TMP\n#SBATCH --ntasks-per-node=24\n#SBATCH --output='${WORKDIR}/assess/flagger/shell/flagger.log'\n#SBATCH --error='${WORKDIR}/assess/flagger/shell/flagger.err'\n\n' > ${WORKDIR}/assess/flagger/shell/flagger.sh; echo -e "cd ${WORKDIR}/assess/flagger \nWORKING_DIR=${WORKDIR}/assess/flagger \nsingularity exec --bind \${WORKING_DIR}:\${WORKING_DIR} ${WORKDIR}/software/flagger_v1.1.0.sif hmm_flagger --input \${WORKING_DIR}/coverage_file.cov.gz --outputDir \${WORKING_DIR}/hmm_flagger_outputs --alphaTsv /home/programs/config/alpha_optimum_trunc_exp_gaussian_w_4000_n_50.tsv --labelNames Err,Dup,Hap,Col --threads 24" >> ${WORKDIR}/assess/flagger/shell/flagger.sh
################################################################################################################
