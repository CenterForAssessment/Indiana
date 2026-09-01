###########################################################################################
###
### Script for creating Indiana LONG data set for 2026
###
###########################################################################################

### Load SGP Package:
require(data.table)

### Cutscores (official 2026 NEW scale; from SGPstateData IN, commented NEW_SCALE lists)
### SGPstateData 2026 cuts remain on the OLD scale for projections.
		ELA.2026.NEW_SCALE=list(
			GRADE_3=c(364, 413, 456),
			GRADE_4=c(388, 434, 484),
			GRADE_5=c(398, 449, 503),
			GRADE_6=c(408, 462, 518),
			GRADE_7=c(418, 474, 530),
			GRADE_8=c(431, 484, 540))

		MATHEMATICS.2026.NEW_SCALE=list(
			GRADE_3=c(468, 485, 512),
			GRADE_4=c(489, 505, 541),
			GRADE_5=c(505, 531, 573),
			GRADE_6=c(525, 561, 617),
			GRADE_7=c(549, 605, 669),
			GRADE_8=c(585, 661, 738))

		achievement.level.labels <- c("Below Proficiency", "Approaching Proficiency", "At Proficiency", "Above Proficiency")
		tmp.cutscores <- list(ELA=ELA.2026.NEW_SCALE, MATHEMATICS=MATHEMATICS.2026.NEW_SCALE)

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
setnames(Indiana_Demographics_2026, c("STUDENT_ID", "GRADE_ID", "ETHNICITY", "GENDER", "SPECIAL_EDUCATION_STATUS", "SOCIO_ECONOMIC_STATUS", "ENGLISH_LANGUAGE_LEARNER_STATUS"))
Indiana_Demographics_2026[,"GRADE_ID":=NULL]
Indiana_Demographics_2026[,SCHOOL_YEAR:="2026"][,VALID_CASE:="VALID_CASE"]
Indiana_Demographics_2026[SPECIAL_EDUCATION_STATUS=="",SPECIAL_EDUCATION_STATUS:="Unknown"]
setkey(Indiana_Demographics_2026, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, STUDENT_ID)

### Merge in demographics
Indiana_Data_LONG_2026 <- Indiana_Data_LONG_2026[Indiana_Demographics_2026]
Indiana_Data_LONG_2026[,ETHNICITY:=as.factor(ETHNICITY)]

### Add in ACHIEVEMENT_LEVEL (SCALE_SCORE is on the NEW scale; use NEW_SCALE cuts above)
Indiana_Data_LONG_2026[, ACHIEVEMENT_LEVEL := as.character(factor(
	findInterval(SCALE_SCORE, tmp.cutscores[[CONTENT_AREA[1]]][[paste("GRADE", GRADE_ID[1], sep="_")]])+1L,
	levels=seq_along(achievement.level.labels), labels=achievement.level.labels)),
	by=c("CONTENT_AREA", "GRADE_ID")]

### Tidy up column order
setcolorder(Indiana_Data_LONG_2026, c(8, 11, 7, 9, 1, 10, 12, 2, 3, 4, 5, 6))

### Take highest score for duplicates
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID, SCALE_SCORE)
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)
Indiana_Data_LONG_2026[which(duplicated(Indiana_Data_LONG_2026, by=key(Indiana_Data_LONG_2026)))-1, VALID_CASE:="INVALID_CASE"]

# Create SCALE_SCORE_OLD variable (2026 NEW scale -> OLD scale)
load("Data/Indiana_Data_LONG_2025.Rdata")
tmp.equate.data.long <- SGP::prepareSGP(rbindlist(list(Indiana_Data_LONG_2025, Indiana_Data_LONG_2026), use.names=TRUE, fill=TRUE), state="IN")@Data
tmp.equate.functions <- SGP:::equateSGP(tmp.equate.data.long, state="IN", current.year=2026, equating.method="equipercentile")
for (content_area.iter in c("ELA", "MATHEMATICS")) {
    for (grade.iter in as.character(3:8)) {
        Indiana_Data_LONG_2026[VALID_CASE == "VALID_CASE" & CONTENT_AREA == content_area.iter & GRADE_ID == grade.iter, SCALE_SCORE_OLD_SCALE := tmp.equate.functions[[paste(content_area.iter, "2026", sep=".")]][[paste("GRADE", grade.iter, sep="_")]][["EQUIPERCENTILE"]][["NEW_TO_OLD"]][["interpolated_function"]](SCALE_SCORE)]
    }
}

### setkey final time and save
setkey(Indiana_Data_LONG_2026, VALID_CASE, SCHOOL_YEAR, CONTENT_AREA, GRADE_ID, STUDENT_ID)
save(Indiana_Data_LONG_2026, file="Data/Indiana_Data_LONG_2026.Rdata")
