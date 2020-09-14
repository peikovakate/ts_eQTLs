rm slurm-*

iterations=20
xf="../data/gtex/mfactorization/slope.txt"
wf="../data/gtex/mfactorization/se.txt"
od="../data/gtex/mfactorization/"

for K in 20 30 40
do
        for alpha in 2000 3000 4000
        do
                for lambda in 2000 3000 4000
                do
                        sbatch sn_spMF/1_run_parameter_scope_search.sh ${K} ${alpha} ${lambda} ${iterations} ${xf} ${wf} ${od}
                done
        done
done