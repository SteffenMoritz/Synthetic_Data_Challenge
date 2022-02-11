load("satgpa.rda")
library(ggplot2)
sat <- satgpa


require("RegSDC")
require(dplyr)
require("synthpop")
#Firs
glimpse(sat)

#REGSDCipso requires matrices as input
#x - non-confidential variables (here only sex), y - confidential variables
x <- as.matrix(sat$sex)
y <- as.matrix(sat[,2:6])

#Perfom IPSO 
y_synth <-RegSDCromm(y,lambda= Inf, x) # Same as RegSDCipso(y,x), lambda (ROMM parameter) has further tuning option 

#Merge synthetical Y with original X
sat_synth <- data.frame(sex =sat$sex,y_synth)


#Some checkup of the results

stats_snth <- sat_synth %>%
  group_by(sex)%>%
  summarize_all(list(mean=mean,sd=sd))

stats_orig <- sat %>%
  group_by(sex)%>%
  summarize_all(list(mean=mean,sd=sd))

abs(stats_snth-stats_orig)

model_synth <- lm(sat_v ~ x, data = df_synth)
summary(model_synth)

model_orig <- lm(sat_v ~ x, data = sat)
summary(model_orig)

cov(y) - cov(y_synth)
cov(residuals(lm(y ~ x))) - cov(residuals(lm(y_synth ~ x)))

#Missing: Is data normally distributed?
#Plot empirical densities of variables
p <- list()
for(i in 2:6){
  p[[i-1]]<-ggplot(sat,aes_string(x= names(sat)[i], color = "factor(sex)"))+
    geom_density()
}
ggpubr::ggarrange(plotlist = p)


#Other data analysis
summary(sat)

sat%>%
  group_by(sex)%>%
  summarize_all(list(min=min,max=max))
