#!/bin/bash
#SBATCH -J mafFilter
#SBATCH -N 1
#SBATCH -p FAT
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=/home/liunyw/project/howler_monkey/cne/hal2maf/mafFilter_howlermonkeymaf.log
#SBATCH --error=/home/liunyw/project/howler_monkey/cne/hal2maf/mafFilter_howlermonkeymaf.err


cd /home/liunyw/project/howler_monkey/cne/hal2maf

//lustre/home/luyizheng/miniforge3/envs/phygenomics/bin/mafFilter  howlermonkey.maf -minRow=36 > howlermonkey.36way.maf 
