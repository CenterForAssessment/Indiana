###################################################################
### Indiana sgpFlow analysis for 2024
###################################################################

### Load packages
require(data.table)
require(SGP)
require(sgpFlow)
require(sgpFlowMatrices)

### Load data
load("Data/Indiana_Data_LONG_2024.Rdata")

# Use super-cohort matrices
projection.splineMatrices <- sgpFlowMatrices[['IN_sgpFlowMatrices']][['2024']][['SUPER_COHORT']]

# Create configurations for both MATHEMATICS and ELA
sgpFlow.config <- list(
    MATHEMATICS_GRADE_3 = list(
        grade.progression="3",
        grade.projection.sequence=c("4", "5", "6", "7", "8"),
        content_area.progression="MATHEMATICS",
        content_area.projection.sequence=c("MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS", "MATHEMATICS"),
        year_lags.progression=as.integer(NULL),
        year_lags.projection.sequence=c(1L, 1L, 1L, 1L, 1L),
        max.order.for.progression=2L,
#        growth.distributions=list("UNIFORM_RANDOM", "50", "BETA", "FREE_REDUCED_LUNCH_STATUS")),
        growth.distributions=list("UNIFORM_RANDOM", "50")),
    ELA_GRADE_3 = list(
        grade.progression="3",
        grade.projection.sequence=c("4", "5", "6", "7", "8"),
        content_area.progression="ELA",
        content_area.projection.sequence=c("ELA", "ELA", "ELA", "ELA", "ELA"),
        year_lags.progression=as.integer(NULL),
        year_lags.projection.sequence=c(1L, 1L, 1L, 1L, 1L),
        max.order.for.progression=2L,
#        growth.distributions=list("UNIFORM_RANDOM", "50", "BETA", "FREE_REDUCED_LUNCH_STATUS")),
        growth.distributions=list("UNIFORM_RANDOM", "50"))
)

Indiana_sgpFlow <- sgpFlow(
                    sgp_object = Indiana_Data_LONG_2024,
                    sgpFlow.config = sgpFlow.config,
                    projection.splineMatrices = projection.splineMatrices,
                    parallel.config = NULL)

