###########################################################################################
###
### Script for creating Indiana LONG data set for 2019
###
###########################################################################################

### Load SGP Package:

require(data.table)


### Load base data files

Indiana_Data_LONG_2019 <- fread("Data/Base_Files/ISTEP_2019_Damian_Export_20190910_with_ILEARN.csv", colClasses=rep("character", 7))


### Prepare Data

setnames(Indiana_Data_LONG_2019, c("IDOE_CORPORATION_ID", "IDOE_SCHOOL_ID", "STN", "STUDENT_ID", "GRADE_ID", "ELA_SCALE", "MATH_SCALE"))
Indiana_Data_LONG_2019[,"STN":=NULL]
Indiana_Data_LONG_2019 <- rbindlist(list(Indiana_Data_LONG_2019[,c(1:5), with=FALSE], Indiana_Data_LONG_2019[,c(1:4,6), with=FALSE]), use.names=FALSE)
setnames(Indiana_Data_LONG_2019, "ELA_SCALE", "SCALE_SCORE")

Indiana_Data_LONG_2019[,CONTENT_AREA:=rep(c("ELA", "MATHEMATICS"), each=dim(Indiana_Data_LONG_2019)[1]/2)]
Indiana_Data_LONG_2019[,VALID_CASE:="VALID_CASE"]
Indiana_Data_LONG_2019[,SCHOOL_YEAR:="2019"]
Indiana_Data_LONG_2019[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

### INVALIDATE cases with missing SCALE_SCORE

Indiana_Data_LONG_2019[is.na(SCALE_SCORE), VALID_CASE:="INVALID_CASE"]

### Take highest score for duplicates

setkey(Indiana_Data_LONG_2019, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2019, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
Indiana_Data_LONG_2019[which(duplicated(Indiana_Data_LONG_2019, by=key(Indiana_Data_LONG_2019)))-1, VALID_CASE:="INVALID_CASE"]


### Save results

save(Indiana_Data_LONG_2019, file="Data/Indiana_Data_LONG_2019.Rdata")
