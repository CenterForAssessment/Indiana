####################################################################
###
### Code to update SGP analyses for Indiana for 2014
###
####################################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/Indiana_Data_LONG_2014.Rdata")
load("Data/Indiana_SGP.Rdata")


### updateSGP

Indiana_SGP <- updateSGP(
			Indiana_SGP, 
			Indiana_Data_LONG_2014, 
			save.intermediate.results=TRUE,
			sgp.target.scale.scores=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=10, BASELINE_PERCENTILES=10, PROJECTIONS=10, LAGGED_PROJECTIONS=10, SGP_SCALE_SCORE_TARGETS=10, SUMMARY=10, GA_PLOTS=4, SG_PLOTS=1)))


### Save results

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
