################################################################################
###                                                                          ###
###       Indiana Learning Loss Analyses -- Create Baseline Matrices         ###
###                                                                          ###
################################################################################

### NOTE: SCALE_SCORE is SCALE_SCORE_EQUATED in this file going forward. SCALE_SCORE_ORIGINAL is the original/actual scale score report on ISTEP+

### Load necessary packages
require(SGP)

###   Load the results data from the 'official' 2019 SGP analyses
load("Data/Indiana_SGP_LONG_Data.Rdata")

###   Create a smaller subset of the LONG data to work with.
Indiana_Baseline_Data <- data.table::data.table(Indiana_SGP_LONG_Data[, c("VALID_CASE", "CONTENT_AREA", "SCHOOL_YEAR", "STUDENT_ID", "GRADE_ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL"),])

### Modify knots/boundaries in SGPstateData to use equated scale scores properly

SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2017"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2018"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2017"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2018"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2016"]] <- SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2019"]]
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2016"]] <- SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2019"]]
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["ELA.2019"]] <- NULL
SGPstateData[["IN"]][["Achievement"]][["Knots_Boundaries"]][["MATHEMATICS.2019"]] <- NULL

###   Read in Baseline SGP Configuration Scripts and Combine
source("SGP_CONFIG/2019/BASELINE/Matrices/ELA.R")
source("SGP_CONFIG/2019/BASELINE/Matrices/MATHEMATICS.R")

IN_BASELINE_CONFIG <- c(
	ELA_BASELINE.config,
	MATHEMATICS_BASELINE.config
)

###
###   Create Baseline Matrices

Indiana_SGP <- prepareSGP(Indiana_Baseline_Data, create.additional.variables=FALSE)

IN_Baseline_Matrices <- baselineSGP(
				Indiana_SGP,
				sgp.baseline.config=IN_BASELINE_CONFIG,
				return.matrices.only=TRUE,
				calculate.baseline.sgps=FALSE,
				goodness.of.fit.print=FALSE,
				parallel.config = list(
					BACKEND="PARALLEL", WORKERS=list(TAUS=7))
)

###   Save results
save(IN_Baseline_Matrices, file="Data/IN_Baseline_Matrices.Rdata")
