`%>%` <- magrittr::`%>%`
effects_file = "../data2/gtex/lead_effects_na.tsv"
output_dir = "../data2/gtex/mfactorization/"

effects = readr::read_tsv(effects_file)
dir.create(output_dir, recursive = T)

dplyr::select(effects, variant, molecular_trait_id, ends_with('.beta')) %>%
  dplyr::rename_all(function(x){sub(".beta", "", x)}) %>%
  dplyr::rename(SNP = variant, Gene = molecular_trait_id) %>%
  readr::write_tsv(file.path(output_dir, "slope.txt"))

dplyr::select(effects, variant, molecular_trait_id, ends_with('.se')) %>%
  dplyr::rename_all(function(x){sub(".se", "", x)}) %>%
  dplyr::rename(SNP = variant, Gene = molecular_trait_id) %>%
  readr::write_tsv(file.path(output_dir, "se.txt"))
