####################################################################
###
### Code to update SGP analyses for Indiana for 2016 with
### RESCORE of GRADE 3 MATHEMATICS and change ACHIEVEMENT_LEVEL
###
####################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load data

load("Data/Indiana_Data_LONG_2016.Rdata")
load("Data/Indiana_SGP.Rdata")


### RESCORE GRADE 3 MATHEMATICS for 2015 and change ACHIEVEMENT_LEVEL

Indiana_SGP_LONG_Data_2015 <- Indiana_SGP@Data[YEAR=="2015" & GRADE=="3" & CONTENT_AREA=="MATHEMATICS"]
Indiana_SGP_LONG_Data_2015[ADMIN_MODE=="All Paper/Pencil", SCALE_SCORE:=SCALE_SCORE-4]
Indiana_SGP_LONG_Data_2015[ADMIN_MODE=="Half P/P - Half CBT", SCALE_SCORE:=SCALE_SCORE+4]
Indiana_SGP_LONG_Data_2015[,ACHIEVEMENT_LEVEL:=NULL]

tmp_SGP <- prepareSGP(Indiana_SGP_LONG_Data_2015)

slot.data <- rbindlist(list(Indiana_SGP@Data[YEAR!="2015"], tmp_SGP@Data), fill=TRUE)
setkey(slot.data, VALID_CASE, CONTENT_AREA, YEAR, ID)
Indiana_SGP@Data <- slot.data


### updateSGP

Indiana_SGP <- updateSGP(
			Indiana_SGP,
			Indiana_Data_LONG_2016,
			steps=c("prepareSGP", "analyzeSGP", "combineSGP"),
			sgp.percentiles=TRUE,
			sgp.projections=TRUE,
			sgp.projections.lagged=TRUE,
			sgp.percentiles.baseline=FALSE,
			sgp.projections.baseline=FALSE,
			sgp.projections.lagged.baseline=FALSE,
			save.intermediate.results=FALSE,
			sgp.target.scale.scores=TRUE,
			parallel.config=list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=2, PROJECTIONS=2, LAGGED_PROJECTIONS=2, SGP_SCALE_SCORE_TARGETS=2, SUMMARY=2, GA_PLOTS=2, SG_PLOTS=1)))


### outputSGP

outputSGP(Indiana_SGP, outputSGP.directory="Data/ALT_2016")

### Save results

save(Indiana_SGP, file="Data/ALT_2016/Indiana_SGP.Rdata")
