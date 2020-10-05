iterations=50
xf="../data/gtex/mfactorization/slope.txt"
wf="../data/gtex/mfactorization/se.txt"
od="../data/gtex/mfactorization/"

for K in 20 25 30
do
  	for alpha in 800 900 1000 1100 1200
        do
          	for lambda in 800 900 1000 1100 1200
                do
                  	sbatch sn_spMF/2_choose_hyperparameters.sh ${K} ${alpha} ${lambda} ${iterations} ${xf} ${wf} ${od}
                done
        done
done


