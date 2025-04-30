################################################################################
###                                                                          ###
###      ELA matrix configurations                                           ###
###                                                                          ###
################################################################################

ELA_Matrix.config <- list(
	list(
		sgp.baseline.content.areas=rep("ELA", 2),
		sgp.baseline.panel.years=c("2023", "2024"),
		sgp.baseline.grade.sequences=c("3", "4"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("ELA", 2),
		sgp.baseline.panel.years=c("2023", "2024"),
		sgp.baseline.grade.sequences=c("4", "5"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("ELA", 3),
		sgp.baseline.panel.years=c("2022", "2023", "2024"),
		sgp.baseline.grade.sequences=c("3", "4", "5"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("ELA", 2),
		sgp.baseline.panel.years=c("2023", "2024"),
		sgp.baseline.grade.sequences=c("5", "6"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("ELA", 3),
		sgp.baseline.panel.years=c("2022", "2023", "2024"),
		sgp.baseline.grade.sequences=c("4", "5", "6"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("ELA", 2),
		sgp.baseline.panel.years=c("2023", "2024"),
		sgp.baseline.grade.sequences=c("6", "7"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("ELA", 3),
		sgp.baseline.panel.years=c("2022", "2023", "2024"),
		sgp.baseline.grade.sequences=c("5", "6", "7"),
		sgp.baseline.grade.sequences.lags=c(1,1)),
	list(
		sgp.baseline.content.areas=rep("ELA", 2),
		sgp.baseline.panel.years=c("2023", "2024"),
		sgp.baseline.grade.sequences=c("7", "8"),
		sgp.baseline.grade.sequences.lags=1),
	list(
		sgp.baseline.content.areas=rep("ELA", 3),
		sgp.baseline.panel.years=c("2022", "2023", "2024"),
		sgp.baseline.grade.sequences=c("6", "7", "8"),
		sgp.baseline.grade.sequences.lags=c(1,1))
)
