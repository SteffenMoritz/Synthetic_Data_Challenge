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
non_conf <- as.matrix(sat[,1:5])
conf <- as.matrix(sat[,5:6])

# y Matrix of confidential variables
# x Matrix of non-confidential variables
ipso <- RegSDC::RegSDCipso( y = conf , x = non_conf)

# Merge changed confidential variables and unchanged non-conf back together
result <- sat
result[ ,5:6] <- as.data.frame(ipso)

save(result, file = "results/sm_ipso_regsdc_hs_fy_no_corrections.rda")

