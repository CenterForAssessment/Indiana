###########################################################################
###
### Script for creating Indian projection cuts for 2014-2015 with equating
###
###########################################################################

### Load SGP Package

require(SGP)
require(data.table)


### Load Indiana_SGP

load("../Data/Indiana_SGP.Rdata")


### Create table with straight projections

variables.to.get <- c("ID", "P1_PROJ_YEAR_1_CURRENT", "P35_PROJ_YEAR_1_CURRENT", "P65_PROJ_YEAR_1_CURRENT", "SGP_PROJECTION_GROUP")
Indiana_Projection_Cuts_2014_2015 <- rbindlist(Indiana_SGP@SGP$SGProjections[23:24])[,variables.to.get,with=FALSE][,YEAR:="2014"][,VALID_CASE:="VALID_CASE"]
setnames(Indiana_Projection_Cuts_2014_2015, "SGP_PROJECTION_GROUP", "CONTENT_AREA")
setkey(Indiana_Projection_Cuts_2014_2015, VALID_CASE, CONTENT_AREA, YEAR, ID)
Indiana_Projection_Cuts_2014_2015 <- Indiana_SGP@Data[,c("VALID_CASE", "CONTENT_AREA", "YEAR", "ID", "GRADE"), with=FALSE][Indiana_Projection_Cuts_2014_2015]
Indiana_Projection_Cuts_2014_2015[,GRADE:=as.character(as.numeric(GRADE)+1)]

for (content_area.iter in c("ELA", "MATHEMATICS")) {
    for (grade.iter in as.character(4:8)) {
        tmp.function <- Indiana_SGP@SGP[['Linkages']][[paste(content_area.iter, "2015", sep=".")]][[paste("GRADE", grade.iter, sep="_")]][['EQUIPERCENTILE']][['OLD_TO_NEW']][['interpolated_function']]
        Indiana_Projection_Cuts_2014_2015[CONTENT_AREA==content_area.iter & GRADE==grade.iter, P1_PROJ_YEAR_1_CURRENT_EQUATED:=tmp.function(P1_PROJ_YEAR_1_CURRENT)]
        Indiana_Projection_Cuts_2014_2015[CONTENT_AREA==content_area.iter & GRADE==grade.iter, P35_PROJ_YEAR_1_CURRENT_EQUATED:=tmp.function(P35_PROJ_YEAR_1_CURRENT)]
        Indiana_Projection_Cuts_2014_2015[CONTENT_AREA==content_area.iter & GRADE==grade.iter, P65_PROJ_YEAR_1_CURRENT_EQUATED:=tmp.function(P65_PROJ_YEAR_1_CURRENT)]
    }
}

variables.to.get <- c("CONTENT_AREA", "YEAR", "ID", "P1_PROJ_YEAR_1_CURRENT", "P35_PROJ_YEAR_1_CURRENT_EQUATED", "P65_PROJ_YEAR_1_CURRENT_EQUATED")
Indiana_Projection_Cuts_2014_2015 <- Indiana_Projection_Cuts_2014_2015[,variables.to.get, with=FALSE]


### Save results

save(Indiana_Projection_Cuts_2014_2015, file="../Data/Projection_Cuts/Indiana_Projection_Cuts_2014_2015.Rdata")
write.table(Indiana_Projection_Cuts_2014_2015, file="../Data/Projection_Cuts/Indiana_Projection_Cuts_2014_2015.txt", sep="|", row.names=FALSE, quote=FALSE, na="")
