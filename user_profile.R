# user_profile.R
# This script sets up the environment for reproducibility

# Load required packages (install if necessary)
required_packages <- c("readxl", "here", "dplyr", "tidyr", "purrr", "janitor", "readr", "ggplot2")

for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "http://cran.us.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

# Set global options
options(stringsAsFactors = FALSE)

# Define data directories (use relative paths)
raw_data_dir <- "01_rawdata"
processed_data_dir <- "02_data"
scripts_dir <- "03_scripts"
docs_dir <- "04_documentation"

# Print environment setup summary
cat("Environment configured. Packages loaded and directories set.\n")
