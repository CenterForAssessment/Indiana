###########################################################################################
###
### Script for creating Indiana LONG data set for 2018
###
###########################################################################################

### Load SGP Package:

require(data.table)


### Load base data files

#Indiana_Data_LONG_2018 <- fread("Data/Base_Files/ISTEP_2018_Damian_Export_Initial_2018_20180709.csv", colClasses=rep("character", 7))
#Indiana_Data_LONG_2018 <- fread("Data/Base_Files/ISTEP_2018_Damian_Export_Final_2018_20180817.csv", colClasses=rep("character", 7))
Indiana_Data_LONG_2018 <- fread("Data/Base_Files/ISTEP_2018_Damian_Export_Final_2018_20180912.csv", colClasses=rep("character", 7))
INVALID_Students <- fread("Data/Base_Files/Pearson ISTEP Issue STN Student List for Damian 20181213.csv", colClasses=rep("character", 5))


### Prepare Data

setnames(Indiana_Data_LONG_2018, c("IDOE_CORPORATION_ID", "IDOE_SCHOOL_ID", "STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE", "MATH_SCALE"))
Indiana_Data_LONG_2018[,"STN":=NULL]
Indiana_Data_LONG_2018 <- rbindlist(list(Indiana_Data_LONG_2018[,c(1:5), with=FALSE], Indiana_Data_LONG_2018[,c(1:4,6), with=FALSE]))
setnames(Indiana_Data_LONG_2018, "ELA_SCALE", "SCALE_SCORE")

Indiana_Data_LONG_2018[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2018)[1]/2)]
Indiana_Data_LONG_2018[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2018[,SCHOOL_YEAR:="2018"]

Indiana_Data_LONG_2018[,GRADE_ID:=as.character(as.numeric(GRADE_ID))]
Indiana_Data_LONG_2018[SCALE_SCORE=="NULL", SCALE_SCORE:=NA]
Indiana_Data_LONG_2018[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

INVALID_Students[,c("STN", "V3", "V4", "V5"):=NULL]
INVALID_Students[,CONTENT_AREA:="ELA"]

### INVALIDATE cases with missing SCALE_SCORE

Indiana_Data_LONG_2018[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]


### Take highest score for duplicates

setkey(Indiana_Data_LONG_2018, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2018, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
Indiana_Data_LONG_2018[which(duplicated(Indiana_Data_LONG_2018, by=key(Indiana_Data_LONG_2018)))-1, VALID_CASE:="INVALID_CASE"]


### Invalid cases from Pearson file.

setkey(INVALID_Students, CONTENT_AREA, STUDENT_ID)
setkey(Indiana_Data_LONG_2018, CONTENT_AREA, STUDENT_ID)
Indiana_Data_LONG_2018[Indiana_Data_LONG_2018[INVALID_Students, which=TRUE], VALID_CASE:="INVALID_CASE"]

### Save results

save(Indiana_Data_LONG_2018, file="Data/Indiana_Data_LONG_2018.Rdata")
