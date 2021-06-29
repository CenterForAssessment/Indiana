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
Indiana_Demographics_2019 <- fread("Data/Base_Files/ILEARN_2019_demographics.csv", colClasses=rep("character", 5))


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

### Prepare Indiana_Demographics_2021

setnames(Indiana_Demographics_2021, c("STUDENT_ID", "ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS"))
Indiana_Demographics_2021[,SCHOOL_YEAR:="2021"][,VALID_CASE:="VALID_CASE"]
setkey(Indiana_Demographics_2021, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)
setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)

### Merge in demographics

Indiana_Data_LONG_2021 <- Indiana_Demographics_2021[Indiana_Data_LONG_2021]

#setcolorder(Indiana_Data_LONG_2021, c(6,12,7,10,1,11,8,9,2,3,4,5))

### Take highest score for duplicates

setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)
Indiana_Data_LONG_2021[which(duplicated(Indiana_Data_LONG_2021, by=key(Indiana_Data_LONG_2021)))-1, VALID_CASE:="INVALID_CASE"]

setkey(Indiana_Data_LONG_2021, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)

### Save results

save(Indiana_Data_LONG_2021, file="Data/Indiana_Data_LONG_2021.Rdata")

################################################################################
### Merge in 2019 demographics into Indiana_SGP object (ONE TIME OPERATION)
################################################################################

### Load 2019 Demographic data

#Indiana_Demographics_2019 <- fread("Data/Base_Files/ILEARN_2019_demographics.csv", colClasses=rep("character", 5))

### Prepare Indiana_Demographics_2019

#setnames(Indiana_Demographics_2019, c("ID", "ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS"))
#Indiana_Demographics_2019[,YEAR:="2019"][,VALID_CASE:="VALID_CASE"]
#setkey(Indiana_Demographics_2019, VALID_CASE, YEAR, ID)

#load("Data/Base_Files/Indiana_SGP.Rdata")

#tmp.2019 <- copy(Indiana_SGP@Data[YEAR=="2019"])
#tmp.other.years <- copy(Indiana_SGP@Data[YEAR!="2019"])
#tmp.2019[,c("ETHNICITY", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS"):=NULL]

#setkey(tmp.2019, VALID_CASE, YEAR, ID)

#tmp.2019 <- Indiana_Demographics_2019[tmp.2019]

#tmp.all <- rbindlist(list(tmp.all, tmp.2019), use.names=TRUE)
#Indiana_SGP@Data <- tmp.all
#setkey(Indiana_SGP, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)
