#!/bin/bash
#SBATCH --time 10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p shared

K="$1"
alpha1="$2"
lambda1="$3"
iterations="$4"

xf="$5"
wf="$6"
od="$7"

module load R/3.5.1
Rscript sn_spMF/run_MF.R -k $K -a ${alpha1} -l ${lambda1} -t ${iterations} -c 1 -x ${xf} -w ${wf} -O ${od}
