

# Utility Evaluation for Synthetic Data
# Team: Destatis


### utility graphs:
# histogram
# corrplot
# utility tables


### utility metrics:
# KS Test
# pMSE Propensity Score
# pMSE tables
# sdcMicro::IL_variables

library(synthpop)
library(sdcMicro)
library(corrplot)



load("satgpa.rda")
satgpa <- as.data.frame(satgpa)
load("syn_sat_mnorm_simple.RData")
load("syn_sat_mnorm_complex.RData")
syn_sat_mnorm_complex <- syn_sat_mnorm_complex.RData


load("pums.RData")
load("pums_syn_syndatcart.RData")








# help functions

h_dat_acs <- function(df){
  
  names_acs <- c("X", "PUMA", "YEAR", "HHWT", "GQ", "PERWT", "SEX", "AGE", "MARST", "RACE", "HISPAN", "CITIZEN", "SPEAKENG", "HCOVANY",
                "HCOVPRIV", "HINSEMP", "HINSCAID", "HINSCARE", "EDUC", "EMPSTAT", "EMPSTATD", "LABFORCE", "WRKLSTWK",
                "ABSENT", "LOOKING", "AVAILBLE", "WRKRECAL", "WORKEDYR", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST",
                "INCEARN", "POVERTY", "DEPARTS", "ARRIVES", "sim_individual_id")
  w_num <-  c("X","HHWT", "PERWT", "AGE", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST", "INCEARN",
              "POVERTY", "DEPARTS", "ARRIVES", "sim_individual_id")
  w_cat <- names_acs[!names_acs%in%w_num]
  
  
  for(i in w_cat){
    try(df[,i] <- as.factor(as.character(df[,i])))
  }
  
  for(i in w_num){
    try(df[,i] <- as.numeric(df[,i]))
  }
  
  df$PUMA <- NULL
  df$sim_individual_id <- NULL
  df$X <- NULL
  
  return(df)
}



h_dat_sat <- function(df){
  
  
  w_num <-  c("sat_v", "sat_m", "sat_sum", "hs_gpa", "fy_gpa")
  w_cat <- "sex"
  
  
  for(i in w_cat){
    try(df[,i] <- as.factor(as.character(df[,i])))
  }
  
  for(i in w_num){
    try(df[,i] <- as.numeric(df[,i]))
  }
  
  return(df)
}




ks_check <- function(df_syn, df_orig){
  p <- c()
  for(i in 1:dim(df_orig)[2]){
    p[i] <- ks.test(as.numeric(df_syn[,i]), as.numeric(df_orig[,i]))$p.value
  }
  return(p)
}



cio <- function(df_syn, df_orig){
  
  vars <- names(df_syn)
  
  ci_all <- matrix(NA,1,4)
  for(i in vars){
    y <- i
    x <- vars[vars != y]
    f <- as.formula(paste(y, paste(x, collapse = " + "), sep = " ~ "))
    reg <- lm(formula = f, data = df_orig)
    reg_o <- lm(formula = f, data = df_syn)
    ci_df <- cbind(confint(reg), confint(reg_o))
    colnames(ci_df) <- c("l_o", "u_o", "l_s", "u_s")
    
    ci_all <- rbind(ci_all, ci_df)
    
  }
  
  ci_all <- as.data.frame(ci_all)
  
  ci_all$overlapping <- ifelse((ci_all$u_s > ci_all$l_o & ci_all$u_s < ci_all$u_o) | 
                                 (ci_all$l_s > ci_all$l_o & ci_all$l_s < ci_all$u_o), TRUE, FALSE)
  ci_all$sum_check <- round(ci_all[,1]+ ci_all[,2]+ ci_all[,3] + ci_all[,4], 3)
  
  ci_all <- na.omit(subset(ci_all, !ci_all$sum_check %in% c(-4,4)))
  
  cio <- NA
  for(i in 1:dim(ci_all)[1]){
    cio[i] <-  0.5*(((min(ci_all[i,2], ci_all[i,4]) - max(ci_all[i,1], ci_all[i,3]) )/(ci_all[i,2] - ci_all[i,1])) 
                    + ((min(ci_all[i,2], ci_all[i,4]) - max(ci_all[i,1], ci_all[i,3]) )/(ci_all[i,4] - ci_all[i,3])))
  }
  
  cio <- unlist(na.omit(cio[cio >= 0 & cio <= 1]))
  return(list(cio = cio, mean_valid = mean(ci_all$overlapping))
}





cio <- function(df_syn, df_orig){
  
  vars <- names(df_syn)
  
  ms_df <- matrix(NA,1,4)
  for(i in vars){
    y <- i
    x <- vars[vars != y]
    f <- as.formula(paste(y, paste(x, collapse = " + "), sep = " ~ "))
    reg <- lm(formula = f, data = df_orig)
    reg_o <- lm(formula = f, data = df_syn)
    coef <- coef(reg)
    coef_o <- coef(reg_o)
    se <- sqrt(diag(vcov(reg)))
    se_o <- sqrt(diag(vcov(reg_o)))
    
    ms_df <- rbind(ms_df, data.frame(coef, coef_o, se, se_o))
    
  }

}








# Beginn Analyse SAT 

orig_sat <- h_dat_sat(as.data.frame(satgpa))


syn_sat_mnorm_simple <- h_dat_sat(syn_sat_mnorm_simple)

# Simulated Data Simple
results_syn_sat_mnorm_simple <- list(
  ks = ks_check(orig_sat, syn_sat_mnorm_simple),
  comp = compare(syn_sat_mnorm_simple, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, syn_sat_mnorm_simple),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(syn_sat_mnorm_simple, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(syn_sat_mnorm_simple, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(syn_sat_mnorm_simple), as.data.frame(orig_sat), vars = names(orig_sat))
)  



# Simulated Data Complex
orig_sat <- as.data.frame(orig_sat)
syn_sat_mnorm_complex <- h_dat_sat(syn_sat_mnorm_complex.RData)
results_syn_sat_mnorm_complex <- list(
  ks = ks_check(orig_sat, syn_sat_mnorm_complex),
  comp = compare(syn_sat_mnorm_complex, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, syn_sat_mnorm_complex),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(syn_sat_mnorm_complex, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(syn_sat_mnorm_complex, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(syn_sat_mnorm_complex), as.data.frame(orig_sat), vars = names(orig_sat))
)  




# sm_sat_ipso_regsdc_hs_fy_no_corrections
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_ipso_regsdc_hs_fy_no_corrections.rda")
sm_ipso_regsdc_conf_hs_fy <- as.data.frame(h_dat_sat(sm_ipso_regsdc_conf_hs_fy))
orig_sat <- as.data.frame(orig_sat)
results_sm_ipso_regsdc_conf_hs_fy <- list(
  ks = ks_check(orig_sat, sm_ipso_regsdc_conf_hs_fy),
  comp = compare(sm_ipso_regsdc_conf_hs_fy, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, sm_ipso_regsdc_conf_hs_fy),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_ipso_regsdc_conf_hs_fy, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(sm_ipso_regsdc_conf_hs_fy, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_ipso_regsdc_conf_hs_fy), as.data.frame(orig_sat), vars = names(orig_sat))
)  



# sm_sat_gan_ctgan_epoch1000
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan_epoch1000.rda")
sm_sat_gan_ctgan_epoch1000 <- h_dat_sat(result_gan)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_gan_ctgan_epoch1000 <- list(
  ks = ks_check(orig_sat, sm_sat_gan_ctgan_epoch1000),
  comp = compare(sm_sat_gan_ctgan_epoch1000, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, sm_sat_gan_ctgan_epoch1000),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan_epoch1000, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(sm_sat_gan_ctgan_epoch1000, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan_epoch1000), as.data.frame(orig_sat), vars = names(orig_sat))
)  









# sm_sat_gan_ctgan
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan.rda")
sm_sat_gan_ctgan <- h_dat_sat(result_gan)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_gan_ctgan <- list(
  ks = ks_check(orig_sat, sm_sat_gan_ctgan),
  comp = compare(sm_sat_gan_ctgan, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, sm_sat_gan_ctgan),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(sm_sat_gan_ctgan, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan), as.data.frame(orig_sat), vars = names(orig_sat))
)  






# sm_sat_fcs_cart
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_fcs_cart.rda")
sm_sat_fcs_cart <- h_dat_sat(result)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_fcs_cart <- list(
  ks = ks_check(orig_sat, sm_sat_fcs_cart),
  comp = compare(sm_sat_fcs_cart, orig_sat, var = names(orig_sat)),
  il = IL_variables(orig_sat, sm_sat_fcs_cart),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_fcs_cart, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  ug = utility.gen(sm_sat_fcs_cart, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_fcs_cart), as.data.frame(orig_sat), vars = names(orig_sat))
)  




save(list = c("results_syn_sat_mnorm_simple",
               "results_syn_sat_mnorm_complex",
               "results_sm_ipso_regsdc_conf_hs_fy",
               "results_sm_sat_gan_ctgan_epoch1000",
               "results_sm_sat_gan_ctgan",
               "results_sm_sat_fcs_cart"), file = paste0(getwd(), "/results/results_sat.RData"))



load(paste0(getwd(), "/results/results_sat.RData"))


