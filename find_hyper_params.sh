

iterations=20
xf="../data/gtex/mfactorization/slope.txt"
wf="../data/gtex/mfactorization/se.txt"
od="../data/gtex/mfactorization/"

for K in 30 40
do
        for alpha in 1000 12000 1300 1500 1700
        do
                for lambda in 1000 1200 1500 1700
                do
                        sbatch sn_spMF/1_run_parameter_scope_search.sh ${K} ${alpha} ${lambda} ${iterations} ${xf} ${wf} ${od}
                done
        done
done