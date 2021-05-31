################################################################################
###                                                                          ###
###       SGPstateData grade specific (skip-year) projection sequences       ###
###                                                                          ###
################################################################################

###  Only want 1 year projections for 2021 "Fair Trend" metric
SGPstateData[["IN"]][["SGP_Configuration"]][['sgp.projections.max.forward.progression.years']] <- 1
SGPstateData[["IN"]][['SGP_Configuration']][['max.sgp.target.years.forward']] <- 1

###   Set Skip_Year_Projections to TRUE (non-NULL) to allow for skip year
SGPstateData[["IN"]][["SGP_Configuration"]][["Skip_Year_Projections"]] <- TRUE

###   Establish required meta-data for STRAIGHT projection sequences
SGPstateData[["IN"]][["SGP_Configuration"]][["grade.projection.sequence"]] <- list(
    ELA_GRADE_3 = c(3, 5),
    ELA_GRADE_4 = c(3, 4, 6),
    ELA_GRADE_5 = c(3, 4, 5, 7),
    ELA_GRADE_6 = c(3, 4, 5, 6, 8),
    MATHEMATICS_GRADE_3 = c(3, 5),
    MATHEMATICS_GRADE_4 = c(3, 4, 6),
    MATHEMATICS_GRADE_5 = c(3, 4, 5, 7),
    MATHEMATICS_GRADE_6 = c(3, 4, 5, 6, 8))
SGPstateData[["IN"]][["SGP_Configuration"]][["content_area.projection.sequence"]] <- list(
    ELA_GRADE_3 = rep("ELA", 2),
    ELA_GRADE_4 = rep("ELA", 3),
    ELA_GRADE_5 = rep("ELA", 4),
    ELA_GRADE_6 = rep("ELA", 5),
    MATHEMATICS_GRADE_3 = rep("MATHEMATICS", 2),
    MATHEMATICS_GRADE_4 = rep("MATHEMATICS", 3),
    MATHEMATICS_GRADE_5 = rep("MATHEMATICS", 4),
    MATHEMATICS_GRADE_6 = rep("MATHEMATICS", 5))
SGPstateData[["IN"]][["SGP_Configuration"]][["max.forward.projection.sequence"]] <- list(
    ELA_GRADE_3 = 1,
    ELA_GRADE_4 = 1,
    ELA_GRADE_5 = 1,
    ELA_GRADE_6 = 1,
    MATHEMATICS_GRADE_3 = 1,
    MATHEMATICS_GRADE_4 = 1,
    MATHEMATICS_GRADE_5 = 1,
    MATHEMATICS_GRADE_6 = 1)
