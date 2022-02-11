
# Terminal commands to run algortihm
# python3 schemagen.py satgpa.csv --max_categorical 40
# python3 transform.py --transform discretize --df satgpa.csv --schema parameters.json --output_dir .
# python3 adaptive_grid.py --dataset discretized.csv --domain domain.json --save sat-synthetic.csv
# python3 transform.py --transform undo_discretize --df sat-synthetic.csv --schema parameters.json --output_dir .


 library(readr)
 raw_synthetic <- read_csv("minuteman_sat/raw_synthetic.csv", 
                                 col_types = cols(sex = col_integer(), 
                                                            sat_v = col_integer(), sat_m = col_integer(), 
                                                            sat_sum = col_integer(), hs_gpa = col_number(), 
                                                            fy_gpa = col_number()))

 
 sm_sat_minuteman <- raw_synthetic
 save(sm_sat_minuteman, file = "results/sm_sat_minuteman.rda")
 
 
 #ACS
#  python3 schemagen.py acs.csv --max_categorical 40
#  python3 transform.py --transform discretize --df acs.csv --schema parameters.json --output_dir .
#  python3 adaptive_grid.py --dataset discretized.csv --domain domain.json --save acs-synthetic.csv
#  python3 transform.py --transform undo_discretize --df acs-synthetic.csv --schema parameters.json --output_dir .

 library(readr)
 raw_syntheticACS <- read_csv("minuteman_acs/raw_synthetic.csv", 
                           col_types = cols(YEAR = col_integer(), 
                                            HHWT = col_number(), GQ = col_integer(), 
                                            PERWT = col_number(), SEX = col_integer(), 
                                            AGE = col_integer(), MARST = col_integer(), 
                                            RACE = col_integer(), HISPAN = col_integer(), 
                                            CITIZEN = col_integer(), SPEAKENG = col_integer(), 
                                            HCOVANY = col_integer(), HCOVPRIV = col_integer(), 
                                            HINSEMP = col_integer(), HINSCAID = col_integer(), 
                                            HINSCARE = col_integer(), EDUC = col_integer(), 
                                            EMPSTAT = col_integer(), EMPSTATD = col_integer(), 
                                            LABFORCE = col_integer(), WRKLSTWK = col_integer(), 
                                            ABSENT = col_integer(), LOOKING = col_integer(), 
                                            AVAILBLE = col_integer(), WRKRECAL = col_integer(), 
                                            WORKEDYR = col_integer(), INCTOT = col_integer(), 
                                            INCWAGE = col_integer(), INCWELFR = col_integer(), 
                                            INCINVST = col_integer(), INCEARN = col_integer(), 
                                            POVERTY = col_integer(), DEPARTS = col_integer(), 
                                            ARRIVES = col_integer(), sim_individual_id = col_integer()))
 
 sm_acs_minuteman <- raw_syntheticACS
 save(sm_acs_minuteman, file = "results/sm_acs_minuteman.rda")