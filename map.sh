#!/bin/bash
#SBATCH --time 30:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p main
#SBATCH 

module load R/3.5.1

M="$1"

xf="../data/gtex/mfactorization/slope.txt"
wf="../data/gtex/mfactorization/se.txt"
od="../data/gtex/mfactorization2/"
mod="../data/gtex/mfactorization2/mapping/"

Rscript mapping/lm.R -f $M -x ${xf} -w ${wf} -d ${od} -m ${mod}