#!/bin/sh

#SBATCH -p i8cpu
#SBATCH -N 1
#SBATCH -n 11

srun ./cps/cps ./tasks.sh

