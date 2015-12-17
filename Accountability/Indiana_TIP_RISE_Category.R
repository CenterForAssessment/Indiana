####################################################################################
###
### Function for creating TIP/RISE categories
###
####################################################################################


Indiana_TIP_RISE_Category <- function(teacher_data, lower.cut=35, upper.cut=65) {

	teacher_data$TIP_CATEGORY <- NA
	teacher_data$RISE_CATEGORY <- NA

	teacher_data$SE_MEDIAN_UPPER_BOUND <- round(pmin(teacher_data$MEDIAN_SGP + teacher_data$MEDIAN_SGP_STANDARD_ERROR, 99), digits=2)
	teacher_data$SE_MEDIAN_LOWER_BOUND <- round(pmax(teacher_data$MEDIAN_SGP - teacher_data$MEDIAN_SGP_STANDARD_ERROR, 1), digits=2)

	### Category 1

	teacher_data$TIP_CATEGORY[which(teacher_data$SE_MEDIAN_UPPER_BOUND < lower.cut)] <- 1
	teacher_data$RISE_CATEGORY[which(teacher_data$SE_MEDIAN_UPPER_BOUND < lower.cut)] <- 1


	### Category 2

	my.condition <- teacher_data$SE_MEDIAN_UPPER_BOUND < 50 & teacher_data$SE_MEDIAN_UPPER_BOUND >= lower.cut
	teacher_data$TIP_CATEGORY[which(my.condition)] <- 2
	teacher_data$RISE_CATEGORY[which(my.condition)] <- 2


	### Category 3

	my.condition_TIP <- teacher_data$SE_MEDIAN_UPPER_BOUND >= 50 & teacher_data$SE_MEDIAN_LOWER_BOUND <= 50
	my.condition_RISE <- teacher_data$SE_MEDIAN_UPPER_BOUND >= 50 & teacher_data$SE_MEDIAN_LOWER_BOUND <= upper.cut
	teacher_data$TIP_CATEGORY[which(my.condition_TIP)] <- 3
	teacher_data$RISE_CATEGORY[which(my.condition_RISE)] <- 3


	### Category 4

	my.condition_TIP <- teacher_data$SE_MEDIAN_LOWER_BOUND > 50 & teacher_data$SE_MEDIAN_LOWER_BOUND <= upper.cut
	my.condition_RISE <- teacher_data$SE_MEDIAN_LOWER_BOUND > upper.cut
	teacher_data$TIP_CATEGORY[which(my.condition_TIP)] <- 4
	teacher_data$RISE_CATEGORY[which(my.condition_RISE)] <- 4


	### Category 5

	my.condition_TIP <- teacher_data$SE_MEDIAN_LOWER_BOUND > upper.cut
	teacher_data$TIP_CATEGORY[which(my.condition_TIP)] <- 5

	### Return object

	return(teacher_data)
}

############################################################
###
### Create summary tables
###
############################################################

### Load Data

#load("../Data/Indiana_SGP.Rdata")


### Create tables

state_by_instructor <- Indiana_TIP_RISE_Category(subset(Indiana_SGP@Summary$STATE[["STATE__INSTRUCTOR_NUMBER__INSTRUCTOR_ENROLLMENT_STATUS"]], INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"))
state_by_instructor_by_content_area <- Indiana_TIP_RISE_Category(subset(Indiana_SGP@Summary$STATE[["STATE__INSTRUCTOR_NUMBER__CONTENT_AREA__INSTRUCTOR_ENROLLMENT_STATUS"]], INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"))
state_by_instructor_by_school_number <- Indiana_TIP_RISE_Category(subset(Indiana_SGP@Summary$SCHOOL_NUMBER[["SCHOOL_NUMBER__INSTRUCTOR_NUMBER__INSTRUCTOR_ENROLLMENT_STATUS"]], INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"))
state_by_instructor_by_school_number_by_content_area <- Indiana_TIP_RISE_Category(subset(Indiana_SGP@Summary$SCHOOL_NUMBER[["SCHOOL_NUMBER__INSTRUCTOR_NUMBER__CONTENT_AREA__INSTRUCTOR_ENROLLMENT_STATUS"]], INSTRUCTOR_ENROLLMENT_STATUS=="Enrolled Instructor: Yes"))

### Write tables

write.table(state_by_instructor, file="../Data/TIP_RISE_Data/state_by_instructor.txt", sep="|", quote=FALSE, na="", row.names=FALSE)
write.table(state_by_instructor_by_content_area, file="../Data/TIP_RISE_Data/state_by_instructor_by_content_area.txt", sep="|", quote=FALSE, na="", row.names=FALSE)
write.table(state_by_instructor_by_school_number, file="../Data/TIP_RISE_Data/state_by_instructor_by_school_number.txt", sep="|", quote=FALSE, na="", row.names=FALSE)
write.table(state_by_instructor_by_school_number_by_content_area, file="../Data/TIP_RISE_Data/state_by_instructor_by_school_number_by_content_area.txt", sep="|", quote=FALSE, na="", row.names=FALSE)
