# Information Perserving Statistical Obfuscation (IPSO) - First Try

# Required packages
library("RegSDC")

# Load dataset
# setwd must be at project folder for load/save
load("satgpa.rda")
sat <- satgpa

# Confidential variables
#    - hs_gpa High school grade point average.
#    - fy_gpa First year (college) grade point average.
#
# Reason to be kept secret:
# Very specific, might be known to outsiders and enable identification

# Non-confidental variables
#    - sex Gender of the student.
#    - sat_v Verbal SAT percentile.
#    - sat_m Math SAT percentile.
#    - sat_sum Total of verbal and math SAT percentiles.

#
# Advantages: sat_v + sat_m = sat_sum still valid, percentiles intact 
#

# Create Matrix of conf/non-conf
non_conf <- as.matrix(sat[,1:4])
conf <- as.matrix(sat[,5:6])

# y Matrix of confidential variables
# x Matrix of non-confidential variables
ipso <- RegSDC::RegSDCipso( y = conf , x = non_conf)

# Merge changed confidential variables and unchanged non-conf back together
result <- as.data.frame(non_conf)
result[ ,5:6] <- as.data.frame(ipso)

sm_ipso_regsdc_conf_hs_fy <- result
save(sm_ipso_regsdc_conf_hs_fy, file = "results/sm_ipso_regsdc_hs_fy_no_corrections.rda")



###### Data for exaluation
synthetic_dataset <- result

# for using synthpop
x <- list(m = 1, syn = synthetic_dataset )

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