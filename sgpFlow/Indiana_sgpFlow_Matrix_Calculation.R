########################################################################
### Indiana sgpFlow Matrix Calculation
########################################################################

# Load necessary libraries
require(SGP)
require(sgpFlow)
require(data.table)

# Load data
load("../Data/Indiana_SGP.Rdata")

# Parameters
num_cores <- parallel::detectCores() - 1

# Load and create MATRIX configurations
source("SGP_CONFIG/Matrices/MATHEMATICS.R")
source("SGP_CONFIG/Matrices/ELA.R")
IN_Matrix.config <- c(MATHEMATICS_Matrix.config, ELA_Matrix.config)

# Load and create Super-Cohort configurations
source("SGP_CONFIG/Super_Cohort/MATHEMATICS.R")
source("SGP_CONFIG/Super_Cohort/ELA.R")
IN_Super_Cohort.config <- c(MATHEMATICS_Super_Cohort.config, ELA_Super_Cohort.config)

# Create sgpFlow matrices
IN_sgpFlow_Matrices <- createMatrices(
     data_for_matrices=Indiana_SGP,
     state="IN",
     matrix.sgp.config=IN_Matrix.config,
     super_cohort.sgp.config=IN_Super_Cohort.config,
     super_cohort_base_years=c("2021", "2022", "2023", "2024"),
     parallel.config=list(BACKEND="PARALLEL", WORKERS=list(TAUS=num_cores)),
     matrix_types=c("single-cohort", "super-cohort")
)

# Save sgpFlow matrices
save(IN_sgpFlow_Matrices, file="Data/IN_sgpFlow_Matrices.rda")
