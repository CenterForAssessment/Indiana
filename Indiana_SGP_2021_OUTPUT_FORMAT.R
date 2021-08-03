#################################################################
###
### Script to add variables to Indiana_SGP for 2021 reporting
###
#################################################################

### Load packages
require(SGP)
require(data.table)


### Load Data
load("Data/Indiana_SGP.Rdata")


### Add variables
tmp.copy <- copy(Indiana_SGP@Data)
tmp.copy[YEAR=="2021" & SGP_BASELINE <= 30, SGP_LEVEL_COVID_IMPACT:="Increased Likelihood of Large to Severe COVID Related Academic Impact"]
tmp.copy[YEAR=="2021" & SGP_BASELINE > 30 & SGP_BASELINE < 50, SGP_LEVEL_COVID_IMPACT:="Increased Likelihood of Moderate COVID Related Academic Impact"]
tmp.copy[YEAR=="2021" & SGP_BASELINE >= 50, SGP_LEVEL_COVID_IMPACT:="Increased Likelihood of Modest to No COVID Related Academic Impact"]

tmp.copy[YEAR=="2021" & GRADE=="5"  & SGP_BASELINE < 50, SGP_TARGET_BASELINE_RECOVERY_4_YEAR:=50+(50-SGP_BASELINE)/3]
tmp.copy[YEAR=="2021" & GRADE=="6" & SGP_BASELINE < 50, SGP_TARGET_BASELINE_RECOVERY_4_YEAR:=50+(50-SGP_BASELINE)/2]
tmp.copy[YEAR=="2021" & GRADE=="7" & SGP_BASELINE < 50, SGP_TARGET_BASELINE_RECOVERY_4_YEAR:=100-SGP_BASELINE]

### Put data back
Indiana_SGP@Data <- tmp.copy

### Save object
save(Indiana_SGP, file="Data/Indiana_SGP.Rdata")

### outputSGP
outputSGP(Indiana_SGP)
