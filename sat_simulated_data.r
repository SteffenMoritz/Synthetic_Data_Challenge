

load("satgpa.rda")

sat <- satgpa

options(digits=7)

library(semTools)
library(Rfast)
#library(mvtnorm)
library(Matrix)

# Easy example #

sat_sex1 <- sat[sat$sex == 1, ]
sat_sex1$sex <- NULL
sat_sex1$sat_sum <- NULL
sat_sex2 <- sat[sat$sex == 2, ]
sat_sex2$sex <- NULL
sat_sex2$sat_sum <- NULL


#sat_sex1_mn <- mvnorm.mle(as.matrix(sat_sex1))
#sat_sex2_mn <- mvnorm.mle(as.matrix(sat_sex2))
#rmvnorm(n = sum(sat$sex == 1), mu = sat_sex1_mn$mu, sigma = sat_sex1_mn$sigma)
#rmvnorm(n = sum(sat$sex == 2), mu = sat_sex2_mn$mu, sigma = sat_sex2_mn$sigma)

mu_sat_sex1 <- apply(sat_sex1, 2, mean)
mu_sat_sex2 <- apply(sat_sex2, 2, mean)
cov_sat_sex1 <- nearPD(cov(sat_sex1))$mat
cov_sat_sex2 <- nearPD(cov(sat_sex2))$mat

set.seed(4389)
syn_sat_sex1 <- rmvnorm(n = sum(sat$sex == 1), mu = mu_sat_sex1, sigma = cov_sat_sex1)
syn_sat_sex2 <- rmvnorm(n = sum(sat$sex == 2), mu = mu_sat_sex2, sigma = cov_sat_sex2)

syn_sat_sex1 <- as.data.frame(syn_sat_sex1)
syn_sat_sex2 <- as.data.frame(syn_sat_sex2)

syn_sat_sex1$sex <- 1
syn_sat_sex2$sex <- 2


syn_sat_mnorm <- rbind(syn_sat_sex1, syn_sat_sex2)
syn_sat_mnorm$sat_sum <- syn_sat_mnorm$sat_v + syn_sat_mnorm$sat_m
syn_sat_mnorm <- syn_sat_mnorm[, names(sat)] 
syn_sat_mnorm_1 <- syn_sat_mnorm
# Fertiger über multivariate Normalverteilung bedingt auf "sex"Datensatz: syn_sat_mnorm

plot(sat)
plot(syn_sat_mnorm)





# a little more advanced (Vale and Maurelli (1983) method)

sat_sex1 <- sat[sat$sex == 1, ]
sat_sex1$sex <- NULL
sat_sex1$sat_sum <- NULL
sat_sex2 <- sat[sat$sex == 2, ]
sat_sex2$sex <- NULL
sat_sex2$sat_sum <- NULL

mu_sat_sex1 <- apply(sat_sex1, 2, mean)
mu_sat_sex2 <- apply(sat_sex2, 2, mean)
cov_sat_sex1 <- as.matrix(nearPD(cov(sat_sex1))$mat)
cov_sat_sex2 <- as.matrix(nearPD(cov(sat_sex2))$mat)

ktss_sex1 <- apply(sat_sex1, 2, kurtosis)[1,]
ktss_sex2 <- apply(sat_sex2, 2, kurtosis)[1,]

skwn_sex1 <- apply(sat_sex1, 2, skew)
skwn_sex2 <- apply(sat_sex2, 2, skew)

set.seed(20129)
syn_sat_sex1_2 <- mvrnonnorm(n = sum(sat$sex == 1), mu = mu_sat_sex1, Sigma = cov_sat_sex1, skewness = skwn_sex1, kurtosis = ktss_sex1)
syn_sat_sex2_2 <- mvrnonnorm(n = sum(sat$sex == 2), mu = mu_sat_sex2, Sigma = cov_sat_sex2, skewness = skwn_sex2, kurtosis = ktss_sex2)

syn_sat_sex1 <- as.data.frame(syn_sat_sex1_2)
syn_sat_sex2 <- as.data.frame(syn_sat_sex2_2)

syn_sat_sex1$sex <- 1
syn_sat_sex2$sex <- 2

syn_sat_mnorm <- rbind(syn_sat_sex1, syn_sat_sex2)
syn_sat_mnorm$sat_sum <- syn_sat_mnorm$sat_v + syn_sat_mnorm$sat_m
syn_sat_mnorm <- syn_sat_mnorm[, names(sat)] 
syn_sat_mnorm_2 <- syn_sat_mnorm
# Fertiger über multivariate komplexe Verteiliung bedingt auf "sex" Datensatz: syn_sat_mnorm2

plot(sat)
plot(syn_sat_mnorm_2)

plot(density(sat$fy_gpa))
lines(density(syn_sat_mnorm_2$fy_gpa), col = 2)
lines(density(syn_sat_mnorm_1$fy_gpa), col = 3)






# IL_OH_10Y PUMS 

library("synthpop")
library("arrow")

#pums <- read.csv(file = "C:/Users/Hariolf/Desktop/IL_OH_10Y_PUMS.csv")
#save(pums, file = "C:/Users/Hariolf/Documents/GitHub/https-github.com-SteffenMoritz-Synthetic_Data_Challenge/pums.RData")
load("C:/Users/Hariolf/Documents/GitHub/https-github.com-SteffenMoritz-Synthetic_Data_Challenge/pums.RData")

pums$x <- NULL

pums <- pums[sample(1:100000, size = 100000),]


num_vars <- c("HHWT", "PERWT", "INCWAGE", "INCWELFR", "INCINVST", "INCEARN", "POVERTY", "DEPARTS", "ARRIVES")
#num_vars <- c("HHWT", "INCEARN", "DEPARTS")
#num_vars <- c("INCWAGE", "INCWELFR", "INCEARN", "POVERTY")


pums_sub <- pums[,num_vars]


mu_pums_sub <- apply(pums_sub, 2, mean)
cov_pums_sub <- nearPD(cov(pums_sub))$mat

set.seed(9290)
pums_sub_syn <- rmvnorm(n = nrow(pums_sub), mu = mu_pums_sub, sigma = cov_pums_sub)
pums_sub_syn_simple <- as.data.frame(pums_sub_syn)


# barely applicable with only few variables. 
cov_pums_sub <- as.matrix(nearPD(cov_pums_sub)$mat)
ktss_ps <- apply(pums_sub, 2, kurtosis)[1,]
skwn_ps <- apply(pums_sub, 2, skew)
pums_sub_syn_cmplx <- mvrnonnorm(n = nrow(pums_sub), mu = mu_pums_sub, Sigma = cov_pums_sub, skewness = skwn_ps, kurtosis = ktss_ps)



# proceed only with pums_sub_syn_simple

pums_sub_syn_simple$HHWT[pums_sub_syn_simple$HHWT <=1] <- 1
pums_sub_syn_simple$PERWT[pums_sub_syn_simple$PERWT <=1] <- 1
pums_sub_syn_simple$INCWAGE[pums_sub_syn_simple$INCWAGE <=0] <- 0
pums_sub_syn_simple$INCWELFR[pums_sub_syn_simple$INCWELFR<=0] <- 0
pums_sub_syn_simple$POVERTY[pums_sub_syn_simple$POVERTY<=0] <- 0
pums_sub_syn_simple$DEPARTS[pums_sub_syn_simple$DEPARTS<=0] <- 0
pums_sub_syn_simple$ARRIVES [pums_sub_syn_simple$ARRIVES <=0] <- 0


apply(pums_sub_syn_simple, 2, summary)
apply(pums_sub, 2, summary)



xp <- pums_sub_syn_simple
vars_sel <- num_vars
vars_gen <- names(pums)[!names(pums)%in%vars_sel]
vars_gen <- vars_gen[!vars_gen %in% c("X", "sim_individual_id", "INCTOT")]
test <- 0

for(v in vars_gen){
  cart_fit <- syn.cart(pums[,v], pums[,vars_sel], pums_sub_syn_simple, smoothing = "", proper = FALSE, minbucket = 5, cp = 1e-08)
  assign(v, cart_fit$res)
  pums_sub_syn_simple <- cbind(assign(v, cart_fit$res), pums_sub_syn_simple)
  colnames(pums_sub_syn_simple)[1] <- v
  vars_sel <- c(vars_sel, paste(v))
  test <- test +1
  cat(test, sep="\n")
}

pums_syn_syndatcart <- pums_sub_syn_simple

syn_sat_mnorm_simple <- syn_sat_mnorm_1
syn_sat_mnorm_complex.RData <- syn_sat_mnorm_2


save(list = "syn_sat_mnorm_simple", file = "C:/Users/Hariolf/Documents/GitHub/https-github.com-SteffenMoritz-Synthetic_Data_Challenge/syn_sat_mnorm_simple.RData")
save(list = "syn_sat_mnorm_complex.RData", file = "C:/Users/Hariolf/Documents/GitHub/https-github.com-SteffenMoritz-Synthetic_Data_Challenge/syn_sat_mnorm_complex.RData")
save(list = "pums_syn_syndatcart", file = "C:/Users/Hariolf/Documents/GitHub/https-github.com-SteffenMoritz-Synthetic_Data_Challenge/pums_syn_syndatcart.RData")
# pums_syn_syndatcart: not working with mit non-normal multivariate distribution











