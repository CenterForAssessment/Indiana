#########################################################################
###
### Script to create and update Indiana SGPs
###
#########################################################################

### Load SGP Package

require(SGP)


### Load Data

load("Data/Indiana_Data_LONG.Rdata")


#####################################################
###
### STEP 1: prepareSGP
###
#####################################################

Indiana_SGP <- prepareSGP(Indiana_Data_LONG)

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")


####################################################
###
### STEP 2: analyzeSGP
###
####################################################

# Part 1: Calculate cohort referenced SGPs and projections for just 2012

Indiana_SGP <- analyzeSGP(Indiana_SGP,
			years="2012",
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=30, PROJECTIONS=20, LAGGED_PROJECTIONS=20)))

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")


# Part 2: Calculate baseline referenced SGPs and projections for 2011 and 2012

Indiana_SGP <- analyzeSGP(Indiana_SGP,
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=TRUE,
			sgp.projections.baseline=TRUE,
			sgp.projections.lagged.baseline=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(BASELINE_PERCENTILES=30, PROJECTIONS=20, LAGGED_PROJECTIONS=20)))

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")


########################################################
###
### STEP 3: combineSGP 
### NOTE: Because we have 2011,2010, and 2009 SGPs, we need to do this a little different. 
### NOTE: This step will only require combineSGP command in future
###
########################################################

Indiana_SGP@Data$OLD_SGP <- Indiana_SGP@Data$SGP
Indiana_SGP@Data$SGP <- NULL

Indiana_SGP <- combineSGP(Indiana_SGP)

Indiana_SGP@Data$SGP[!is.na(Indiana_SGP@Data$OLD_SGP)] <- Indiana_SGP@Data$OLD_SGP[!is.na(Indiana_SGP@Data$OLD_SGP)]
Indiana_SGP@Data$OLD_SGP <- NULL

save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")


#######################################################
###
### STEP 4: summarizeSGP
###
#######################################################

Indiana_SGP <- summarizeSGP(Indiana_SGP, 
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(SUMMARY=30)))


save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")


#######################################################
###
### STEP 5: visualizeSGP
###
#######################################################

visualizeSGP(Indiana_SGP, sgPlot.demo.report=TRUE)


#######################################################
###
### STEP 6: outputSGP
###
#######################################################

outputSGP(Indiana_SGP)


