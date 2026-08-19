################################################################################
###                                                                          ###
###                Indiana SGP analyses for 2026                             ###
###                                                                          ###
################################################################################

###   Load packages
require(SGP)
require(SGPmatrices)

###   Load data
load("Data/Indiana_SGP.Rdata")
load("Data/Indiana_Data_LONG_2026.Rdata")

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
###   Run updateSGP analysis
#####

Indiana_SGP <- updateSGP(
        what_sgp_object = Indiana_SGP,
        with_sgp_data_LONG = Indiana_Data_LONG_2026,
        steps = c("prepareSGP", "analyzeSGP", "combineSGP", "outputSGP"),
        sgp.config = IN_CONFIG,
        sgp.percentiles = TRUE,
        sgp.projections = TRUE,
        sgp.projections.lagged = TRUE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
        save.intermediate.results = FALSE,
        parallel.config = parallel.config
)

###   Save results
#save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")
