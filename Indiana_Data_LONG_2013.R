###########################################################################################
###
### Script for creating Indiana LONG data set for 2013
###
###########################################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load base data files

ELA_Data <- read.delim("Data/Base_Files/GrowthModel_File_ELA.txt")
MATH_Data <- read.delim("Data/Base_Files/GrowthModel_File_MATH.txt")


### Prepare Data

ELA_Data[['CONTENT_AREA']] <- "ELA"
MATH_Data[['CONTENT_AREA']] <- "MATHEMATICS"
ELA_Data[['VALID_CASE']] <- MATH_Data[['VALID_CASE']] <- "VALID_CASE"
ELA_Data <- subset(ELA_Data, select=names(MATH_Data))
tmp_Data <- as.data.table(rbind(ELA_Data, MATH_Data))


### Tidy up data

tmp_Data[,SCHOOL_YEAR:=as.character(SCHOOL_YEAR)]

tmp_Data[,TEST_PERIOD_ID:=NULL]

tmp_Data$VALID_CASE[tmp_Data$ACHIEVEMENT_LEVEL=="Took Alternative Exam"] <- "INVALID_CASE"
tmp_Data[['ACHIEVEMENT_LEVEL']][tmp_Data$ACHIEVEMENT_LEVEL %in% c("", "Undetermined", "Took Alternative Exam")] <- NA
tmp_Data[,ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL, levels=c("Did Not Pass", "Pass", "Pass+"), ordered=TRUE)]
levels(tmp_Data$ACHIEVEMENT_LEVEL) <- c("Did Not Pass", "Pass", "Pass +")

levels(tmp_Data$SPECIAL_ED_STATUS) <- c("Special Education: No", "Special Education: Yes", "Unknown")
levels(tmp_Data$ENGLISH_LEARNER_STATUS) <- c("Limited English Proficient: Yes", "Limited English Proficient: No", "Unknown")
levels(tmp_Data$SOCIO_ECON_STATUS) <- c("Free/Reduced Price Lunch: Yes", "Free/Reduced Price Lunch: No", "Unknown")
tmp_Data$SCALE_SCORE <- as.numeric(tmp_Data$SCALE_SCORE)

### EMH Level

tmp_Data$EMH_LEVEL <- as.character(NA)
tmp_Data$EMH_LEVEL[tmp_Data$ELEMENTARY_SCHOOL_FLAG==1] <- "Elementary"
tmp_Data$EMH_LEVEL[tmp_Data$MIDDLE_SCHOOL_FLAG==1] <- "Middle"
tmp_Data$EMH_LEVEL[tmp_Data$HIGH_SCHOOL_FLAG==1] <- "High"
tmp_Data[,EMH_LEVEL := factor(EMH_LEVEL)]

tmp_Data[,ELEMENTARY_SCHOOL_FLAG:=NULL]
tmp_Data[,MIDDLE_SCHOOL_FLAG:=NULL]
tmp_Data[,HIGH_SCHOOL_FLAG:=NULL]


### Create SCHOOL_ENROLLMENT, DISTRICT_ENROLLMENT, and STATE_ENROLLMMENT STATUS variables

tmp_Data[,SCHOOL_ENROLLMENT_STATUS := "Enrolled School: Yes"]
tmp_Data[,DISTRICT_ENROLLMENT_STATUS := "Enrolled District: Yes"]
tmp_Data[,STATE_ENROLLMENT_STATUS := "Enrolled State: Yes"]


### Invalidate cases

tmp_Data[['VALID_CASE']][tmp_Data$STUDENT_ID < 0] <- "INVALID_CASE"

setkey(tmp_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(tmp_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
tmp_Data[which(duplicated(tmp_Data))-1, VALID_CASE := "INVALID_CASE"]


### Final cleanup

tmp_Data[,STUDENT_ID:=as.character(STUDENT_ID)]
tmp_Data[['GRADE_ID']] <- as.character(tmp_Data[['GRADE_ID']])
tmp_Data[['IDOE_SCHOOL_ID']] <- as.character(tmp_Data[['IDOE_SCHOOL_ID']])

Indiana_Data_LONG_2013 <- tmp_Data


### Order variable.names

variable.names <- c("VALID_CASE", "STUDENT_ID", "CONTENT_AREA", "SCHOOL_YEAR", "GRADE_ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "IDOE_CORPORATION_ID", "CORPORATION_NAME", 
	"IDOE_SCHOOL_ID", "SCHOOL_NAME", "EMH_LEVEL", "HIGH_ABILITY_STATUS_CATEGORY", "SPECIAL_ED_STATUS", "ENGLISH_LEARNER_STATUS", "SOCIO_ECON_STATUS",
	"SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
setcolorder(Indiana_Data_LONG_2013, variable.names)


### Save result

save(Indiana_Data_LONG_2013, file="Data/Indiana_Data_LONG_2013.Rdata")
