#!/bin/bash

cd /home/liunyw/project/howler_monkey
#mkdir workdir outdir tmpdir logdir

# singularity exec cactus_v2.9.8.sif cactus ./js ./examples/evolverMammals.txt evolverMammals.hal --batchSystem slurm --batchLogsDir batch-logs --coordinationDir /data/tmp --consCores 28 --maxMemory 210GB --doubleMem true --slurmTime 240:00:00 --partition CU


bash cactus.sh &> cactus.log &
