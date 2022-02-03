library(synthpop)
library(dplyr)
library(tidyr)

load("pums.RData")
#load("results/rt_acs_fcs_samp100000.rda")
load("results/fg_ipso_regsdc_conf_from_INCTOT.rda")
df_orig <- pums#ACS_samp100000#pums
df_synth <- fg_ipso_regsdc_conf_from_INCTOT#ACS_synth_samp100000
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
    transmute(INCTOT_diff = abs(INCTOT_synth-INCTOT_orig)/abs(INCTOT_orig)<p, 
           INCWAGE_diff = abs(INCWAGE_synth-INCWAGE_orig)/abs(INCWAGE_orig)<p,
           INCWELFR_diff = abs(INCWELFR_synth-INCWELFR_orig)/abs(INCWELFR_orig)<p,
           INCINVST_diff = abs(INCINVST_synth-INCINVST_orig)/abs(INCINVST_orig)<p,
           INCEARN_diff = abs(INCEARN_synth-INCEARN_orig)/abs(INCEARN_orig)<p,
           POVERTY_diff = abs(POVERTY_synth-POVERTY_orig)/abs(POVERTY_orig)<p,
           DEPARTS_diff = abs(DEPARTS_synth-DEPARTS_orig)/abs(DEPARTS_orig)<p,
           ARRIVES_diff = abs(ARRIVES_synth-ARRIVES_orig)/abs(ARRIVES_orig)<p)%>%
    replace(is.na(.), FALSE)%>%
    transmute(
           at_least_1_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 1,
           at_least_2_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 2,
           at_least_3_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 3,
           at_least_4_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 4,
           at_least_5_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 5,
           at_least_6_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 6,
           at_least_7_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 7,
           at_least_8_discl = INCTOT_diff+INCWAGE_diff+INCWELFR_diff+INCINVST_diff+INCEARN_diff+POVERTY_diff+DEPARTS_diff+ARRIVES_diff  >= 8
           )%>%
    summarize_all(sum)
  count_disclosure
    
#  result = list(replications_uniques = sum(repl_synth),
#                count_disclosure = count_disclosure[1,1], per_disclosure = 100*count_disclosure[1,1]/nrow(df_synth))
}

result <- generate_uniques_pp_for_acs(df_orig, df_synth)
result

<<<<<<< HEAD
#generate_uniques_for_acs(as.data.frame(df_orig), df_synth)#, exclude = c("hs_gpa", "fy_gpa") )
=======
generate_uniques_for_acs(df_orig, df_synth) #, exclude = c("hs_gpa", "fy_gpa") )
>>>>>>> 6f0860f1ddc6f22624328925074edcb8671b72f4

#generate_uniques_for_sat(as.data.frame(df_orig), df_synth, exclude = )

