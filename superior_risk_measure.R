library(synthpop)
library(dplyr)

load("satgpa.rda")
load("results/sm_ipso_regsdc_hs_fy_no_corrections.rda")
df_orig <- satgpa
df_synth <- sm_ipso_regsdc_conf_hs_fy

generate_uniques_for_sat <-function(df_orig, df_synth, exclude = NULL){
  syn_synth <- list(m = 1, syn = df_synth)
  replicated.uniques(object = syn_synth, data = df_orig , exclude = exclude)
}

generate_uniques_pp_for_sat <-function(df_orig, df_synth,identifiers = 1:4 ,  p = 0.05){
  syn_synth <- list(m = 1, syn = df_synth[,identifiers])
  syn_orig <- list(m = 1, syn = df_orig[,identifiers])
  
  repl_synth <- replicated.uniques(object = syn_synth, data = df_orig[,identifiers])$replications
  repl_orig <- replicated.uniques(object = syn_orig, data = df_synth[,identifiers])$replications
  

  df <- inner_join(df_synth[repl_synth,], df_orig[repl_orig,], 
                   by=names(df_orig)[identifiers], 
                   suffix = c("_synth", "_orig"))
  
  count_disclosure <- df %>%
    mutate(hs_gpa_diff = abs(hs_gpa_synth-hs_gpa_orig)/abs(hs_gpa_orig), 
           fy_gpa_diff = abs(fy_gpa_synth-fy_gpa_orig)/abs(fy_gpa_orig) ) %>%
    filter(hs_gpa_diff < p | fy_gpa_diff < p)%>%
    count(.)
  result = list(replications_synth = sum(repl_synth),replications_orig = sum(repl_orig),
                count_disclosure = count_disclosure[1,1], per_replications = 100*count_disclosure[1,1]/nrow(df_synth))
}

result <- generate_uniques_pp_for_sat(df_orig, df_synth)
result

df_synth$hs_gpa <- round(df_synth$hs_gpa,2)
df_synth$fy_gpa <- round(df_synth$fy_gpa,2)

generate_uniques_for_sat(as.data.frame(df_orig), df_synth, exclude = c("hs_gpa", "fy_gpa") )