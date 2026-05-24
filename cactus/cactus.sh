#!/bin/bash

cd /home/liunyw/project/howler_monkey/cactus

source /home/liunyw/project/howler_monkey/software/cactus-bin-v2.9.8/venv-cactus-v2.9.8/bin/activate
export TMPDIR=/home/liunyw/project/howler_monkey/cactus/tmpdir
export TEMPDIR=/home/liunyw/project/howler_monkey/cactus/tmpdir

#mkdir workdir outdir tmpdir logdir coordinationDir


# TOIL_SLURM_ARGS="partition=FAT"


cactus ./jobstore ./howlermonkey.seqFile  ./howlermonkey.hal \
    --batchSystem slurm \
    --consCores 40 \
    --doubleMem true \
    --batchLogsDir logdir \
    --coordinationDir coordinationDir \
    --workDir workdir \
    --maxMemory 1400G \
    --binariesMode local \
    --maxJobs 500 \
    --slurmPartition 'FAT'








