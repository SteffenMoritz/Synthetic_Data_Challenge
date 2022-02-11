

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
library(here)


load("satgpa.rda")
satgpa <- as.data.frame(satgpa)
load("syn_sat_mnorm_simple.RData")
load("syn_sat_mnorm_complex.RData")
syn_sat_mnorm_complex <- syn_sat_mnorm_complex.RData


load("pums.RData")
load("~/GitHub/Synthetic_Data_Challenge/results/pums_syn_syndatcart.RData")







# help functions

h_dat_acs <- function(df){
  
  names_acs <- c("X", "PUMS", "YEAR", "HHWT", "GQ", "PERWT", "SEX", "AGE", "MARST", "RACE", "HISPAN", "CITIZEN", "SPEAKENG", "HCOVANY",
                "HCOVPRIV", "HINSEMP", "HINSCAID", "HINSCARE", "EDUC", "EMPSTAT", "EMPSTATD", "LABFORCE", "WRKLSTWK",
                "ABSENT", "LOOKING", "AVAILBLE", "WRKRECAL", "WORKEDYR", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST",
                "INCEARN", "POVERTY", "DEPARTS", "ARRIVES")
  w_num <-  c("X","HHWT", "PERWT", "AGE", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST", "INCEARN",
              "POVERTY", "DEPARTS", "ARRIVES")
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








# Beginn Analyse ACS 

#y.vars <- c("sat_v", "sat_m", "sat_sum", "hs_gpa", "fy_gpa")
y.vars <- c("HHWT", "PERWT", "AGE", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST", "INCEARN",
            "POVERTY", "DEPARTS", "ARRIVES")

acs_num_bin <-  c("HHWT", "PERWT", "AGE", "INCTOT", "INCWAGE", "INCWELFR", "INCINVST", "INCEARN",
            "POVERTY", "DEPARTS", "ARRIVES", "SEX", "HCOVANY", "HCOVPRIV", "HINSEMP", "HINSCAID",
            "HINSCAID, HINSCARE", "LABFORCE", "YEAR")


#orig_sat <- h_dat_sat(as.data.frame(satgpa))
orig_acs <- h_dat_acs(as.data.frame(pums))


#syn_sat_mnorm_simple <- h_dat_sat(syn_sat_mnorm_simple)
pums_syn_syndatcart$INCTOT <- pums_syn_syndatcart$INCWAGE + pums_syn_syndatcart$INCWELFR + pums_syn_syndatcart$INCINVST + pums_syn_syndatcart$INCEARN
syn_acs_mnorm_simple <- h_dat_acs(pums_syn_syndatcart)




synd <- syn_acs_mnorm_simple
orig <- orig_acs[names(synd)]
max_row <- nrow(synd)


c1a <- seq(1, 37, by = 5)
c2a <- seq(2, 37, by = 5)
c3a <- seq(3, 37, by = 5)
c4a <- seq(4, 37, by = 5)
c5a <- seq(5, 37, by = 5)

c1 <- names(synd[1:ncol(synd)%in%c1a])
c2 <- names(synd[1:ncol(synd)%in%c2a])
c3 <- names(synd[1:ncol(synd)%in%c3a])
c4 <- names(synd[1:ncol(synd)%in%c4a])
c5 <- names(synd[1:ncol(synd)%in%c5a])


Sys.time()

# Simulated Data Simple
results_acs_sat_mnorm_simple <- list(
  comp1 = compare(synd[c1], orig[c1], var = names(orig[c1])),
  comp2 = compare(synd[c2], orig[c2], var = names(orig[c2])),
  comp3 = compare(synd[c3], orig[c3], var = names(orig[c3])),
  comp4 = compare(synd[c4], orig[c4], var = names(orig[c4])),
  comp5 = compare(synd[c5], orig[c5], var = names(orig[c5])),
  
  corr1 <- cor(as.data.frame(lapply(orig[,names(synd)%in%acs_num_bin], function(x)as.numeric(as.character(x))))),
  corr2 <- cor(as.data.frame(lapply(synd[,names(synd)%in%acs_num_bin], function(x)as.numeric(as.character(x))))),
  
  #cio = cio(synd, orig, y.vars),
  #bp1 = boxplot(cio$ms_df$coef/cio$ms_df$coef_o, ylim = c(-100,100))
  #bp2 = boxplot(cio$ms_df$se/cio$ms_df$se_o, ylim = c(-100,100))
  #ks = ks_check(orig, synd),
  il = IL_variables(orig, synd),
  ug1 = utility.gen(as.data.frame(synd)[sample(1:max_row, size = 10000), c1], as.data.frame(orig)[sample(1:max_row, size = 10000), c1]),
  ug2 = utility.gen(as.data.frame(synd)[sample(1:max_row, size = 10000), c2], as.data.frame(orig)[sample(1:max_row, size = 10000), c2]),
  ug3 = utility.gen(as.data.frame(synd)[sample(1:max_row, size = 10000), c3], as.data.frame(orig)[sample(1:max_row, size = 10000), c3]),
  ug4 = utility.gen(as.data.frame(synd)[sample(1:max_row, size = 10000), c4], as.data.frame(orig)[sample(1:max_row, size = 10000), c4]),
  ug5 = utility.gen(as.data.frame(synd)[sample(1:max_row, size = 10000), c5], as.data.frame(orig)[sample(1:max_row, size = 10000), c5]),
  
  ut1_1 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 10000), c1], as.data.frame(orig)[sample(1:max_row, size = 10000), c1], vars = c1, max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "S_pMSE"),
  ut1_2 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 10000), c2], as.data.frame(orig)[sample(1:max_row, size = 10000), c2], vars = c2, max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "S_pMSE"),
  ut1_3 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 10000), c3], as.data.frame(orig)[sample(1:max_row, size = 10000), c3], vars = c3, max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "S_pMSE"),
  ut1_4 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 10000), c4], as.data.frame(orig)[sample(1:max_row, size = 10000), c4], vars = c4, max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "S_pMSE"),
  ut1_5 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 10000), c5], as.data.frame(orig)[sample(1:max_row, size = 10000), c5], vars = c5, max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "S_pMSE"),
  
  
  ut2_1 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c1], as.data.frame(orig)[sample(1:max_row, size = 100000), c1], vars = c1, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "dBhatt"),
  ut2_2 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c2], as.data.frame(orig)[sample(1:max_row, size = 100000), c2], vars = c2, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "dBhatt"),
  ut2_3 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c3], as.data.frame(orig)[sample(1:max_row, size = 100000), c3], vars = c3, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "dBhatt"),
  ut2_4 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c4], as.data.frame(orig)[sample(1:max_row, size = 100000), c4], vars = c4, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "dBhatt"),
  ut2_5 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c5], as.data.frame(orig)[sample(1:max_row, size = 100000), c5], vars = c5, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "dBhatt"),
  
  
  ut3_1 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c1], as.data.frame(orig)[sample(1:max_row, size = 100000), c1], vars = c1, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "MabsDD"),
  ut3_2 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c2], as.data.frame(orig)[sample(1:max_row, size = 100000), c2], vars = c2, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "MabsDD"),
  ut3_3 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c3], as.data.frame(orig)[sample(1:max_row, size = 100000), c3], vars = c3, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "MabsDD"),
  ut3_4 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c4], as.data.frame(orig)[sample(1:max_row, size = 100000), c4], vars = c4, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "MabsDD"),
  ut3_5 = utility.tables(as.data.frame(synd)[sample(1:max_row, size = 100000), c5], as.data.frame(orig)[sample(1:max_row, size = 100000), c5], vars = c5, max.scale = 1, tab.stats = c("pMSE", "S_pMSE", "MabsDD"), plot.stat = "MabsDD")
  
)  
save(list = c("results_acs_sat_mnorm_simple"), file = paste0(getwd(), "/Evaluation_ACS_SYND_SIMP/results_acs_synd_2.RData"))

Sys.time()





# Simulated Data Complex

# did not produce results




# sm_sat_ipso_regsdc_hs_fy_no_corrections
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_ipso_regsdc_hs_fy_no_corrections.rda")
sm_ipso_regsdc_conf_hs_fy <- as.data.frame(h_dat_sat(sm_ipso_regsdc_conf_hs_fy))
orig_acs <- as.data.frame(orig_acs)
























# sm_sat_gan_ctgan_epoch1000
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan_epoch1000.rda")
sm_sat_gan_ctgan_epoch1000 <- h_dat_sat(result_gan)
orig_acs <- as.data.frame(orig_acs)

results_sm_sat_gan_ctgan_epoch1000 <- list(
  comp = compare(sm_sat_gan_ctgan_epoch1000, orig_acs, var = names(orig_acs)),
  cp1 = corrplot(cor(sapply(orig_acs, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan_epoch1000, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_gan_ctgan_epoch1000, orig_acs, y.vars),
  ks = ks_check(orig_acs, sm_sat_gan_ctgan_epoch1000),
  il = IL_variables(orig_acs, sm_sat_gan_ctgan_epoch1000),
  ug = utility.gen(sm_sat_gan_ctgan_epoch1000, as.data.frame(orig_acs)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan_epoch1000), as.data.frame(orig_acs), vars = names(orig_acs), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  









# sm_sat_gan_ctgan
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_gan_ctgan.rda")
sm_sat_gan_ctgan <- h_dat_sat(result_gan)
orig_acs <- as.data.frame(orig_acs)

results_sm_sat_gan_ctgan <- list(
  comp = compare(sm_sat_gan_ctgan, orig_acs, var = names(orig_acs)),
  cp1 = corrplot(cor(sapply(orig_acs, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_gan_ctgan, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_gan_ctgan, orig_acs, y.vars),
  ks = ks_check(orig_acs, sm_sat_gan_ctgan),
  il = IL_variables(orig_acs, sm_sat_gan_ctgan),
  ug = utility.gen(sm_sat_gan_ctgan, as.data.frame(orig_acs)),
  ut = utility.tables(as.data.frame(sm_sat_gan_ctgan), as.data.frame(orig_acs), vars = names(orig_acs), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  






# sm_sat_fcs_cart
load("~/GitHub/Synthetic_Data_Challenge/results/sm_sat_fcs_cart.rda")
sm_sat_fcs_cart <- h_dat_sat(sm_sat_fcs_cart)
orig_acs <- as.data.frame(orig_acs)

results_sm_sat_fcs_cart <- list(
  comp = compare(sm_sat_fcs_cart, orig_acs, var = names(orig_acs)),
  cp1 = corrplot(cor(sapply(orig_acs, as.numeric)), method = "color", type = "lower", main = "Original"),
  cp2 = corrplot(cor(sapply(sm_sat_fcs_cart, as.numeric)), method = "color", type = "lower", main = "Synthetic"),
  cio = cio(sm_sat_fcs_cart, orig_acs, y.vars),
  ks = ks_check(orig_acs, sm_sat_fcs_cart),
  il = IL_variables(orig_acs, sm_sat_fcs_cart),
  ug = utility.gen(sm_sat_fcs_cart, as.data.frame(orig_acs)),
  ut = utility.tables(as.data.frame(sm_sat_fcs_cart), as.data.frame(orig_acs), vars = names(orig_acs), max.scale = 20, tab.stats = c("pMSE", "S_pMSE", "MabsDD"))
)  



save(list = c("results_syn_acs_mnorm_simple",
               "results_syn_sat_mnorm_complex",
               "results_sm_ipso_regsdc_conf_hs_fy",
               "results_sm_sat_gan_ctgan_epoch1000",
               "results_sm_sat_gan_ctgan",
               "results_sm_sat_fcs_cart"), file = paste0(getwd(), "/results/results_sat2.RData"))



load(paste0(getwd(), "/results/results_sat2.RData"))


