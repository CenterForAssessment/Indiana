################################################################################
###
### Scripts to establish SGP Target ranges based upon cuts established by IDOE
###
################################################################################

### Load package

require(SGP)
require(data.table)
#debug(SGP:::getAchievementLevel)

### Load 2015 data

#load("../../Data/Indiana_SGP_LONG_Data.Rdata")
#Indiana_SGP_LONG_Data_2015_2016 <- Indiana_SGP_LONG_Data[SCHOOL_YEAR %in% c("2015", "2016") & !is.na(SCALE_SCORE)]
#Indiana_SGP_LONG_Data_2015_2016[,ACHIEVEMENT_LEVEL:=NULL]
#Indiana_SGP_LONG_Data_2015_2016[,ACHIEVEMENT_LEVEL_PRIOR:=NULL]


### Modify SGPstateData for ACHIEVEMENT_LEVEL creation

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["ELA"]] <-
        list(
            GRADE_3=c(393, 414, 428, 452, 475, 500, 523),
            GRADE_4=c(415, 439, 456, 481, 504, 529, 552),
            GRADE_5=c(440, 467, 486, 505, 525, 546, 570),
            GRADE_6=c(447, 481, 502, 525, 547, 572, 596),
            GRADE_7=c(462, 494, 516, 540, 565, 592, 617),
            GRADE_8=c(478, 513, 537, 561, 587, 617, 647))

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["MATHEMATICS"]] <-
        list(
            GRADE_3=c(372, 402, 425, 443, 460, 480, 507),
            GRADE_4=c(417, 440, 458, 474, 490, 508, 532),
            GRADE_5=c(437, 461, 480, 498, 517, 535, 558),
            GRADE_6=c(463, 491, 510, 526, 542, 560, 582),
            GRADE_7=c(490, 514, 533, 546, 562, 578, 601),
            GRADE_8=c(508, 535, 554, 567, 580, 595, 618))

SGPstateData[["IN"]][["Achievement"]][["Levels"]] <-
        list(
        Labels=c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3", "Pass 1", "Pass 2", "Pass 3", "Pass + 1", "Pass + 2"),
        Proficient=c("Not Proficient", "Not Proficient", "Not Proficient", "Proficient", "Proficient", "Proficient", "Proficient", "Proficient"))

SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]] <- NULL


### create new ACHIEVEMENT_LEVEL and ACHIEVEMENT_LEVEL_PRIOR

## ACHIEVEMENT_LEVEL

Indiana_SGP <- prepareSGP(Indiana_SGP_LONG_Data_2015_2016)


## ACHIEVEMENT_LEVEL_PRIOR

Indiana_SGP@Data <- SGP:::getAchievementLevel(Indiana_SGP@Data, state="IN", achievement.level.name="ACHIEVEMENT_LEVEL_PRIOR", scale.score.name="SCALE_SCORE_PRIOR")


### TEST DISTRIBUTION BASED UPON CUTS

print(prop.table(table(Indiana_SGP@Data[CONTENT_AREA=="ELA"]$ACHIEVEMENT_LEVEL, Indiana_SGP@Data[CONTENT_AREA=="ELA"]$GRADE), 2))
print(prop.table(table(Indiana_SGP@Data[CONTENT_AREA=="MATHEMATICS"]$ACHIEVEMENT_LEVEL, Indiana_SGP@Data[CONTENT_AREA=="MATHEMATICS"]$GRADE), 2))

################################################
### Summarize target ranges
################################################

my.tmp <- Indiana_SGP@Data[YEAR=="2015" & !is.na(ACHIEVEMENT_LEVEL_PRIOR),
    list(
	MEDIAN_SGP=as.numeric(median(SGP, na.rm=TRUE)),
	MEAN_SGP=mean(SGP, na.rm=TRUE),
	PERCENTILE_25_SGP=quantile(SGP, probs=0.25, na.rm=TRUE),
	PERCENTILE_75_SGP=quantile(SGP, probs=0.75, na.rm=TRUE),
	SD_SGP=sd(SGP, na.rm=TRUE), COUNT=.N), keyby=list(CONTENT_AREA, GRADE, ACHIEVEMENT_LEVEL_PRIOR, ACHIEVEMENT_LEVEL)]

my.transitions <- list(
    dnp1=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Did Not Pass 1", 2), ACHIEVEMENT_LEVEL=c("Did Not Pass 1", "Did Not Pass 2")),
    dnp2=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Did Not Pass 2", 3), ACHIEVEMENT_LEVEL=c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3")),
    dnp3=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Did Not Pass 3", 3), ACHIEVEMENT_LEVEL=c("Did Not Pass 2", "Did Not Pass 3", "Pass 1")),
    p1=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Pass 1", 3), ACHIEVEMENT_LEVEL=c("Did Not Pass 3", "Pass 1", "Pass 2")),
    p2=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Pass 2", 3), ACHIEVEMENT_LEVEL=c("Pass 1", "Pass 2", "Pass 3")),
    p3=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Pass 3", 3), ACHIEVEMENT_LEVEL=c("Pass 2", "Pass 3", "Pass + 1")),
    pp1=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Pass + 1", 3), ACHIEVEMENT_LEVEL=c("Pass 3", "Pass + 1", "Pass + 2")),
    pp2=data.table(ACHIEVEMENT_LEVEL_PRIOR=rep("Pass + 2", ), ACHIEVEMENT_LEVEL=c("Pass + 1", "Pass + 2")))

my.transitions.long <- data.table(rbindlist(my.transitions), key=c("ACHIEVEMENT_LEVEL_PRIOR", "ACHIEVEMENT_LEVEL"))
setkeyv(my.tmp, c("ACHIEVEMENT_LEVEL_PRIOR", "ACHIEVEMENT_LEVEL"))

final.transitions <- data.table(my.tmp[my.transitions.long], key=c("CONTENT_AREA", "GRADE", "ACHIEVEMENT_LEVEL_PRIOR", "ACHIEVEMENT_LEVEL"))


### Calculate points based upon target ranges

slot.data <- copy(Indiana_SGP@Data)

prior.achievement.levels <- c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3", "Pass 1", "Pass 2", "Pass 3", "Pass + 1", "Pass + 2")
target.ranges.1 <- list(
    DID_NOT_PASS_1=list(c(0,34,0), c(35,59,75), c(60,99,175)),
    DID_NOT_PASS_2=list(c(0,36,0), c(37,61,75), c(62,99,175)),
    DID_NOT_PASS_3=list(c(0,39,0), c(40,62,75), c(63,99,175)),
    PASS_1=list(c(0,41,50), c(42,56,100), c(57,99,150)),
    PASS_2=list(c(0,42,50), c(43,59,100), c(60,99,150)),
    PASS_3=list(c(0,43,50), c(44,61,100), c(62,99,150)),
    PASS_PLUS_1=list(c(0,43,50), c(44,61,100), c(62,99,150)),
    PASS_PLUS_2=list(c(0,43,50), c(44,61,100), c(62,99,150))
    )
target.ranges.2 <- list(
    DID_NOT_PASS_1=list(c(0,25,0), c(26,54,75), c(55,99,175)),
    DID_NOT_PASS_2=list(c(0,25,0), c(26,54,75), c(55,99,175)),
    DID_NOT_PASS_3=list(c(0,25,0), c(26,54,75), c(55,99,175)),
    PASS_1=list(c(0,43,50), c(44,56,100), c(57,99,150)),
    PASS_2=list(c(0,44,50), c(45,59,100), c(60,99,150)),
    PASS_3=list(c(0,45,50), c(46,61,100), c(62,99,150)),
    PASS_PLUS_1=list(c(0,45,50), c(46,61,100), c(62,99,150)),
    PASS_PLUS_2=list(c(0,45,50), c(46,61,100), c(62,99,150))
    )

for (al.iter in prior.achievement.levels) {
	al.name <- gsub("[+]", "PLUS", gsub(" ", "_", toupper(al.iter)))
    for (i.iter in 1:3) {
        slot.data[YEAR=="2016" & ACHIEVEMENT_LEVEL_PRIOR==al.iter & SGP >= target.ranges.2[[al.name]][[i.iter]][1] & SGP <= target.ranges.2[[al.name]][[i.iter]][2], POINTS:=target.ranges.2[[al.name]][[i.iter]][3]]
    }
}

aggregate.school.data <- slot.data[YEAR=="2016", list(MEDIAN_SGP=median(SGP, na.rm=TRUE), MEAN_POINTS=mean(POINTS, na.rm=TRUE), MEAN_PRIOR_ACHIEVEMENT=mean(SCALE_SCORE_PRIOR_STANDARDIZED, na.rm=TRUE), COUNT=.N), keyby=list(SCHOOL_NUMBER)]
aggregate.school.content_area.data <- slot.data[YEAR=="2016", list(MEDIAN_SGP=median(SGP, na.rm=TRUE), MEAN_POINTS=mean(POINTS, na.rm=TRUE), MEAN_PRIOR_ACHIEVEMENT=mean(SCALE_SCORE_PRIOR_STANDARDIZED, na.rm=TRUE), COUNT=.N), keyby=list(SCHOOL_NUMBER, CONTENT_AREA)]
aggregate.school.data <- aggregate.school.data[COUNT>=20]
aggregate.school.content_area.data <- aggregate.school.content_area.data[COUNT>=20]


cat("POINTS: SCHOOL by CONTENT_AREA\n")
print(cor(aggregate.school.content_area.data[CONTENT_AREA=="ELA"]$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.content_area.data[CONTENT_AREA=="ELA"]$MEAN_POINTS, use="complete.obs"))
print(cor(aggregate.school.content_area.data[CONTENT_AREA=="MATHEMATICS"]$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.content_area.data[CONTENT_AREA=="MATHEMATICS"]$MEAN_POINTS, use="complete.obs"))
cat("\nSGP: SCHOOL by CONTENT_AREA\n")
print(cor(aggregate.school.content_area.data[CONTENT_AREA=="ELA"]$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.content_area.data[CONTENT_AREA=="ELA"]$MEDIAN_SGP, use="complete.obs"))
print(cor(aggregate.school.content_area.data[CONTENT_AREA=="MATHEMATICS"]$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.content_area.data[CONTENT_AREA=="MATHEMATICS"]$MEDIAN_SGP, use="complete.obs"))
cat("\n\nPOINTS: SCHOOL\n")
print(cor(aggregate.school.data$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.data$MEAN_POINTS, use="complete.obs"))
cat("\n\nSGP: SCHOOL\n")
print(cor(aggregate.school.data$MEAN_PRIOR_ACHIEVEMENT, aggregate.school.data$MEDIAN_SGP, use="complete.obs"))
