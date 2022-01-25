###Beide Datensaetze einlesen:
#dataset_ACS <- read.csv("C:/Users/User/Desktop/IL_OH_10Y_PUMS.csv")
#dataset_SAT <- read.csv("C:/Users/User/Desktop/satgpa.csv")
####
#load("C:/Users/User/Desktop/satgpa.rda")
library(synthpop)

#Method: Fully Conditional Specification
#parameters: default
s1 <- syn(satgpa[,-4]) #ohne die summenspalte
synth_data <-s1$syn

#compare(synth_data,satgpa, stat = "counts")


#Data Utility measure:
utility.tab(s1,satgpa[,-4], colnames(satgpa[,-4])[c(1,2)])
utility.gen(s1,satgpa[,-4])
#Privacy Evaluation:
replicated.uniques(s1,satgpa[,-4])