################################################################################
###
### Calculation and export script for academic impact for Indiana 2021
###
################################################################################

### Load packages
require(cfaTools)
require(SGP)
#debug(academicImpactSummary)

### Load data
load("Data/Indiana_SGP.Rdata")
load("Data/Indiana_SGP_Academic_Impact_Summaries_2021.Rdata")


### Create academic impact summaries
Indiana_SGP_Academic_Impact_Summaries_2021 <- list()
Indiana_SGP_Academic_Impact_Summaries_2021[['GRADE']] <- academicImpactSummary(Indiana_SGP, state='IN', current_year='2021', prior_year='2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="GRADE")[['GRADE']]
Indiana_SGP_Academic_Impact_Summaries_2021[['SCHOOL_NUMBER']] <- academicImpactSummary(Indiana_SGP, state='IN', current_year='2021', prior_year='2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="SCHOOL_NUMBER")[['SCHOOL_NUMBER']]
Indiana_SGP_Academic_Impact_Summaries_2021[['DISTRICT_NUMBER']] <- academicImpactSummary(Indiana_SGP, state='IN', current_year='2021', prior_year='2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="DISTRICT_NUMBER")[['DISTRICT_NUMBER']]
Indiana_SGP_Academic_Impact_Summaries_2021[['SCHOOL_NUMBER_by_GRADE']] <- academicImpactSummary(Indiana_SGP, state='IN', current_year='2021', prior_year='2019', content_areas=c('ELA', 'MATHEMATICS'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group=c("SCHOOL_NUMBER", "GRADE"))[['SCHOOL_NUMBER_by_GRADE']]
Indiana_SGP_Academic_Impact_Summaries_2021[['ETHNICITY']] <- academicImpactSummary(Indiana_SGP, state='IN', current_year='2021', prior_year='2019', content_areas=c('ELA', 'MATHEMATICS', years_for_aggregates='2021'), all_grades=as.character(c(3:8)), sgp_grades=as.character(5:8), aggregation_group="ETHNICITY")[['ETHNICITY']]


### Format and Save Output
save(Indiana_SGP_Academic_Impact_Summaries_2021, file="Data/Indiana_SGP_Academic_Impact_Summaries_2021.Rdata")
#variables.to.keep <- c("CONTENT_AREA", "YEAR", "SCHOOL_NUMBER", )
#tmp.school.data <- Indiana_SGP_Academic_Impact_Summaries_2021[['SCHOOL_NUMBER']][,variables.to.keep, with=FALSE]
#write.table(tmp.school.data, file="Data/Formatted_Output/Indiana_Academic_Output_Summaries_2021_SCHOOL.txt")
