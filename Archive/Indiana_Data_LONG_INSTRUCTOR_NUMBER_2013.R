#####################################################################################
###
### Creation of 2013 Instructor Number table
###
#####################################################################################

### Load packages

require(data.table)
require(SGP)


### utility functions

strtail <- function(s,n=1) {
  if(n<0) 
    substring(s,1-n) 
  else 
    substring(s,nchar(s)-n+1)
}
strhead <- function(s,n) {
  if(n<0) 
    substr(s,1,nchar(s)+n) 
  else 
    substr(s,1,n)
}


### Load data

INSTRUCTOR_NUMBER_ELA_2013 <- read.csv("ee_ela_export_with_headers.csv")
INSTRUCTOR_NUMBER_MATHEMATICS_2013 <- read.csv("ee_math_export_with_headers.csv")


### Tidy up data

INSTRUCTOR_NUMBER_WIDE <- as.data.table(rbind(INSTRUCTOR_NUMBER_ELA_2013, INSTRUCTOR_NUMBER_MATHEMATICS_2013))

attach(INSTRUCTOR_NUMBER_WIDE)
INSTRUCTOR_NUMBER <- data.table(
			ID=rep(STUDENT_ID, 15),
			YEAR=rep(SCHOOL_YEAR, 15),
			CONTENT_AREA=rep(CONTENT_AREA_CODE, 15),
			INSTRUCTOR_NUMBER=c(teacher_1, teacher_2, teacher_3, teacher_4, teacher_5, teacher_6, teacher_7, teacher_8, teacher_9, teacher_10, teacher_11, teacher_12, teacher_13, teacher_14, teacher_15),
			INSTRUCTOR_WEIGHT=1L,
			INSTRUCTOR_ENROLLMENT_STATUS=factor(1, levels=0:1, labels=c("Enrolled Instructor: No", "Enrolled Instructor: Yes")))
detach(INSTRUCTOR_NUMBER_WIDE)

INSTRUCTOR_NUMBER <- subset(INSTRUCTOR_NUMBER, !is.na(INSTRUCTOR_NUMBER))

INSTRUCTOR_NUMBER$ID <- as.character(INSTRUCTOR_NUMBER$ID)
INSTRUCTOR_NUMBER$YEAR <- "2013"
levels(INSTRUCTOR_NUMBER$CONTENT_AREA)[2] <- "MATHEMATICS"
INSTRUCTOR_NUMBER$YEAR <- as.character(INSTRUCTOR_NUMBER$YEAR)
INSTRUCTOR_NUMBER$CONTENT_AREA <- as.character(INSTRUCTOR_NUMBER$CONTENT_AREA)
INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER <- as.character(INSTRUCTOR_NUMBER$INSTRUCTOR_NUMBER)

setkey(INSTRUCTOR_NUMBER, ID, CONTENT_AREA, YEAR)

### Save results

Indiana_Data_LONG_INSTRUCTOR_NUMBER_2013 <- INSTRUCTOR_NUMBER
save(Indiana_Data_LONG_INSTRUCTOR_NUMBER_2013, file="../Indiana_Data_LONG_INSTRUCTOR_NUMBER_2013.Rdata")
