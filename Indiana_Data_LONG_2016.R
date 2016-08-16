###########################################################################################
###
### Script for creating Indiana LONG data set for 2016
###
###########################################################################################

### Load SGP Package

require(data.table)


### Load base data files

Indiana_Data_LONG_2016 <- fread("Data/Base_Files/ISTEP_2016_Damian_Export_Initial.csv", colClasses=rep("character", 9))


### Prepare Data

setnames(Indiana_Data_LONG_2016, c("IDOE_CORPORATION_ID", "IDOE_SCHOOL_ID", "STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE", "MATH_SCALE", "SCIENCE_SCALE", "SS_SCALE"))
Indiana_Data_LONG_2016[,c("STN", "SCIENCE_SCALE", "SS_SCALE"):=NULL]
Indiana_Data_LONG_2016 <- rbindlist(list(Indiana_Data_LONG_2016[,c(1:5), with=FALSE], Indiana_Data_LONG_2016[,c(1:4,6), with=FALSE]))
setnames(Indiana_Data_LONG_2016, "ELA_SCALE", "SCALE_SCORE")

Indiana_Data_LONG_2016[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2016)[1]/2)]
Indiana_Data_LONG_2016[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2016[,SCHOOL_YEAR:="2016"]

Indiana_Data_LONG_2016[,GRADE_ID:=as.character(as.numeric(GRADE_ID))]
Indiana_Data_LONG_2016[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]


### Take highest score for duplicates

setkey(Indiana_Data_LONG_2016, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2016, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
Indiana_Data_LONG_2016[which(duplicated(Indiana_Data_LONG_2016))-1, VALID_CASE := "INVALID_CASE"]

### Save results

#save(Indiana_Data_LONG_2016, file="Data/Indiana_Data_LONG_2016.Rdata")
