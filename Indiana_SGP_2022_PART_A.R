############################################################################################
###                                                                                      ###
###   Indiana Learning Loss Analyses -- 2019 Consecutive Baseline Growth Percentiles     ###
###   NOTE: Doing this in 2022 thus the file name                                        ###
###                                                                                      ###
############################################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

#####
###  STEP 1: Run BASELINE SGP analysis - create new Indiana_SGP object with historical data
#####

###   Load data and remove years that will not be used.
load("Data/Indiana_SGP_LONG_Data.Rdata")

### Remove YEARS > 2019 

Indiana_SGP_LONG_Data <- Indiana_SGP_LONG_Data[SCHOOL_YEAR <= "2019"]

### Test for BASELINE related variable in LONG data and NULL out if they exist
if (length(tmp.names <- grep("BASELINE|SS", names(Indiana_SGP_LONG_Data))) > 0) {
		Indiana_SGP_LONG_Data[,eval(tmp.names):=NULL]
}

###   Add single-cohort baseline matrices to SGPstateData
SGPstateData <- SGPmatrices::addBaselineMatrices("IN", "2022")

### NULL out assessment transition in 2019 (since already dealt with)
SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL
SGPstateData[["IN"]][["Assessment_Program_Information"]][["Scale_Change"]] <- NULL

###   Read in BASELINE percentiles configuration scripts and combine
source("SGP_CONFIG/2022/PART_A/ELA.R")
source("SGP_CONFIG/2022/PART_A/MATHEMATICS.R")

IN_2019_Consecutive_Baseline_Config <- c(
	ELA_2019.config,
	MATHEMATICS_2019.config
)

###   Run abcSGP

SGPstateData[["IN"]][["Assessment_Program_Information"]][["CSEM"]] <- NULL

TMP_IN_SGP <- abcSGP(
        sgp_object = Indiana_SGP_LONG_Data,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = IN_2019_Consecutive_Baseline_Config,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE, # Consecutive year SGPs for 2022 comparisons
        sgp.projections.baseline = FALSE,
        sgp.projections.lagged.baseline = FALSE,
        save.intermediate.results = FALSE,
        parallel.config = list(
				BACKEND = "PARALLEL",
				WORKERS=list(BASELINE_PERCENTILES=8))
)

#####
###  STEP 2: Take 2021 SGP object, rename skip-year baseline variables and merge in 
###           consecutive year baseline SGP variables
#####

load("Data/Indiana_SGP.Rdata")

tmp.2019 <- Indiana_SGP@Data[YEAR=="2019" & VALID_CASE=="VALID_CASE"]
tmp.2019.not.valid <- Indiana_SGP@Data[YEAR=="2019" & VALID_CASE=="INVALID_CASE"]
tmp.not.2019 <- Indiana_SGP@Data[YEAR!="2019"]

old.variable.names <- c("SGP_BASELINE", "SCALE_SCORE_PRIOR_BASELINE", 
                        "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE", 
                        "SGP_LEVEL_BASELINE", "SGP_NORM_GROUP_BASELINE", 
                        "SGP_NORM_GROUP_BASELINE_SCALE_SCORES", "SGP_TARGET_BASELINE_3_YEAR_CURRENT", 
                        "SGP_TARGET_BASELINE_4_YEAR_CURRENT", "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_3_YEAR_CURRENT", 
                        "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_4_YEAR_CURRENT", "SGP_TARGET_BASELINE_3_YEAR", 
                        "SGP_TARGET_BASELINE_4_YEAR", "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_3_YEAR", 
                        "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_4_YEAR", "CATCH_UP_KEEP_UP_STATUS_BASELINE_3_YEAR", 
                        "CATCH_UP_KEEP_UP_STATUS_BASELINE_4_YEAR", "MOVE_UP_STAY_UP_STATUS_BASELINE_3_YEAR", 
                        "MOVE_UP_STAY_UP_STATUS_BASELINE_4_YEAR", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR")

new.variable.names <- c("SGP_BASELINE_SKIP_YEAR", "SCALE_SCORE_PRIOR_BASELINE_SKIP_YEAR", 
                        "SCALE_SCORE_PRIOR_STANDARDIZED_BASELINE_SKIP_YEAR", "SGP_LEVEL_BASELINE_SKIP_YEAR", 
                        "SGP_NORM_GROUP_BASELINE_SKIP_YEAR", "SGP_NORM_GROUP_BASELINE_SCALE_SCORES_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_3_YEAR_CURRENT_SKIP_YEAR", "SGP_TARGET_BASELINE_4_YEAR_CURRENT_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_3_YEAR_CURRENT_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_4_YEAR_CURRENT_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_3_YEAR_SKIP_YEAR", "SGP_TARGET_BASELINE_4_YEAR_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_3_YEAR_SKIP_YEAR", "SGP_TARGET_BASELINE_MOVE_UP_STAY_UP_4_YEAR_SKIP_YEAR", 
                        "CATCH_UP_KEEP_UP_STATUS_BASELINE_3_YEAR_SKIP_YEAR", "CATCH_UP_KEEP_UP_STATUS_BASELINE_4_YEAR_SKIP_YEAR", 
                        "MOVE_UP_STAY_UP_STATUS_BASELINE_3_YEAR_SKIP_YEAR", "MOVE_UP_STAY_UP_STATUS_BASELINE_4_YEAR_SKIP_YEAR", 
                        "SGP_TARGET_BASELINE_RECOVERY_4_YEAR_SKIP_YEAR")

setnames(tmp.2019, old.variable.names, new.variable.names)

variables.to.merge <- intersect(grep("BASELINE", names(tmp.not.2019), value=TRUE), grep("BASELINE", names(TMP_IN_SGP@Data), value=TRUE))
consecutive.year.baseline.data <- TMP_IN_SGP@Data[YEAR=="2019",c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", variables.to.merge), with=FALSE]

setkey(tmp.2019, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
setkey(consecutive.year.baseline.data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

tmp.2019.new <- consecutive.year.baseline.data[tmp.2019]

tmp.all.new <- rbindlist(list(tmp.not.2019, tmp.2019.new, tmp.2019.not.valid), use.name=TRUE, fill=TRUE)
setkey(tmp.all.new, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

Indiana_SGP@Data <- tmp.all.new 
save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")




