#!/bin/bash

cd /home/liunyw/project/howler_monkey/cne

source /home/liunyw/project/howler_monkey/software/cactus-bin-v2.9.8/venv-cactus-v2.9.8/bin/activate
export TMPDIR=/home/liunyw/project/howler_monkey/cne/tmpdir
export TEMPDIR=/home/liunyw/project/howler_monkey/cne/tmpdir

#mkdir workdir tmpdir
# TOIL_SLURM_ARGS="partition=FAT"

cactus-hal2maf ./jobStore ../cactus/howlermonkey.hal howlermonkey.maf --workDir workdir --chunkSize 1000000 --doubleMem true --batchSystem slurm --batchCount 50  --maxJobs 50 --batchCores 4 --batchMemory 32Gi --maxMemory 1200Gi --slurmPartition 'FAT' --filterGapCausingDupes --noAncestors --dupeMode single --refGenome homSap


# bash cactus-hal2maf.sh &> cactus-hal2maf.log &

