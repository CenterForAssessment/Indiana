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
Indiana_Data_LONG <- rbindlist(list(Indiana_SGP_LONG_Data[SCHOOL_YEAR<"2026"], Indiana_Data_LONG_2026), use.names=TRUE, fill=TRUE)
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
        steps = c("prepareSGP", "analyzeSGP", "combineSGP"),
        sgp.config = IN_CONFIG,
        sgp.percentiles = FALSE,
        sgp.projections = FALSE,
        sgp.projections.lagged = FALSE,
        sgp.percentiles.baseline = TRUE,
        sgp.projections.baseline = TRUE,
        sgp.projections.lagged.baseline = TRUE,
	sgp.target.scale.scores = TRUE,
        save.intermediate.results = FALSE,
        outputSGP.output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"),
        parallel.config = parallel.config
)

### Add in converted scaled score targets (OLD_SCALE in @SGP get converted to NEW_SCALE)
load("Data/Linkages_2026/Linkages_2026.Rdata")
tmp.data <- copy(Indiana_SGP@Data)

### Transform the first year baseline referenced targets from OLD_SCALE to NEW_SCALE
### YEAR_1 targets sit on the next grade; ILEARN ends at 8 so grade 8 has no GRADE_9 concordance
for (content_area.iter in c("ELA", "MATHEMATICS")) {
    for (grade.iter in 3:7) {
        link_fn <- Linkages_2026[[paste(content_area.iter, "2026", sep=".")]][[paste("GRADE", grade.iter+1, sep="_")]][["EQUIPERCENTILE"]][["OLD_TO_NEW"]][["interpolated_function"]]
        tmp.data[VALID_CASE == "VALID_CASE" & YEAR == "2026" & CONTENT_AREA == content_area.iter & GRADE == as.character(grade.iter), SCALE_SCORE_SGP_TARGET_BASELINE_4_YEAR_PROJ_YEAR_1_CURRENT_NEW_SCALE:=link_fn(ceiling(SCALE_SCORE_SGP_TARGET_BASELINE_4_YEAR_PROJ_YEAR_1_CURRENT))]
        tmp.data[VALID_CASE == "VALID_CASE" & YEAR == "2026" & CONTENT_AREA == content_area.iter & GRADE == as.character(grade.iter), SCALE_SCORE_SGP_TARGET_BASELINE_3_YEAR_PROJ_YEAR_1_CURRENT_NEW_SCALE:=link_fn(ceiling(SCALE_SCORE_SGP_TARGET_BASELINE_3_YEAR_PROJ_YEAR_1_CURRENT))]
    }
}

setkey(tmp.data, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
Indiana_SGP@Data <- tmp.data

### outputSGP results to LONG_Data and LONG_FINAL_YEAR_Data
outputSGP(Indiana_SGP, output.type = c("LONG_Data", "LONG_FINAL_YEAR_Data"))

###   Save results
save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")