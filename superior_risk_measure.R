library(synthpop)
library(dplyr)

load("satgpa.rda")
load("results/sm_sat_ipso_regsdc_hs_fy_no_corrections.rda")
df_orig <- satgpa
df_synth <- sm_ipso_regsdc_conf_hs_fy

generate_uniques_for_sat <-function(df_orig, df_synth, exclude = NULL){
  syn_synth <- list(m = 1, syn = df_synth)
  replicated.uniques(object = syn_synth, data = df_orig , exclude = exclude)
}

generate_uniques_pp_for_sat <-function(df_orig, df_synth,identifiers = 1:4 ,  p = 0.05){
  syn_synth <- list(m = 1, syn = df_synth[,identifiers])
  syn_orig <- list(m = 1, syn = df_orig[,identifiers])
  
  repl_synth <- replicated.uniques(object = syn_synth, data = df_orig[,identifiers])
  repl_orig <- replicated.uniques(object = syn_orig, data = df_synth[,identifiers])$replications
  

  df <- inner_join(df_synth[repl_synth$replications,], df_orig[repl_orig,], 
                   by=names(df_orig)[identifiers], 
                   suffix = c("_synth", "_orig"))
  sum_repl_synth  <- sum(repl_synth$replications)
  
  count_disclosure <- df %>%
    mutate(hs_gpa_discl = abs(hs_gpa_synth-hs_gpa_orig)/abs(hs_gpa_orig)< p, 
           fy_gpa_discl = abs(fy_gpa_synth-fy_gpa_orig)/abs(fy_gpa_orig) < p,
           at_least_1_discl = hs_gpa_discl | fy_gpa_discl,
           at_least_2_discl = hs_gpa_discl & fy_gpa_discl) %>%
    summarize(sum_hs_gpa_discl = sum(hs_gpa_discl),
              sum_fy_gpa_discl = sum(fy_gpa_discl),
              sum_at_least_1_discl = sum(at_least_1_discl),
              sum_at_least_2_discl = sum(at_least_2_discl)) %>%
    mutate(#hs_gpa_discl = paste0(sum_hs_gpa_discl, " (",round(sum_hs_gpa_discl/sum_repl_synth,4)*100, "%)"),
           #unique_orig = repl_synth$no.uniques,
           'Replication.Uniques' = paste0(repl_synth$no.replications, " (",round(repl_synth$no.replications/nrow(df_orig),4)*100, "%)"),
           'Disclosure.in.>=1.CVar' = paste0(sum_at_least_1_discl, " (",round(sum_at_least_1_discl/nrow(df_orig),4)*100, "%)"),
           'Disclosure.in.2.CVars' = paste0(sum_at_least_2_discl, " (",round(sum_at_least_2_discl/nrow(df_orig),4)*100, "%)"),
           )%>%
    select('Replication.Uniques' , 'Disclosure.in.>=1.CVar', 'Disclosure.in.2.CVars')
  
  count_disclosure
}

result <- generate_uniques_pp_for_sat(df_orig, df_synth)
result 

df_synth$hs_gpa <- round(df_synth$hs_gpa,2)
df_synth$fy_gpa <- round(df_synth$fy_gpa,2)

#generate_uniques_for_sat(as.data.frame(df_orig), df_synth, exclude = c("hs_gpa", "fy_gpa") )
