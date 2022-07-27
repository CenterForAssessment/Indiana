#################################################################
###
### Script to add variables to Indiana_SGP for 2022 reporting
###
#################################################################

### Load packages
require(SGP)
require(data.table)


### Load Data
load("Data/Indiana_SGP.Rdata")
load("Data/Indiana_SGP_WIDE_Data.Rdata")

### Create variables
impact.levels <- c("Increased Likelihood of Large to Severe COVID Related Academic Impact", "Increased Likelihood of Moderate COVID Related Academic Impact", "Increased Likelihood of Modest to No COVID Related Academic Impact")
recovery.levels.list <- list()
large.impact.recovery.levels <- c("Large 2019 to 2021 impact followed by low rates of learning in 2022", "Large impact followed by typical rates of learning in 2022", "Large impact followed by high rates of learning in 2022")
moderate.impact.recovery.levels <- c("Moderate 2019 to 2021 impact followed by low rates of learning in 2022", "Moderate impact followed by typical rates of learning in 2022", "Moderate impact followed by high rates of learning in 2022")
no.impact.recovery.levels <- c("Modest to no 2019 to 2021 impact followed by low rates of learning in 2022", "Modest to no impact followed by typical rates of learning in 2022", "Modest to no impact followed by high rates of learning in 2022")
recovery.levels.list[[1]] <- large.impact.recovery.levels
recovery.levels.list[[2]] <- moderate.impact.recovery.levels
recovery.levels.list[[3]] <- no.impact.recovery.levels

### Add variables
for (impact.levels.iter in seq_along(impact.levels)) {
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.ELA==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.ELA < 30, SGP_LEVEL_COVID_IMPACT.2022.ELA:=recovery.levels.list[[impact.levels.iter]][1]]
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.ELA==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.ELA >= 30 & SGP_BASELINE.2022.ELA <= 70, SGP_LEVEL_COVID_IMPACT.2022.ELA:=recovery.levels.list[[impact.levels.iter]][2]]
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.ELA==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.ELA > 70, SGP_LEVEL_COVID_IMPACT.2022.ELA:=recovery.levels.list[[impact.levels.iter]][3]]
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.MATHEMATICS==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.MATHEMATICS < 30, SGP_LEVEL_COVID_IMPACT.2022.MATHEMATICS:=recovery.levels.list[[impact.levels.iter]][1]]
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.MATHEMATICS==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.MATHEMATICS >= 30 & SGP_BASELINE.2022.MATHEMATICS <= 70, SGP_LEVEL_COVID_IMPACT.2022.MATHEMATICS:=recovery.levels.list[[impact.levels.iter]][2]]
    Indiana_SGP_WIDE_Data[SGP_LEVEL_COVID_IMPACT.2021.MATHEMATICS==impact.levels[impact.levels.iter] & SGP_BASELINE.2022.MATHEMATICS > 70, SGP_LEVEL_COVID_IMPACT.2022.MATHEMATICS:=recovery.levels.list[[impact.levels.iter]][3]]
}

Indiana_SGP_WIDE_Data[, SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.ELA:=SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2021.ELA+(SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2021.ELA-SGP_BASELINE.2022.ELA)/2]
Indiana_SGP_WIDE_Data[, SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.MATHEMATICS:=SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2021.MATHEMATICS+(SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2021.MATHEMATICS-SGP_BASELINE.2022.MATHEMATICS)/2]


### Create a LONG data file to merge into @Data 

tmp.ela <- Indiana_SGP_WIDE_Data[,c("ID", "SGP_LEVEL_COVID_IMPACT.2022.ELA", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.ELA")][,CONTENT_AREA:="ELA"][,VALID_CASE:="VALID_CASE"][,YEAR:="2022"][!is.na(SGP_LEVEL_COVID_IMPACT.2022.ELA) | !is.na(SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.ELA)]
setnames(tmp.ela, 2:3, c("SGP_LEVEL_COVID_IMPACT", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR"))
tmp.math <- Indiana_SGP_WIDE_Data[,c("ID", "SGP_LEVEL_COVID_IMPACT.2022.MATHEMATICS", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.MATHEMATICS")][,CONTENT_AREA:="ELA"][,VALID_CASE:="VALID_CASE"][,YEAR:="2022"][!is.na(SGP_LEVEL_COVID_IMPACT.2022.MATHEMATICS) | !is.na(SGP_TARGET_BASELINE_RECOVERY_4_YEAR.2022.MATHEMATICS)]
setnames(tmp.math, 2:3, c("SGP_LEVEL_COVID_IMPACT", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR"))
setkey(tmp.ela, VALID_CASE, CONTENT_AREA, YEAR, ID)
setkey(tmp.math, VALID_CASE, CONTENT_AREA, YEAR, ID)

### Merge in additional variables
tmp.copy <- copy(Indiana_SGP@Data)
setkey(tmp.copy, VALID_CASE, CONTENT_AREA, YEAR, ID)

variables.to.merge <- c("SGP_LEVEL_COVID_IMPACT", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR")
tmp.index <- tmp.copy[tmp.ela[,c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"), with=FALSE], which=TRUE, on=key(tmp.ela)]
tmp.copy[tmp.index, (variables.to.merge):=tmp.ela[, variables.to.merge, with=FALSE]]

variables.to.merge <- c("SGP_LEVEL_COVID_IMPACT", "SGP_TARGET_BASELINE_RECOVERY_4_YEAR")
tmp.index <- tmp.copy[tmp.math[,c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID"), with=FALSE], which=TRUE, on=key(tmp.math)]
tmp.copy[tmp.index, (variables.to.merge):=tmp.math[, variables.to.merge, with=FALSE]]

Indiana_SGP@Data <- tmp.copy 

### Save object
save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")

### outputSGP
outputSGP(Indiana_SGP)
