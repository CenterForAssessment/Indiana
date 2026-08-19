###########################################################################################
###
### Script for creating Indiana LONG data set for 2026
###
###########################################################################################

### Load SGP Package:
require(data.table)


### Load base data files
Indiana_Data_LONG_2026 <- fread("Data/Base_Files/ILEARN_2026_Damian_Export_081926.csv", colClasses=rep("character", 5))
Indiana_Demographics_2026 <- fread("Data/Base_Files/ILEARN_2026_demographics.csv", colClasses=rep("character", 7))


### Prepare Data
setnames(Indiana_Data_LONG_2026, c("STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE_SCORE", "MATH_SCALE_SCORE"))
Indiana_Data_LONG_2026[,"STN":=NULL]
Indiana_Data_LONG_2026 <- rbindlist(list(Indiana_Data_LONG_2026[,c(1:3), with=FALSE], Indiana_Data_LONG_2026[,c(1:2,4), with=FALSE]), use.names=FALSE)
setnames(Indiana_Data_LONG_2026, "ELA_SCALE_SCORE", "SCALE_SCORE")

Indiana_Data_LONG_2026[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2026)[1]/2)]
Indiana_Data_LONG_2026[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2026[,SCHOOL_YEAR:="2026"]
Indiana_Data_LONG_2026[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
Indiana_Data_LONG_2026[,GRADE_ID:=as.character(as.numeric(GRADE_ID))]

### Prepare Indiana_Demographics_2026
setnames(Indiana_Demographics_2026, c("STUDENT_ID", "GRADE_ID", "ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS", "GENDER"))
Indiana_Demographics_2026[,"GRADE_ID":=NULL]
Indiana_Demographics_2026[,SCHOOL_YEAR:="2026"][,VALID_CASE:="VALID_CASE"]
setkey(Indiana_Demographics_2026, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)

### Merge in demographics
Indiana_Data_LONG_2026 <- Indiana_Demographics_2026[Indiana_Data_LONG_2026]
Indiana_Data_LONG_2026[,ETHNICITY:=as.factor(ETHNICITY)]

### Tidy up column order
setcolorder(Indiana_Data_LONG_2026, c(8, 11, 7, 9, 1, 10, 2, 3, 4, 5, 6))

### Take highest score for duplicates
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)
Indiana_Data_LONG_2026[which(duplicated(Indiana_Data_LONG_2026, by=key(Indiana_Data_LONG_2026)))-1, VALID_CASE:="INVALID_CASE"]

### Setkey final time
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)

### Save results
save(Indiana_Data_LONG_2026, file="Data/Indiana_Data_LONG_2026.Rdata")
