# install.packages("reticulate")

load("satgpa.rda")

sat <- satgpa[1:30,]

install_miniconda()

library(reticulate)

# Falls nicht auf System vorhanden
# reticulate::install_python()
# reticulate::install_miniconda()



original <- as.data.frame(sat)
original$sex <- as.numeric(original$sex)
original$sat_v <- as.numeric(original$sat_v)
original$sat_m <- as.numeric(original$sat_m)
original$sat_sum <- as.numeric(original$sat_sum)

py_available(initialize = TRUE)

#use_python("/usr/local/bin/python")
Sys.which("python")
py_version()
use_virtualenv("synthchallenge")

virtualenv_install("synthchallenge", "numpy")


reticulate::repl_python("sdnist")


#### Python Code


import sdnist

>>> dataset, schema = sdnist.census()  # Retrieve public dataset
>>> dataset.head()
>>> synthetic_dataset = dataset.sample(n=20000)  # Build a fake synthetic dataset

# Compute the score of the synthetic dataset
>>> sdnist.score(dataset, synthetic_dataset, schema, challenge="census")  
