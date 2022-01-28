library(synthpop)

# Load dataset
# setwd must be at project folder for load/save

#load("satgpa.rda")
load("acs.rdata")

acs <- ACS

cols <- c('PUMA',
          'YEAR',
          'GQ',
          'SEX',
          'MARST',
          'RACE',
          'HISPAN',
          'CITIZEN',
          'SPEAKENG',
          'HCOVANY',
          'HCOVPRIV',
          'HINSEMP',
          'HINSCAID',
          'HINSCARE',
          'EDUC',
          'EMPSTAT',
          'LABFORCE',
          'WRKLSTWK',
          'ABSENT',
          'LOOKING',
          'AVAILBLE',
          'WRKRECAL',
          'WORKEDYR')

acs[cols] <- lapply(acs[cols], factor)  ## as.factor() could also be used

x <- syn(data = acs,  method = "cart")


result <- x$syn

sm_acs_fcs_cart <- result
save(sm_acs_fcs_cart, file = "results/sm_acs_fcs_cart.rda")


###### Data for exaluation
synthetic_dataset <- result

# for using synthpop
x <- x

######
# Evaluate Provacy
#####
library(synthpop)

replicated.uniques(object = x, data = sat)

######
# Evaluate UTILITY
#####

library(synthpop)

summary(synthetic_dataset)
summary(sat)

diff <- (synthetic_dataset$sat_v + synthetic_dataset$sat_m) - synthetic_dataset$sat_sum
print(sum(diff))

utility.gen(object = as.data.frame(synthetic_dataset), data = as.data.frame(sat))

utility.tables(object = as.data.frame(synthetic_dataset), data = as.data.frame(sat))


multi.compare(object = x, data = as.data.frame(sat), var = "sat_v", by = "sex")

multi.compare(object = x, data = as.data.frame(sat), var = "hs_gpa", by = "sex")


multi.compare(object = x, data = as.data.frame(sat), var = "sat_m", by="sex", cont.type = "boxplot")