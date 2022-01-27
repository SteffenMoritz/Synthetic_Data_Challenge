#install.packages("synthpop")

library(synthpop)

load("satgpa.rda")

mydata <- satgpa[,c("sex", "sat_v", "sat_m", "hs_gpa", "fy_gpa")]
#mydata <- satgpa[,1:3]
# test <- rep("male", length(mydata$sex))
# test[mydata$sex==2]<-"female"
# mydata$sex <- test
# mydata$sex <- as.numeric(mydata$sex)
# mydata$sat_v <- as.numeric(mydata$sat_v)
# mydata$sat_m <- as.numeric(mydata$sat_m)
# mydata$hs_gpa <- as.numeric(mydata$hs_gpa)
# mydata$fy_gpa <- as.numeric(mydata$fy_gpa)



synth_dat <- syn(mydata)

summary(synth_dat)

satgpa_synth <- synth_dat$syn
satgpa_synth$sat_sum <- satgpa_synth$sat_m+satgpa_synth$sat_v
satgpa_synth <- satgpa_synth[,colnames(satgpa)]


#Diese FUnktion sollte eigentlich eine grafische Übersicht ausgeben,
# anhand derer man sieht, wie nah der synthetische Datensatz am origialen ist.
# Tut sie aber nicht...
compare(synth_dat,mydata, stat="counts")


