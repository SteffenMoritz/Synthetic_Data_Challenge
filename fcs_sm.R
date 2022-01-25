library(synthpop)

# Load dataset
# setwd must be at project folder for load/save
load("satgpa.rda")
sat <- satgpa

x <- syn(data = sat,  method = "cart")


result <- x$syn



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