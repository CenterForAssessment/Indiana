###################################################################
### Indiana Data LONG 2024 for sgpFlow
###################################################################

### Load packages
require(data.table)
require(SGP)

### Utility functions
getDecile <- function(x) {
    return(ceiling(10 * frank(x, ties.method = "average") / length(x)))
}

### Load data
if (!exists("Indiana_SGP")) {   
    load("../SGP/Data/Indiana_SGP.Rdata")
}

if (!exists("SBAC_csem_data")) {
    load("Data/Base_Files/SBAC_csem_data.Rdata")
}

### Create long data
variables.to.keep <- c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL")
Indiana_Data_LONG_2024 <- Indiana_SGP@Data[VALID_CASE=="VALID_CASE" & YEAR %in% c("2021", "2022", "2023", "2024"), variables.to.keep, with=FALSE]

### Add in CSEM data
Indiana_Data_LONG_2024[,SCALE_SCORE_DECILE:=getDecile(SCALE_SCORE), keyby=c("YEAR", "CONTENT_AREA", "GRADE")]
Indiana_Data_LONG_2024 <- SBAC_csem_data[Indiana_Data_LONG_2024, on=key(SBAC_csem_data)]
Indiana_Data_LONG_2024[,SCALE_SCORE_DECILE:=NULL]

### Tidy up data
setcolorder(Indiana_Data_LONG_2024, c("VALID_CASE", "CONTENT_AREA", "YEAR", "GRADE", "ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "SCALE_SCORE_CSEM"))

### set the key
setkey(Indiana_Data_LONG_2024, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)

### Save data
save(Indiana_Data_LONG_2024, file="Data/Indiana_Data_LONG_2024.Rdata")
