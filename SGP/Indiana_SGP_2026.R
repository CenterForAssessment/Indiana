################################################################################
###                                                                          ###
###                Indiana SGP analyses for 2026                             ###
###                NOTE: Archived old SGP object                             ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(data.table)
require(SGPmatrices)

###   Load data
load("Data/Indiana_SGP_LONG_Data.Rdata")
load("Data/Indiana_Data_LONG_2026.Rdata")

###   Create new LONG data from > 2022
Indiana_Data_LONG <- rbindlist(list(Indiana_SGP_LONG_Data, Indiana_Data_LONG_2026), use.names=TRUE, fill=TRUE)
setkey(Indiana_Data_LONG, VALID_CASE, CONTENT_AREA, SCHOOL_YEAR, GRADE_ID, STUDENT_ID)

###   Add Baseline matrices to SGPstateData
SGPstateData <- addBaselineMatrices("IN", "2026")
SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL

###   Read in SGP Configuration Scripts and Combine
source("SGP_CONFIG/2026/ELA.R")
source("SGP_CONFIG/2026/MATHEMATICS.R")

IN_CONFIG <- c(ELA_2026.config, MATHEMATICS_2026.config)

### Parameters
parallel.config <- list(BACKEND="PARALLEL", WORKERS=list(PERCENTILES=4, BASELINE_PERCENTILES=4, PROJECTIONS=4, LAGGED_PROJECTIONS=4, SGP_SCALE_SCORE_TARGETS=4))

#####
###   STEP 1: Run abcSGP analysis, cohort referenced SGPs only
#####

Indiana_SGP <- abcSGP(
        sgp_object = Indiana_Data_LONG,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = IN_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = FALSE, ## Scale change in 2026
        sgp.projections.lagged = FALSE, ## Scale change in 2026
        sgp.percentiles.baseline = FALSE, ## Taken care of in next step
        sgp.projections.baseline = FALSE, ## Taken care of in next step
        sgp.projections.lagged.baseline = FALSE, ## Taken care of in next step
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

#####
###   STEP 2: Run abcSGP analysis, baseline referenced SGPs
#####
Indiana_SGP@Data[YEAR<"2026", SCALE_SCORE_OLD_SCALE:=SCALE_SCORE]
setnames(Indiana_SGP@Data, c("SCALE_SCORE", "SCALE_SCORE_OLD_SCALE"), c("SCALE_SCORE_OLD_SCALE", "SCALE_SCORE"))
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2026"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2026"]] <- NULL

Indiana_SGP <- abcSGP(
        sgp_object = Indiana_SGP,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = IN_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
	sgp.target.scale.scores = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
#save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
