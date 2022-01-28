library(ggplot2)

require("RegSDC")
require(dplyr)
require("synthpop")
load("pums.RData")
#Firs

#test <- read.csv("IL_OH_10Y_PUMS_FG.csv")
ACS <- PUMS
ACS$PUMA <- as.numeric(unlist(lapply(test$PUMA, function(x)gsub("-","",x))))

#REGSDCipso requires matrices as input
# confidential all variables related to income
x <- as.matrix(ACS[,2:28])
y <- as.matrix(ACS[,29:36])

#Perfom IPSO 
y_synth <-RegSDCromm(y,lambda= Inf, x) # Same as RegSDCipso(y,x), lambda (ROMM parameter) has further tuning option 

#Merge synthetical Y with original X
fg_ipso_regsdc_conf_from_INCTOT <- data.frame(ACS[,2:28],y_synth)

save(fg_ipso_regsdc_conf_from_INCTOT, file = "results/fg_ipso_regsdc_conf_from_INCTOT.rda")

#Example: 
x <- as.matrix(data.frame( ACS[,2:3],ACS[,5:28]))
y <- as.matrix(data.frame(HHWT= ACS[,4],ACS[,29:36]))

#Perfom IPSO 
y_synth <-RegSDCromm(y,lambda= Inf, x) # Same as RegSDCipso(y,x), lambda (ROMM parameter) has further tuning option 

#Merge synthetical Y with original X
fg_ipso_regsdc_conf_from_INCTOT_HHWTconf <- data.frame(ACS[,2:3],HHWT=y_synth[,1],ACS[,5:28],y_synth[,2:9])

save(fg_ipso_regsdc_conf_from_INCTOT, file = "results/fg_ipso_regsdc_conf_from_INCTOT_HHWTconf.rda")




