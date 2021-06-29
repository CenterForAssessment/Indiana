###########################################################################################
###
### Script for creating Indiana LONG data set for 2021
###
###########################################################################################

### Load SGP Package:

require(data.table)


### Load base data files

Indiana_Data_LONG_2021 <- fread("Data/Base_Files/ILEARN_2021_Damian_Export_20210625.csv", colClasses=rep("character", 7))
Indiana_Demographics_2021 <- fread("Data/Base_Files/ILEARN_2021_demographics.csv", colClasses=rep("character", 5))


### Prepare Data

setnames(Indiana_Data_LONG_2021, c("IDOE_CORPORATION_ID", "IDOE_SCHOOL_ID", "STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE", "MATH_SCALE"))
Indiana_Data_LONG_2021[,"STN":=NULL]
Indiana_Data_LONG_2021 <- rbindlist(list(Indiana_Data_LONG_2021[,c(1:5), with=FALSE], Indiana_Data_LONG_2021[,c(1:4,6), with=FALSE]), use.names=FALSE)
setnames(Indiana_Data_LONG_2021, "ELA_SCALE", "SCALE_SCORE")

Indiana_Data_LONG_2021[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2021)[1]/2)]
Indiana_Data_LONG_2021[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2021[,SCHOOL_YEAR:="2021"]
Indiana_Data_LONG_2021[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

### INVALIDATE cases with missing SCALE_SCORE

Indiana_Data_LONG_2021[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]

### Take highest score for duplicates

setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
Indiana_Data_LONG_2021[which(duplicated(Indiana_Data_LONG_2021, by=key(Indiana_Data_LONG_2021)))-1, VALID_CASE:="INVALID_CASE"]

### Prepare Indiana_Demographics_2021

setnames(Indiana_Demographics_2021, c("STUDENT_ID", "ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS"))
Indiana_Demographics_2021[,SCHOOL_YEAR:="2021"][,VALID_CASE:="VALID_CASE"]
setkey(Indiana_Demographics_2021, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)
setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)

Indiana_Data_LONG_2021 <- Indiana_Demographics_2021[Indiana_Data_LONG_2021]

setcolorder(Indiana_Data_LONG_2021, c(6,12,7,10,1,11,8,9,2,3,4,5))

### Save results

save(Indiana_Data_LONG_2021, file="Data/Indiana_Data_LONG_2021.Rdata")
