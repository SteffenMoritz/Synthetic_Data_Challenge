# Daten einlesen

load("acs.rdata")

# Korrelationen berechnen
ACS_cor<-cor(ACS[,-c(1,2)],method="spearman")



# Funktion, die eine bessere Übersicht erste
test<-function(x){
  
  if(abs(x)<0.3){
    result<-NA
  }
  else{
    result<-x
  }
  return(result)
  
  
}


# Korrelationsmatrix, in der nur noch Werte deren Betrag größer ist als 0.3
# abzulesen sind.
# Gerne hätte ich eine Liste in der nur die stark korrelierten
# Wertmerkmalskombinationen aufgelistet sind, aber leider weiß ich
# nicht, wie ich das hinbekomme... :-/
high_cor<-apply(ACS_cor,c(1,2),test)


# Erzeuge Supsample um weitere Testberechnungen durchzuführen,
# ohne die Rechenzeiten unnötig hochzuschreiben
randnum <- sample(x=(1:dim(ACS)[1]),size=2000)


# gafische Übersicht 
png(filename="pairs_test.png", width=6000, height=6000)
  pairs(ACS[randnum,-c(1,2)])
dev.off()


# Interessant wirken u.a.:
# Die Kombinationen beinaher alle "INC..."-Variablen
# HHWT & PERWT
# AGE & HINSCARE, EMPSTAT, EMPSTATD, LABFORCE, WORKEDYR
# EMPSTAT, EMPSTATD, LABFORCE, WRKSTWRK, ABSENT, LOOKING





#### Teste FCS ######



library(synthpop)

#1
synth_dat1 <- syn(ACS[,c("HHWT", "PERWT")])
ACS_synth1 <- synth_dat$syn

compare(synth_dat1,ACS[,c("HHWT", "PERWT")], stat="counts")




#2
synth_dat2 <- syn(ACS[,c("AGE", "HINSCARE", "EMPSTAT", "EMPSTATD", "LABFORCE", "WORKEDYR")])
ACS_synth2 <- synth_dat$syn

compare(synth_dat2,ACS[,c("AGE", "HINSCARE", "EMPSTAT", "EMPSTATD", "LABFORCE", "WORKEDYR")], stat="counts")


# Und jetzt schauen wir uns mal de Zusammenhänge zwischen den Merkmalen mal an
# (a) grafisch
pairs(ACS_synth2[randnum,])
pairs(ACS[randnum,c("AGE", "HINSCARE", "EMPSTAT", "EMPSTATD", "LABFORCE", "WORKEDYR")])

# (b) Korrelationen
cor(ACS_synth2,method="spearman")
cor(ACS[,c("AGE", "HINSCARE", "EMPSTAT", "EMPSTATD", "LABFORCE", "WORKEDYR")],method="spearman")
