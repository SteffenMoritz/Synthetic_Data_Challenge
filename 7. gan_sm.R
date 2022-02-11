
# Load dataset
# setwd must be at project folder for load/save
load("satgpa.rda")
sat <- as.data.frame(satgpa)
#sat$sat_v <- as.num
##sat$sat_m
#sat$sex

# Generate generative data for the iris dataset
# Load and install library tensorflow
library(tensorflow)
#install_tensorflow()

# Load library
library(ganGenerativeData)

# 1. Definition of data source for the iris dataset
# Create a data source with built in  data frame.
dsCreateWithDataFrame(dataFrame = sat)

# Deactivate the column with index 5 in order to exclude it in generation of generative data.
dsDeactivateColumns(c(1:4))

# Get the active column names
dsGetActiveColumnNames()

# Write the data source including settings of active columns to file  in binary format.
dsWrite("sat.bin")


# 2. Generation of generative data for the sat data source

# Read data source from file "sat.bin",
# generate generative data in iterative training steps and
# write generated generative data to file "gd.bin".
gdGenerate("sat.bin", "gd.bin", 1, 0.95, c(1, 2))

# Read generative data from file "gd.bin", calculate density values and
# write generative data with density values to original file.
gdCalculateDensityValues("gd.bin")
# Read generative data from file "gd.bin" and data source from "iris4d.bin"
gdRead("gd.bin", "sat.bin")


# Get number of rows in generative data
gdGetNumberOfRows()

# Get row with index 1000 in generative data
gdGetRow(2)

# Calculate density value for a data record
gdCalculateDensityValue(list(6.1, 2.6, 5.6, 1.4))

# Calculate density value quantile for 50 percent
gdCalculateDensityValueQuantile(50)