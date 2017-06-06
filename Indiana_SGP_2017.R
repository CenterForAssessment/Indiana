####################################################################
###
### Code to update SGP analyses for Indiana for 2017
###
####################################################################

### Load SGP Package

require(SGP)


### Load data

load("Data/Indiana_Data_LONG_2017.Rdata")
load("Data/Indiana_SGP.Rdata")


### updateSGP

Indiana_SGP <- updateSGP(
			Indiana_SGP,
			Indiana_Data_LONG_2017,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			save.intermediate.results=FALSE,
			sgp.target.scale.scores=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2, SUMMARY=2, GA_PLOTS=2, SG_PLOTS=1)))


### Save results

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
