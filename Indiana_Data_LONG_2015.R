###########################################################################################
###
### Script for creating Indiana LONG data set for 2015
###
###########################################################################################

### Load packages

require(SGP)
require(readr)
require(data.table)

setwd('/Users/avi/Dropbox/SGP/Indiana/')
### Load base data files

fixed.widths <- c(1, 10, 30, 4, 30, 4, 30, 7, 2, 30, 2, 8, 5, 2, 6, 12, 9, 1, 1, 6, 3, 1, 1, 1, 1, 1, 1, 1, 2, 
	              6, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15, 20, 1, 15, 1, 1, 1, 
	              1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 40, 120, 10, 8, 8, 8, 8, 8, 9, 1, 26, 26, 26, 26, 8,  
	              8, 1, 1, 2, 2, 1, 1, 2, 7, 1, 1, 1, 1, 80, 1, 1, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 
	              40, 40, 40, 40, 40, 40, 40, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 
	              10, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 
	              25, 25, 25,25, 25, 25, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20)

fixed.widths <- c(1, 10, 30, 4, 30, 4, 30, 7, 2, 30, 2, 8, 5, 2, 6, 12, 9, 1, 1, 6, 3, 1, 1, 1, 1, 
				  1, 1, 1, 2, 6, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
				  15, 20, 1, 15, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 40, 120, 10, 8, 8,
				  8, 8, 8, 9, 1, 26, 26, 26, 26, 8,8, 1, 1, 2, 2, 1, 1, 2, 7, 1, 1, 1, 1, 80, 1, 1,
				  40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 10, 10, 
				  10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 15, 15, 15, 15, 
				  15, 15, 15, 15, 15, 15, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25,
				  25, 25, 25, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20)

# g3 <- as.data.table(read.fwf("GRT.DAT", fixed.widths, colClasses = "character")) #, stringsAsFactors = FALSE

# g3.2 <- as.data.table(read_fwf("GRT.DAT", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))
# g3.3 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))

##  Tried and failed:
# g3 <- as.data.table(read.spss("GRT.DAT", to.data.frame=TRUE, trim.factor.names = TRUE))
# g3 <- fread("GRT.DAT", stringsAsFactors=FALSE)

# g3 <- fread(unz("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", "GRT.DAT"))
# g3 <- read.table(unz("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", "GRT.DAT"), stringsAsFactors=FALSE)
# g3 <- fread("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", stringsAsFactors=FALSE)

# g3 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", 
# 		fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))
# g4 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade4_110315.zip", 
# 		fwf_widths(fixed.widths), col_types = cols(X82 = "c", X34="c"), progress=TRUE))
# # g5.widths <- fixed.widths; g5.widths[8] <- 5
# g5 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade5_110315.zip", 
# 		fwf_widths(fixed.widths), col_types = NULL, progress=TRUE, na = c("", "-"))) #
# g6 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade6_110315.zip", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))
# g7 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade7_110315.zip", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))
# g8 <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Public_GRT_grade8_110315.zip", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))

# nonpub <- as.data.table(read_fwf("/Users/avi/Dropbox/SGP/Indiana/Data/Base_Files/2015/ISTEPS15_Nonpublic_GRT_110315.ZIP", fwf_widths(fixed.widths), col_types = cols(X82 = "c"), progress=TRUE))

g3 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade3_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")) #, stringsAsFactors = FALSE
system.time(g4 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade4_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")))
system.time(g5 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade5_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")))
system.time(g6 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade6_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")))
system.time(g7 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade7_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")))
system.time(g8 <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_GRT_grade8_110315.zip", "GRT.DAT"), fixed.widths, colClasses = "character")))
#g8o2 <-as.data.table(read.fwf("GRT.DAT 8", fixed.widths, colClasses = "character", fileEncoding = "UTF-8")) #, stringsAsFactors = FALSE
#system.time(g8o3 <-as.data.table(read.fwf("GRT.DAT 8", fixed.widths, colClasses = "character", fileEncoding = "UTF-8-BOM"))) #, stringsAsFactors = FALSE

nonpub <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Nonpublic_GRT_110315.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))
pub.braille <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Public_Braille_GRT_110315.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))
nonpub.braille <- as.data.table(read.fwf(unz("Data/Base_Files/2015/ISTEPS15_Nonpublic_Braille_GRT_110315.ZIP", "GRT.DAT"), fixed.widths, colClasses = "character"))

tmp_Data <- rbindlist(list(g3, g4, g5, g6, g7, g8, nonpub, nonpub.braille, pub.braille))

###  Save the combined BASE FILE data
save(tmp_Data, file="Data/Base_Files/2015/ISTEPS15_Combined_Base_Files.Rdata")


###  Subset the ELA and MATH records -- Select only columns required for SGP/Summary/Visualizations
var.names.to.keep <- c("CORPORATION_NAME", "IDOE_CORPORATION_ID", "SCHOOL_NAME", "IDOE_SCHOOL_ID", "GRADE_ID", "LAST_NAME", "FIRST_NAME", "STUDENT_ID",
	  				   "GENDER", "ETHNICITY", "SPECIAL_ED_STATUS", "SOCIO_ECON_STATUS", "ENGLISH_LEARNER_STATUS")
var.names.to.help <- c("MATCH", "DUPLICATE", "ACCOMMODATIONS_ELA", "ACCOMMODATIONS_MATH")
setnames(tmp_Data, c(c(3:6, 9, 16:17, 31, 19, 33:34, 36, 38), c(43:44, 49:50)), c(var.names.to.keep, var.names.to.help))

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


### Combine Long Data

tmp_Long_Data <- rbindlist(list(ELA_Data[!is.na(SCALE_SCORE)], MATH_Data[!is.na(SCALE_SCORE)]))


### Tidy up variables

####  Clean white space from fixed width format names
trimWhiteSpace <- function(line) gsub("(^ +)|( +$)", "", line)

tmp_Long_Data[, CORPORATION_NAME := trimWhiteSpace(CORPORATION_NAME)]
tmp_Long_Data[, SCHOOL_NAME := trimWhiteSpace(SCHOOL_NAME)]
tmp_Long_Data[, FIRST_NAME := trimWhiteSpace(FIRST_NAME)]
tmp_Long_Data[, LAST_NAME := trimWhiteSpace(LAST_NAME)]


#### Achievement Level
tmp_Long_Data[which(ACHIEVEMENT_LEVEL==" "), ACHIEVEMENT_LEVEL := NA]
tmp_Long_Data[, ACHIEVEMENT_LEVEL:=factor(ACHIEVEMENT_LEVEL, levels = c("B", "A", "P", "U"), labels=c("Did Not Pass", "Pass", "Pass+", "Undetermined"), ordered=TRUE)]
tmp_Long_Data[, ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)] 

# tmp_Long_Data[, as.list(summary(SCALE_SCORE)), keyby=list(CONTENT_AREA, GRADE_ID, ACHIEVEMENT_LEVEL)]  #  Checks out with SGPstateData


####  Demographics
tmp_Long_Data[which(GENDER == " "), GENDER := NA]
tmp_Long_Data[which(GENDER == "M"), GENDER := "Male"]
tmp_Long_Data[which(GENDER == "F"), GENDER := "Female"]

tmp_Long_Data[which(ETHNICITY == " "), ETHNICITY := NA]
tmp_Long_Data[, ETHNICITY:=factor(ETHNICITY, levels = as.character(1:7), 
					labels=c("American Indian/Alaska Native", "African American", "Asian", "Hispanic", "White", "Multiracial", "Pacific Islander"))]
tmp_Long_Data[, ETHNICITY:=as.character(ETHNICITY)] 

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


### Invalidate cases

tmp_Long_Data[, VALID_CASE := "VALID_CASE"]

tmp_Long_Data[which(STUDENT_ID == "         "), STUDENT_ID := NA] # Fixed witdh == 9 spaces
tmp_Long_Data[is.na(STUDENT_ID), VALID_CASE := "INVALID_CASE"]

setkey(tmp_Long_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID, SCALE_SCORE)
setkey(tmp_Long_Data, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, STUDENT_ID)

sum(duplicated(tmp_Long_Data[VALID_CASE=="VALID_CASE"])) # 15 - only 3 of which have "DUPLICATED" flag.  Others look like different kids.

data.table(tmp_Long_Data[c(which(duplicated(tmp_Long_Data))-1, which(duplicated(tmp_Long_Data))), ][VALID_CASE=="VALID_CASE"], key=key(tmp_Long_Data)
## Only 3 of 15 with "DUPLICATE" flag = Y

####  Invalidate lowest score?  Makes sense for 3 "true" duplicates above...
# tmp_Long_Data[c(which(duplicated(tmp_Long_Data))-1, which(duplicated(tmp_Long_Data))), ][VALID_CASE=="VALID_CASE"]
# tmp_Long_Data[which(duplicated(tmp_Long_Data))-1, VALID_CASE := "INVALID_CASE"]

####  Invalidate MATCH other than 1?  Move to first step invalidation?
table(tmp_Long_Data$MATCH)

### Final cleanup


# Indiana_Data_LONG_2015 <- tmp_Long_Data


### Order variable.names

# variable.names <- c("VALID_CASE", "STUDENT_ID", "CONTENT_AREA", "SCHOOL_YEAR", "GRADE_ID", "SCALE_SCORE", "ACHIEVEMENT_LEVEL", "IDOE_CORPORATION_ID", "CORPORATION_NAME", 
# 	"IDOE_SCHOOL_ID", "SCHOOL_NAME", "EMH_LEVEL", "HIGH_ABILITY_STATUS_CATEGORY", "SPECIAL_ED_STATUS", "ENGLISH_LEARNER_STATUS", "SOCIO_ECON_STATUS",
# 	"SCHOOL_ENROLLMENT_STATUS", "DISTRICT_ENROLLMENT_STATUS", "STATE_ENROLLMENT_STATUS") 
# setcolorder(Indiana_Data_LONG_2015, variable.names)


# ### Save result

# save(Indiana_Data_LONG_2015, file="Data/Indiana_Data_LONG_2015.Rdata")
