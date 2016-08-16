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

load("../../Data/Indiana_SGP_LONG_Data.Rdata")
Indiana_SGP_LONG_Data_2014_2015 <- Indiana_SGP_LONG_Data[SCHOOL_YEAR %in% c("2014", "2015") & !is.na(SCALE_SCORE)]
Indiana_SGP_LONG_Data_2014_2015[,ACHIEVEMENT_LEVEL:=NULL]
Indiana_SGP_LONG_Data_2014_2015[,ACHIEVEMENT_LEVEL_PRIOR:=NULL]


### Modify SGPstateData for ACHIEVEMENT_LEVEL creation

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["ELA"]] <-
        list(
            GRADE_3=c(352, 395, 417, 453, 482, 521, 545),
            GRADE_4=c(378, 418, 437, 473, 501, 535, 567),
            GRADE_5=c(415, 449, 468, 497, 520, 548, 576),
            GRADE_6=c(409, 454, 478, 514, 545, 579, 623),
            GRADE_7=c(448, 482, 501, 530, 554, 584, 614),
            GRADE_8=c(440, 485, 508, 544, 577, 627, 665))

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["ELA.2015"]] <-
        list(
            GRADE_3=c(393, 414, 428, 452, 475, 500, 523),
            GRADE_4=c(415, 439, 456, 481, 504, 529, 557),
            GRADE_5=c(436, 465, 486, 505, 525, 546, 570),
            GRADE_6=c(445, 477, 502, 525, 547, 572, 596),
            GRADE_7=c(439, 488, 516, 540, 565, 592, 617),
            GRADE_8=c(466, 508, 537, 561, 587, 617, 647))

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["MATHEMATICS"]] <-
        list(
            GRADE_3=c(333, 385, 413, 449, 479, 513, 551),
            GRADE_4=c(379, 422, 445, 480, 509, 541, 582),
            GRADE_5=c(398, 442, 463, 503, 530, 556, 595),
            GRADE_6=c(422, 465, 487, 526, 556, 590, 625),
            GRADE_7=c(440, 487, 511, 544, 572, 603, 645),
            GRADE_8=c(462, 512, 537, 575, 606, 641, 671))

SGPstateData[["IN"]][["Achievement"]][["Cutscores"]][["MATHEMATICS.2015"]] <-
        list(
            GRADE_3=c(372, 402, 425, 443, 460, 480, 507),
            GRADE_4=c(401, 437, 458, 476, 492, 508, 534),
            GRADE_5=c(437, 461, 480, 498, 517, 535, 563),
            GRADE_6=c(458, 489, 510, 528, 544, 560, 582),
            GRADE_7=c(479, 509, 533, 548, 563, 578, 601),
            GRADE_8=c(495, 530, 554, 568, 581, 595, 618))


SGPstateData[["IN"]][["Achievement"]][["Levels"]] <-
        list(
        Labels=c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3", "Pass 1", "Pass 2", "Pass 3", "Pass + 1", "Pass + 2"),
        Proficient=c("Not Proficient", "Not Proficient", "Not Proficient", "Proficient", "Proficient", "Proficient", "Proficient", "Proficient"))

SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Achievement_Levels']] <-
        list(
        Labels=c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3", "Pass 1", "Pass 2", "Pass 3", "Pass + 1", "Pass + 2"),
        Proficient=c("Not Proficient", "Not Proficient", "Not Proficient", "Proficient", "Proficient", "Proficient", "Proficient", "Proficient"))

SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Achievement_Levels.2015']] <-
        list(
        Labels=c("Did Not Pass 1", "Did Not Pass 2", "Did Not Pass 3", "Pass 1", "Pass 2", "Pass 3", "Pass + 1", "Pass + 2"),
        Proficient=c("Not Proficient", "Not Proficient", "Not Proficient", "Proficient", "Proficient", "Proficient", "Proficient", "Proficient"))

SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Achievement_Level_Labels']] <-
        list(
        "Did Not Pass 1"="Did Not Pass 1",
        "Did Not Pass 2"="Did Not Pass 2",
        "Did Not Pass 3"="Did Not Pass 3",
        "Pass 1"="Pass 1",
        "Pass 2"="Pass 2",
        "Pass 3"="Pass 3",
        "Pass + 1"="Pass + 1",
        "Pass + 2"="Pass + 2")

SGPstateData[["IN"]][["Assessment_Program_Information"]][["Assessment_Transition"]][['Achievement_Level_Labels.2015']] <-
        list(
        "Did Not Pass 1"="Did Not Pass 1",
        "Did Not Pass 2"="Did Not Pass 2",
        "Did Not Pass 3"="Did Not Pass 3",
        "Pass 1"="Pass 1",
        "Pass 2"="Pass 2",
        "Pass 3"="Pass 3",
        "Pass + 1"="Pass + 1",
        "Pass + 2"="Pass + 2")


### create new ACHIEVEMENT_LEVEL and ACHIEVEMENT_LEVEL_PRIOR

## ACHIEVEMENT_LEVEL

Indiana_SGP <- prepareSGP(Indiana_SGP_LONG_Data_2014_2015)


## ACHIEVEMENT_LEVEL_PRIOR

Indiana_SGP@Data$YEAR <- as.character(as.numeric(Indiana_SGP@Data$YEAR)-2)
Indiana_SGP@Data$GRADE <- as.character(as.numeric(Indiana_SGP@Data$GRADE)-1)
Indiana_SGP@Data <- SGP:::getAchievementLevel(Indiana_SGP@Data, state="IN", achievement.level.name="ACHIEVEMENT_LEVEL_PRIOR", scale.score.name="SCALE_SCORE_PRIOR")
Indiana_SGP@Data$YEAR <- as.character(as.numeric(Indiana_SGP@Data$YEAR)+2)
Indiana_SGP@Data$GRADE <- as.character(as.numeric(Indiana_SGP@Data$GRADE)+1)


################################################
### Summarize target ranges
################################################

my.tmp <- Indiana_SGP@Data[YEAR=="2015" & !is.na(ACHIEVEMENT_LEVEL_PRIOR),
    list(MEDIAN_SGP=as.numeric(median(SGP, na.rm=TRUE)), MEAN_SGP=mean(SGP, na.rm=TRUE), SD_SGP=sd(SGP, na.rm=TRUE), COUNT=.N), keyby=list(CONTENT_AREA, GRADE, ACHIEVEMENT_LEVEL_PRIOR, ACHIEVEMENT_LEVEL)]

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
