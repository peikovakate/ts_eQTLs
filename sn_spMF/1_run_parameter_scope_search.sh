#!/bin/bash
#SBATCH --time 12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -p main
#SBATCH -t 12:00:00
#SBATCH 


### Search the appropriate range for alpha1 and lambda1
### 1). search in well-seperated ranges
### 2). set iterations to a moderate number, there is no need to reach the accurate results

K="$1"
alpha1="$2"
lambda1="$3"
iterations="$4"

xf="$5"
wf="$6"
od="$7"

module load R/3.5.1
Rscript sn_spMF/run_MF.R -k $K -a ${alpha1} -l ${lambda1} -t ${iterations} -x ${xf} -w ${wf} -O ${od}


### Examine the printed output to narrow down the proper range of alpha1 and lambda1 for further search
