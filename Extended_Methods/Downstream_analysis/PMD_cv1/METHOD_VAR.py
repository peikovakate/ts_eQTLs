from GLOBAL_VAR import *


FMfn = 'PMD_cv1'
LMfn = '%s_Loadings_beta_BH_alpha0.05_corrected' % FMfn

shared_text = 0
[X, Comp_tissues] = get_factor_tissues(FMfn, tissues)

