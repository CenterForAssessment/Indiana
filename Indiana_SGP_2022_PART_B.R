####################################################################
###
### Code to update SGP analyses for Indiana for 2022
###
####################################################################

### Load SGP Package
require(SGP)


### Load data
load("Data/Indiana_Data_LONG_2022.Rdata")
load("Data/Indiana_SGP.Rdata")


### updateSGP
Indiana_SGP <- updateSGP(
			Indiana_SGP,
			Indiana_Data_LONG_2022,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE,
			save.intermediate.results=FALSE,
			sgp.target.scale.scores=FALSE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(TAUS=22)))


### Save results
#save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
