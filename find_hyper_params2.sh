iterations=50
xf="../data/gtex/mfactorization/slope.txt"
wf="../data/gtex/mfactorization/se.txt"
od="../data/gtex/mfactorization/"

for K in 40 45 50 55
do
  	for alpha in 900 950 1000 1050 1100 1150 1200
        do
          	for lambda in 1000 1050 1100 1150 1450 1500 1550
                do
                  	sbatch sn_spMF/2_choose_hyperparameters.sh ${K} ${alpha} ${lambda} ${iterations} ${xf} ${wf} ${od}
                done
        done
done


