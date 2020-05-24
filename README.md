
# Learn latent factors using sn-spMF
We develop a constrained matrixfactorization model to learn patterns of tissue-sharing and tissue-specificity of eQTLs across 49 human tissuesfrom the Genotype-Tissue Expression (GTEx) project. The learned factors include patterns reflecting tissueswith known biological similarity or shared cell types, in addition to a dense factor representing a ubiquitousgenetic effect across all tissues

### Prerequisites
All codes are run in ```R/3.5.1```. 

R packages needed are:
```
install.packages('penalized')
```

### Run the sn_spMF model
To get the result for one run, please run the following command. The output is saved in ```output/sn_spMF_K17_a1100_l190/``` by default, or can be specified by ```-O```. Details can be found in ```run_MF.R```.
```
Rscript run_MF.R -k 17 -a 100 -l 90 -t 100
```

### Input files

```data/test_data_X.txt```: each row contains the effect size of an eQTL across tissues; the first two columns are gene names and SNP names for the eQTLs, and following columns are the features to learn patterns about, (tissues in the demo, can be time points in time-series data, or cells in single cell data). Missing data are presented as NA. Columns are seperated by '\t'. 

```
Gene	SNP	Adipose_Subcutaneous	Adipose_Visceral_Omentum	Adrenal_Gland	Artery_Aorta
Gene1	SNP1	-0.0350153	-0.0796675	0.0458593	-0.0663155
Gene2	SNP2	0.25088	0.133673	0.13425	0.211878
Gene3	SNP3	0.0262571	-0.065221	0.199401	-0.0711795
Gene4	SNP4	-0.272452	0.240933	0.214758	0.281942
Gene5	SNP5	NA	NA	NA	NA
Gene6	SNP6	0.133723	0.0933188	0.103415	-0.15649
```


```data/test_data_W.txt```: each row contains the weight (reciprical of standard error of the effect size) of an eQTL across tissues. Columns should be aligned with the columns in ```data/test_data_X.txt```.

```
Gene	SNP	Adipose_Subcutaneous	Adipose_Visceral_Omentum	Adrenal_Gland	Artery_Aorta
Gene1 SNP1	0.0748711	0.0926145	0.150558	0.0754927
Gene1	SNP2	0.0425708	0.036122	0.0405176	0.0548538
Gene1	SNP3	0.0735933	0.0765909	0.125968	0.0891406
Gene1	SNP4	0.164811	0.152243	0.235161	0.177724
Gene1	SNP5	NA	NA	NA	NA
Gene1	SNP6	0.114314	0.112615	0.182777	0.147263
```


### Model selection


Model selection is one of the most challenging parts in deciding matrix factorization models. People have used several methods to approach this problem (REF: xxxxxx). In sn-spMF, we recommend searching for the hyper-parameters (K, alpha1, lambda1) in two steps:

#### 1. Narrow down the range of hyper-parameters 

When first running the algorithm, it may be completely unclear how to choose the appropriate range to search for hyper-parameters. We recommend first searching for the appropriate range, by 1). running the scripts in well-separated numerical ranges, like choose from [1, 10, 100, 500, 1000]; and 2).  setting the number of iterations to a moderate number since there is no need to reach accurate results. 

If the number of factors become much smaller than the initial number of factors to start with (ie. a lot of factors become empty), it means that the penalty parameters are too stringent. Usually we have an estimated level of sparsity, for example, around 80%, for the loading matrix and factor matrix. If the reported sparsity is far below the expected sparsity (ie. 20%), it means that the penalty parameters are too small. 

Based on the initial round of searching, we should have the numerical range to search for. 

An example to perform this step is as below:
```
iterations=20
for K in 10 15 20
do
        for alpha1 in 1 10 100 500
        do
                for lambda1 in 1 10 100 500
                do
                        sbatch 1_run_parameter_scope_search.sh ${K} ${alpha1} ${lambda1} ${iterations}
                done
        done
done
```

To collect the results from multiple runs, user can run the following command. The output will be saved in ```output/choose_para_preliminary.txt```
```
Rscript sn_spMF/tune_parameters_preliminary.R -f choose_para_preliminary.txt
```


#### 2. Refine the hyper-parameter selection

With the learned range of hyper-parameters, we continue to look in finer grids. For example, run the scripts for alpha1 in [10, 20, 30, … 100]. An example to perform this step is as below:
```
iterations=100
for K in {10..20}
do
        for alpha1 in {1..10}
        do
                for lambda1 in {1..10}
                do
                        a=$(( 10*alpha1 ))
                        l=$(( 10*lambda1 ))
                        sbatch 2_choose_hyperparameters.sh ${K} ${a} ${l} ${iterations}
                done
        done
done
```

To collect the results from multiple runs, user can run the following command. The output will be saved in ```output/choose_para.txt```.
```
Rscript sn_spMF/tune_parameters.R -f choose_para.txt
```

We’d like to include some suggestions from practical experience when setting the arguments in the model:

```Number of iterations```: recommend using 100 or less. If the model does not converge within 100 iterations, one reason is that the penalty parameters are too small, which leads to slow optimization steps. Larger penalty parameters are suggested in the case where the model does not converge within 100 iterations. 

```Change in the factor matrix to call convergence (converged_F_change)```: this is the Frobenius norm of the difference matrix comparing the factor matrix before and after updating, scaled by the number of factors (||F_new - F_old||^2_F / (number of factors)). The scaling is to avoid bias of higher Frobenius norm coming from more factors. 

```Change in the objective to call convergence (converged_obj_change)```: this is usually a more stringent threshold than converged_F_change. 

```Number of runs to compute cophenetic coefficient```: we find that around 20 runs suffice to provide a reliable estimate of the cophenetic coefficient. 


Because the three parameters can collaboratively affect the decomposition results, we perform model selection in two sub-steps, and we provide an example in ```choose_paras_sn_spMF.ipynb```. 


##### 2.1 Choose the number of factors K. 

We notice that the cophenetic coefficient can be affected by sparsity in the decomposed matrices given different settings of alpha1 and lambda1 with fixed K. To gain more stable matrix decomposition results, we compare the average cophenetic coefficient with multiple settings for alpha1 and lambda1. The optimal K is chosen to have the highest average cophenetic coefficient. 

##### 2.2 Choose the penalty parameters alpha1 and lambda 1. 

Because factors are expected to be independent of each other, to alleviate multicollinearity, we then search for the alpha1 and lambda1 that result in factors with smallest correlation. 

### Examine the optimal solution.

By examining the tuning results in ```choose_paras_sn_spMF.ipynb```, we find that ```sn_spMF_FactorMatrix_K17_a1100_l190_Run7``` is the optimal solution with the optimal hyper-parameter setting. User can find the learned factor matrix in ``` output/sn_spMF_K17_a1100_l190/sn_spMF_K17_a1100_l190_Run7.*```, including the plotted factors. 



### (Optional) Multiple intializations.

Because random initializations can result in different decomposition solutions, we recommend running the decomposition multiple times (ie. 30 times), and obtain the optimal solution using the decomposition with minimum objective value. User can directly extract the solution with optimal objective from the model selection step, or run the following and then extract the solution with optimal objective (saved in ```output/sn_spMF_K17_a1100_l190/\*RData``` by default, can be changed using the ```-O``` argument).

```
Rscript run_MF.R -k 17 -a 100 -l 90 -t 100 -c 1
```


### Map eQTLs to factors.
After user have chosen the optimal hyper-parameters (```${FM_fn}```), please run the following command to map the eQTLs to the learned factors. The script automatically chose the solution with optimal objective if multiple solutions exist. The mapped eQTLs are in ```output/mapping/``` by default or can be specified by ```-m ${mappingDir}```. Details can be found in ```mapping/lm.R```.

```
K=17
alpha1=100
lambda1=90
FM_fn=sn_spMF_K${K}_a1${alpha1}_l1${lambda1}
Rscript mapping/lm.R -f ${FM_fn}
```

