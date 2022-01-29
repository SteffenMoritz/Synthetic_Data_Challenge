

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






cio <- function(df_syn, df_orig, y.vars){
  
  vars <- names(df_syn)
  ci_all <- matrix(NA,1,4)
  ms_df <- matrix(NA,1,4)
  mhd_05 <- c()
  
  for(i in y.vars){
    y <- i
    x <- vars[vars != y]
    f <- as.formula(paste(y, paste(x, collapse = " + "), sep = " ~ "))
    try(reg <- lm(formula = f, data = df_orig))
    try(reg_o <- lm(formula = f, data = df_syn))
    try(coef <- coef(reg))
    try(coef_o <- coef(reg_o))
    try(se <- sqrt(diag(vcov(reg))))
    try(se_o <- sqrt(diag(vcov(reg_o))))
    try(mhd <- t(coef - coef_o)%*%vcov(reg_o)%*%(coef - coef_o)   )
    try(mhd_sig <- ifelse(mhd > qchisq(0.95, length(coef)), 1, 0))
    
    ms_df <- rbind(ms_df, cbind(coef, coef_o, se, se_o))
    mhd_05 <- c(mhd_05, mhd_sig)

  }
  
  mhd_05 <- mhd_05
  ms_df <- as.data.frame(ms_df)
  
  res_list <- list(ms_df = as.data.frame(ms_df), 
                   mrd_coef = mean(na.omit(ms_df$coef/ms_df$coef_o-1)),
                   mrd_se = mean(na.omit(ms_df$se/ms_df$se_o-1)),
                   mhd_05 = mean(na.omit(mhd_05)) )

  return(res_list)
}








# Beginn Analyse SAT 

y.vars <- c("sat_v", "sat_m", "sat_sum", "hs_gpa", "fy_gpa")


orig_sat <- h_dat_sat(as.data.frame(satgpa))


syn_sat_mnorm_simple <- h_dat_sat(syn_sat_mnorm_simple)

# Simulated Data Simple
results_syn_sat_mnorm_simple <- list(
  comp = compare(syn_sat_mnorm_simple, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(syn_sat_mnorm_simple, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(syn_sat_mnorm_simple, orig_sat, y.vars),
  ks = ks_check(orig_sat, syn_sat_mnorm_simple),
  il = IL_variables(orig_sat, syn_sat_mnorm_simple),
  ug = utility.gen(syn_sat_mnorm_simple, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(syn_sat_mnorm_simple), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  



# Simulated Data Complex
orig_sat <- as.data.frame(orig_sat)
syn_sat_mnorm_complex <- h_dat_sat(syn_sat_mnorm_complex.RData)
results_syn_sat_mnorm_complex <- list(
  comp = compare(syn_sat_mnorm_complex, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(syn_sat_mnorm_complex, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(syn_sat_mnorm_complex, orig_sat, y.vars),
  ks = ks_check(orig_sat, syn_sat_mnorm_complex),
  il = IL_variables(orig_sat, syn_sat_mnorm_complex),
  ug = utility.gen(syn_sat_mnorm_complex, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(syn_sat_mnorm_complex), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  




# sm_sat_ipso_regsdc_hs_fy_no_corrections
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_ipso_regsdc_hs_fy_no_corrections.rda")
sm_ipso_regsdc_conf_hs_fy <- as.data.frame(h_dat_sat(sm_ipso_regsdc_conf_hs_fy))
orig_sat <- as.data.frame(orig_sat)
results_sm_ipso_regsdc_conf_hs_fy <- list(
  comp = compare(sm_ipso_regsdc_conf_hs_fy, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_ipso_regsdc_conf_hs_fy, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_ipso_regsdc_conf_hs_fy, orig_sat, y.vars),
  ks = ks_check(orig_sat, sm_ipso_regsdc_conf_hs_fy),
  il = IL_variables(orig_sat, sm_ipso_regsdc_conf_hs_fy),
  ug = utility.gen(sm_ipso_regsdc_conf_hs_fy, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_ipso_regsdc_conf_hs_fy), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  



# sm_sat_gan_ctgan_epoch1000
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan_epoch1000.rda")
sm_sat_gan_ctgan_epoch1000 <- h_dat_sat(result_gan)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_gan_ctgan_epoch1000 <- list(
  comp = compare(sm_sat_gan_ctgan_epoch1000, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan_epoch1000, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_gan_ctgan_epoch1000, orig_sat, y.vars),
  ks = ks_check(orig_sat, sm_sat_gan_ctgan_epoch1000),
  il = IL_variables(orig_sat, sm_sat_gan_ctgan_epoch1000),
  ug = utility.gen(sm_sat_gan_ctgan_epoch1000, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan_epoch1000), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  









# sm_sat_gan_ctgan
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan.rda")
sm_sat_gan_ctgan <- h_dat_sat(result_gan)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_gan_ctgan <- list(
  comp = compare(sm_sat_gan_ctgan, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_gan_ctgan, orig_sat, y.vars),
  ks = ks_check(orig_sat, sm_sat_gan_ctgan),
  il = IL_variables(orig_sat, sm_sat_gan_ctgan),
  ug = utility.gen(sm_sat_gan_ctgan, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  






# sm_sat_fcs_cart
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_fcs_cart.rda")
sm_sat_fcs_cart <- h_dat_sat(sm_sat_fcs_cart)
orig_sat <- as.data.frame(orig_sat)

results_sm_sat_fcs_cart <- list(
  comp = compare(sm_sat_fcs_cart, orig_sat, var = names(orig_sat)),
  cp1 = corrplot(cor(sapply(orig_sat, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_fcs_cart, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_fcs_cart, orig_sat, y.vars),
  ks = ks_check(orig_sat, sm_sat_fcs_cart),
  il = IL_variables(orig_sat, sm_sat_fcs_cart),
  ug = utility.gen(sm_sat_fcs_cart, as.data.frame(orig_sat)),
  ut = utility.tables(as.data.frame(sm_sat_fcs_cart), as.data.frame(orig_sat), vars = names(orig_sat), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  



save(list = c("results_syn_sat_mnorm_simple",
               "results_syn_sat_mnorm_complex",
               "results_sm_ipso_regsdc_conf_hs_fy",
               "results_sm_sat_gan_ctgan_epoch1000",
               "results_sm_sat_gan_ctgan",
               "results_sm_sat_fcs_cart"), file = paste0(getwd(), "/results/results_sat2.RData"))



load(paste0(getwd(), "/results/results_sat2.RData"))


