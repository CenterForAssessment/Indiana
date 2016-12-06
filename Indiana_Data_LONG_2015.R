###########################################################################################
###
### Script for creating Indiana LONG data set for 2015
###
###########################################################################################

### Load packages

require(data.table)

### Load base data files

fixed.widths <- c(1, 10, 30, 4, 30, 4, 30, 7, 2, 30, 2, 8, 5, 2, 6, 12, 9, 1, 1, 6, 3, 1, 1, 1, 1, 1, 1, 1, 2,
	              6, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15, 20, 1, 15, 1, 1, 1,
	              1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 40, 120,	10, 8, 8, 8, 8, 8, 9, 1, 26, 26, 26, 26, 8,
	              8, 1, 1, 2, 2, 1, 1, 2, 7, 1, 1, 1, 1, 80, 1, 1, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40,
	              40, 40, 40, 40, 40, 40, 40, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10,
	              10, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,
	              25, 25, 25,25, 25, 25, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20)

g3 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR3_111115.zip", "ISTEPS15_GRT_GR3_111115.DAT"), fixed.widths, colClasses = "character"))
g4 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR4-111115.zip", "ISTEPS15_GRT_GR4-111115.DAT"), fixed.widths, colClasses = "character"))
g5 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR5_111115.zip", "ISTEPS15_GRT_GR5_111115.DAT"), fixed.widths, colClasses = "character"))
g6 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR6_111115.zip", "ISTEPS15_GRT_GR6_111115.DAT"), fixed.widths, colClasses = "character"))
g7 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR7_111115.zip", "ISTEPS15_GRT_GR7_111115.DAT"), fixed.widths, colClasses = "character"))
g8 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_GR8_111115.zip", "ISTEPS15_GRT_GR8_111115.DAT"), fixed.widths, colClasses = "character"))

nonpub <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_GRT_NONPUB_111115.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))
pub.braille <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_PUBLIC_BRAILLE_GRT_111715.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))
nonpub.braille <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_NONPUB_BRAILLE_.GRT_111715.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))

tmp_Data <- rbindlist(list(g3, g4, g5, g6, g7, g8, nonpub, nonpub.braille, pub.braille))

####  Save the combined BASE FILE data
save(tmp_Data, file="Data/Base_Files/2015/ISTEPS15_Combined_Base_Files.Rdata")

###
###   Subset the ELA and MATH records to create LONG data -- Select only columns required for SGP/Summary/Visualizations
###

var.names.to.keep <- c("CORPORATION_NAME", "IDOE_CORPORATION_ID", "SCHOOL_NAME", "IDOE_SCHOOL_ID", "GRADE_ID", "CTB_STUDENT_TEST_NUMBER",
                       "GENDER", "ETHNICITY", "SPECIAL_ED_STATUS", "SOCIO_ECON_STATUS", "ENGLISH_LEARNER_STATUS")
var.names.to.help <- c("MATCH", "DUPLICATE")
setnames(tmp_Data, c(c(3:6, 9, 31, 19, 33:34, 36, 38), c(43:44)), c(var.names.to.keep, var.names.to.help))

#### ELA Data
ELA_Data <- tmp_Data[, c(var.names.to.keep, var.names.to.help, "V57", "V65", "V69"), with=FALSE]
setnames(ELA_Data, c("V57", "V65", "V69"), c("ACHIEVEMENT_LEVEL", "SCALE_SCORE", "SCALE_SCORE_CSEM"))
ELA_Data[, CONTENT_AREA := "ELA"]
ELA_Data[, SCHOOL_YEAR := "2015"]
ELA_Data[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
ELA_Data[, GRADE_ID := as.character(as.numeric(GRADE_ID))]

#### Math Data
MATH_Data <- tmp_Data[, c(var.names.to.keep, var.names.to.help, "V58", "V66", "V70"), with=FALSE]
setnames(MATH_Data, c("V58", "V66", "V70"), c("ACHIEVEMENT_LEVEL", "SCALE_SCORE", "SCALE_SCORE_CSEM"))
MATH_Data[, CONTENT_AREA := "MATHEMATICS"]
MATH_Data[, SCHOOL_YEAR := "2015"]
MATH_Data[, SCALE_SCORE := as.numeric(SCALE_SCORE)]
MATH_Data[, GRADE_ID := as.character(as.numeric(GRADE_ID))]

#### Combine Long Data
tmp_Long_Data <- rbindlist(list(ELA_Data[!is.na(SCALE_SCORE)], MATH_Data[!is.na(SCALE_SCORE)]))

####  Merge in Indiana ID based on CTB STN
IND_ID <- as.data.table(read.csv(unz("Data/Base_Files/2015/D_STUDENT_STN_TO_STUDENTID_MAP.csv.zip", "D_STUDENT_STN_TO_STUDENTID_MAP.csv"), stringsAsFactors=FALSE, header=FALSE))
setnames(IND_ID, c("STUDENT_ID", "CTB_STUDENT_TEST_NUMBER"))
setkey(IND_ID, CTB_STUDENT_TEST_NUMBER)

setkey(tmp_Long_Data, CTB_STUDENT_TEST_NUMBER)

tmp_Long_Data <- IND_ID[tmp_Long_Data]

###
###   Tidy up variables
###

####  Clean white space from fixed width format names
trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)

tmp_Long_Data[, CORPORATION_NAME := trimWhiteSpace(CORPORATION_NAME)]
tmp_Long_Data[, SCHOOL_NAME := trimWhiteSpace(SCHOOL_NAME)]

#### Achievement Level
tmp_Long_Data[which(ACHIEVEMENT_LEVEL==" "), ACHIEVEMENT_LEVEL := NA]
tmp_Long_Data[, ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL, levels = c("B", "A", "P", "U"), labels=c("Did Not Pass", "Pass", "Pass +", "Undetermined"), ordered=TRUE)]
tmp_Long_Data[, ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

####  Demographics
tmp_Long_Data[which(GENDER == " "), GENDER := NA]
tmp_Long_Data[which(GENDER == "M"), GENDER := "Male"]
tmp_Long_Data[which(GENDER == "F"), GENDER := "Female"]

tmp_Long_Data[which(ETHNICITY == " "), ETHNICITY := NA]
tmp_Long_Data[, ETHNICITY:=factor(ETHNICITY, levels = as.character(1:7),
					labels=c("American Indian/Alaska Native", "African American", "Asian", "Hispanic", "White", "Multiracial", "Pacific Islander"))]

tmp_Long_Data[which(SPECIAL_ED_STATUS %in% c(" ", "-")), SPECIAL_ED_STATUS := NA]
tmp_Long_Data[which(SPECIAL_ED_STATUS == 1), SPECIAL_ED_STATUS := "Special Education: No"]
tmp_Long_Data[which(SPECIAL_ED_STATUS == 0), SPECIAL_ED_STATUS := "Special Education: Yes"]

tmp_Long_Data[which(ENGLISH_LEARNER_STATUS %in% c(" ", "-")), ENGLISH_LEARNER_STATUS := NA]
tmp_Long_Data[which(ENGLISH_LEARNER_STATUS == 1), ENGLISH_LEARNER_STATUS := "Limited English Proficient: No"]
tmp_Long_Data[which(ENGLISH_LEARNER_STATUS == 0), ENGLISH_LEARNER_STATUS := "Limited English Proficient: Yes"]

tmp_Long_Data[which(SOCIO_ECON_STATUS %in% c(" ", "-")), SOCIO_ECON_STATUS := NA]
tmp_Long_Data[which(SOCIO_ECON_STATUS == 1), SOCIO_ECON_STATUS := "Free/Reduced Price Lunch: No"]
tmp_Long_Data[which(SOCIO_ECON_STATUS == 0), SOCIO_ECON_STATUS := "Free/Reduced Price Lunch: Yes"]

#### Create SCHOOL_ENROLLMENT, DISTRICT_ENROLLMENT, and STATE_ENROLLMMENT STATUS variables
tmp_Long_Data[,SCHOOL_ENROLLMENT_STATUS := "Enrolled School: Yes"]
tmp_Long_Data[,DISTRICT_ENROLLMENT_STATUS := "Enrolled District: Yes"]
tmp_Long_Data[,STATE_ENROLLMENT_STATUS := "Enrolled State: Yes"]

###
###   Invalidate cases
###

tmp_Long_Data[, VALID_CASE := "VALID_CASE"]

####  Invalidate students with missing ID
tmp_Long_Data[which(STUDENT_ID == "         "), STUDENT_ID := NA] # Fixed width == 9 spaces
tmp_Long_Data[is.na(STUDENT_ID), VALID_CASE := "INVALID_CASE"]

####  Find duplicates and take highest score
setkey(tmp_Long_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(tmp_Long_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)
tmp_Long_Data[which(duplicated(tmp_Long_Data, by=key(tmp_Long_Data)))-1, VALID_CASE := "INVALID_CASE"]

###
###   Final cleanup
###

#### Order variable.names
variables.to.keep <- c(
	"VALID_CASE", "STUDENT_ID", "CONTENT_AREA", "SCHOOL_YEAR", "GRADE_ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL",
	"IDOE_CORPORATION_ID", "CORPORATION_NAME", "IDOE_SCHOOL_ID", "SCHOOL_NAME",
	"GENDER", "ETHNICITY", "SPECIAL_ED_STATUS", "ENGLISH_LEARNER_STATUS", "SOCIO_ECON_STATUS",
	"SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS")

Indiana_Data_LONG_2015 <- tmp_Long_Data[, variables.to.keep, with = FALSE]

#############################################################
### ADD IN ADDITIONAL CASES FOUND IN 2015-2016
#############################################################

tmp.missing <- fread("Data/Base_Files/Evansville_2016_Audit_Growth_Issue.txt", colClasses=rep("character", 17))
setnames(tmp.missing, toupper(names(tmp.missing)))
tmp.missing.dt <- data.table(
				VALID_CASE="VALID_CASE",
				STUDENT_ID=rep(tmp.missing$STUDENT_ID, 2),
				CONTENT_AREA=rep(c("MATHEMATICS", "ELA"), each=dim(tmp.missing)[1]),
				SCHOOL_YEAR="2015",
				GRADE_ID=c(tmp.missing[[5]], tmp.missing[[13]]),
				SCALE_SCORE=as.numeric(c(tmp.missing[[6]], tmp.missing[[14]])),
				SCHOOL_ENROLLMENT_STATUS="Enrolled School: Yes",
				DISTRICT_ENROLLMENT_STATUS="Enrolled District: Yes",
				STATE_ENROLLMENT_STATUS="Enrolled State: Yes"
)

require(SGP)
tmp.missing.dt <- prepareSGP(tmp.missing.dt, state="IN")@Data
setnames(tmp.missing.dt, c("ID", "YEAR", "GRADE"), c("STUDENT_ID", "SCHOOL_YEAR", "GRADE_ID"))
Indiana_Data_LONG_2015 <- rbindlist(list(Indiana_Data_LONG_2015, tmp.missing.dt), fill=TRUE)
setkey(Indiana_Data_LONG_2015, VALID_CASE, CONTENT_AREA, SCHOOL_YEAR, STUDENT_ID)


#### Save 2015 longitudinal data
save(Indiana_Data_LONG_2015, file="Data/Indiana_Data_LONG_2015.Rdata")


###
###  CSEM Data
###

Indiana_CSEM <- tmp_Long_Data[, c("VALID_CASE", "CONTENT_AREA", "GRADE_ID", "SCALE_SCORE", "SCALE_SCORE_CSEM"), with = FALSE]
setkey(Indiana_CSEM)
Indiana_CSEM <- unique(Indiana_CSEM)[VALID_CASE=="VALID_CASE"]
sum.tbl <- Indiana_CSEM[,as.list(length(SCALE_SCORE_CSEM)), keyby=list(CONTENT_AREA, GRADE_ID, SCALE_SCORE)]
summary(sum.tbl$V1)
