###########################################################################################
###
### Script for creating Indiana LONG data set for 2022
###
###########################################################################################

### Load SGP Package:
require(data.table)


### Load base data files
Indiana_Data_LONG_2022 <- fread("Data/Base_Files/ILEARN_2022_Damian_Export_20220705.txt", colClasses=rep("character", 7))
Indiana_Demographics_2022 <- fread("Data/Base_Files/ILEARN_2022_demographics.txt", colClasses=rep("character", 6))


### Prepare Data
setnames(Indiana_Data_LONG_2022, c("IDOE_CORPORATION_ID", "IDOE_SCHOOL_ID", "STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE", "MATH_SCALE"))
Indiana_Data_LONG_2022[,"STN":=NULL]
Indiana_Data_LONG_2022 <- rbindlist(list(Indiana_Data_LONG_2022[,c(1:5), with=FALSE], Indiana_Data_LONG_2022[,c(1:4,6), with=FALSE]), use.names=FALSE)
setnames(Indiana_Data_LONG_2022, "ELA_SCALE", "SCALE_SCORE")

Indiana_Data_LONG_2022[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2022)[1]/2)]
Indiana_Data_LONG_2022[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2022[,SCHOOL_YEAR:="2022"]
Indiana_Data_LONG_2022[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

### INVALIDATE cases with missing SCALE_SCORE
Indiana_Data_LONG_2022[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]

### Prepare Indiana_Demographics_2022
setnames(Indiana_Demographics_2022, c("STUDENT_ID", "ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS", "GENDER"))
Indiana_Demographics_2022[,SCHOOL_YEAR:="2022"][,VALID_CASE:="VALID_CASE"]
setkey(Indiana_Demographics_2022, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)
setkey(Indiana_Data_LONG_2022, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)

### Merge in demographics
Indiana_Data_LONG_2022 <- Indiana_Demographics_2022[Indiana_Data_LONG_2022]

### Tidy up column order
setcolorder(Indiana_Data_LONG_2022, c(8, 13, 7, 11, 1, 12, 2, 3, 4, 5, 6, 9, 10))

### Take highest score for duplicates
setkey(Indiana_Data_LONG_2022, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2022, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)
Indiana_Data_LONG_2022[which(duplicated(Indiana_Data_LONG_2022, by=key(Indiana_Data_LONG_2022)))-1, VALID_CASE:="INVALID_CASE"]

### Setkey final time
setkey(Indiana_Data_LONG_2022, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)

### Save results
save(Indiana_Data_LONG_2022, file="Data/Indiana_Data_LONG_2022.Rdata")