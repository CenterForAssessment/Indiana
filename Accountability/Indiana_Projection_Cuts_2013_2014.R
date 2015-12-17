######################################################################################
###
### Script to extract and bind 2013 and 2014 projections
###
######################################################################################

### Load package

require(data.table)
require(SGP)


### Load data

load("../Data/Indiana_SGP.Rdata")


### Extract Projections

projection.tables <- c("ELA.2013", "MATHEMATICS.2013")
tmp.list <- list()
for (i in projection.tables) {
tmp.list[[i]] <- data.table(
			CONTENT_AREA=unlist(strsplit(i, "\\."))[1],
			YEAR=unlist(strsplit(i, "\\."))[2],
			Indiana_SGP@SGP$SGProjections[[i]][, c("ID", "P1_PROJ_YEAR_1_CURRENT", "P35_PROJ_YEAR_1_CURRENT", "P65_PROJ_YEAR_1_CURRENT")])
}

projection.tables <- c("ELA.2014", "MATHEMATICS.2014")
for (i in projection.tables) {
tmp.list[[i]] <- data.table(
			CONTENT_AREA=unlist(strsplit(i, "\\."))[1],
			YEAR=unlist(strsplit(i, "\\."))[2],
			Indiana_SGP@SGP$SGProjections[[i]][, c("ID", "P1_PROJ_YEAR_1_CURRENT", "P35_PROJ_YEAR_1_CURRENT", "P65_PROJ_YEAR_1_CURRENT")])
}


### bind

Indiana_Projection_Cuts_2013_2014 <- rbindlist(tmp.list)


### Save

save(Indiana_Projection_Cuts_2013_2014, file="../Data/Projection_Cuts/Indiana_Projection_Cuts_2013_2014.Rdata")
write.table(Indiana_Projection_Cuts_2013_2014, file="../Data/Projection_Cuts/Indiana_Projection_Cuts_2013_2014.txt", sep="|", na="", row.names=FALSE, quote=FALSE)

