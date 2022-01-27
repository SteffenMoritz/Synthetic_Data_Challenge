library("sdcMicro")
# https://sdctools.github.io/sdcMicro/articles/sdcMicro.html#risk_utility


original <- as.data.frame(sat)
synthetic <- as.data.frame(result)

original$sex <- as.factor(original$sex)
original$sat_v <- as.numeric(original$sat_v)
original$sat_m <- as.numeric(original$sat_m)
original$sat_sum <- as.numeric(original$sat_sum)

synthetic$sex <- as.factor(synthetic$sex)
synthetic$sat_v <- as.numeric(synthetic$sat_v)
synthetic$sat_m <- as.numeric(synthetic$sat_m)
synthetic$sat_sum <- as.numeric(synthetic$sat_sum)

sdcMicro::measure_risk()

#
# RISK
#

######k-ANONYMITY
# Es wird ermittelt, wie oft es für die Var Kombi k violations gibt
sdcMicro::freqCalc(original, keyVars = c('sex','sat_v'))
# das gleiche nicht als print ausgabe
qq <- sdcMicro::freqCalc(original, keyVars = c('sex','sat_v'))
qq$n1
qq$n2

ii <- sdcMicro::indivRisk(qq)

## keine metrik - tranformation um k-anon zu erreichen
xx <- sdcMicro::kAnon(original, keyVars = c('sex','sat_v'))
xx$anonymity

sdc <- createSdcObj(original,
                    keyVars=c('sex'),
                    numVars=c('sat_v','sat_m','sat_sum', 'hs_gpa','fy_gpa'))

yy <- sdcMicro::dRisk(obj = sdc)

qq <- sdcMicro::freqCalc(original, keyVars = c('sex','sat_v'))

addNoise(obj = yy, variables = c('sat_v','sat_m','sat_sum', 'hs_gpa','fy_gpa'))

# Additional Information-Loss measures
# (only numeric values)

sdcMicro::IL_variables(x = original, xm = synthetic)


#library("sdcMicro")
#data(testdata)
#sdc <- createSdcObj(testdata,
#                    keyVars=c('urbrur','roof','walls','water','electcon','relat','sex'),
#                    numVars=c('expend','income','savings'), w='sampling_weight')


#sdc <- addNoise(sdc, noise=0.2)

#sdc <- dRisk(sdc)


