library(synthpop)
library(dplyr)

load("pums.RData")
load("results/rt_acs_fcs_samp100000.rda")
df_orig <- ACS_samp100000#pums
df_synth <- ACS_synth_samp100000
#make PUMA integer and remove non-necessary cols, weights are not considered

df_orig$X <- NULL
df_synth$X <- NULL
df_orig$PERWT <- NULL
df_synth$PERWT <- NULL
df_orig$sim_individual_id <- NULL
df_synth$sim_individual_id <- NULL
df_orig$HHWT <- NULL
df_synth$HHWT <- NULL
df_orig$PUMA <- as.numeric(unlist(lapply(df_orig$PUMA, function(x)gsub("-","",x))))
df_synth$PUMA <- as.numeric(unlist(lapply(df_synth$PUMA, function(x)gsub("-","",x))))

generate_uniques_for_acs <-function(df_orig, df_synth, exclude = c("INCTOT","INCWAGE","INCWELFR", "INCINVST", "INCEARN", "POVERTY", "DEPARTS", "ARRIVES")){
  syn_synth <- list(m = 1, syn = df_synth)
  replicated.uniques(object = syn_synth, data = df_orig , exclude = exclude)
}

generate_uniques_pp_for_acs <-function(df_orig, df_synth,identifiers = 1:which(names(df_orig)=="WORKEDYR"),  p = 0.05){
  syn_synth <- list(m = 1, syn = df_synth[,identifiers])
  syn_orig <- list(m = 1, syn = df_orig[,identifiers])
  
  repl_synth <- replicated.uniques(object = syn_synth, data = df_orig[,identifiers])$replications
  repl_orig <- replicated.uniques(object = syn_orig, data = df_synth[,identifiers])$replications
  
  
  df <- inner_join(df_synth[repl_synth,], df_orig[repl_orig,], 
                   by=names(df_orig)[identifiers], 
                   suffix = c("_synth", "_orig"))
  
  count_disclosure <- df %>%
    mutate(INCTOT_diff = abs(INCTOT_synth-INCTOT_orig)/abs(INCTOT_orig), 
           INCWAGE_diff = abs(INCWAGE_synth-INCWAGE_orig)/abs(INCWAGE_orig),
           INCWELFR_diff = abs(INCWELFR_synth-INCWELFR_orig)/abs(INCWELFR_orig),
           INCINVST_diff = abs(INCINVST_synth-INCINVST_orig)/abs(INCINVST_orig),
           INCEARN_diff = abs(INCEARN_synth-INCEARN_orig)/abs(INCEARN_orig),
           POVERTY_diff = abs(POVERTY_synth-POVERTY_orig)/abs(POVERTY_orig),
           DEPARTS_diff = abs(DEPARTS_synth-DEPARTS_orig)/abs(DEPARTS_orig),
           ARRIVES_diff = abs(ARRIVES_synth-ARRIVES_orig)/abs(ARRIVES_orig))%>%
    filter(INCTOT_diff < p | INCWAGE_diff < p | INCWELFR_diff < p | INCINVST_diff < p
           | INCEARN_diff < p | POVERTY_diff < p | DEPARTS_diff < p |  ARRIVES_diff < p)%>%
    count(.)
  result = list(replications_uniques = sum(repl_synth),
                count_disclosure = count_disclosure[1,1], per_disclosure = 100*count_disclosure[1,1]/nrow(df_synth))
}

result <- generate_uniques_pp_for_acs(df_orig, df_synth)
result

generate_uniques_for_acs(df_orig, df_synth) #, exclude = c("hs_gpa", "fy_gpa") )

#generate_uniques_for_sat(as.data.frame(df_orig), df_synth, exclude = )

