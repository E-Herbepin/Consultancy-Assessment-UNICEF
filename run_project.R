# run_project.R
# This script runs the full data analysis workflow

# Source the environment setup
source("user_profile.R")

# Step 1: Prepare raw data
# Check if the script for data preparation already ran, if not, run it, else load the processed data.
if (!dir.exists(processed_data_dir)) {
  dir.create(processed_data_dir, recursive = TRUE)
  dir.create(docs_dir, recursive = TRUE)
  dir.create(docs_dir, recursive = TRUE)
  source(here(scripts_dir, "data_preparation.R"))
  cat("Data prepared.\n")
}

# Step 2: Render final report
rmarkdown::render(
  input = here(scripts_dir, "report.Rmd"),
  output_format = "html_document",
  output_file = here(docs_dir, "final_report.html")
)
cat("Report rendered successfully.\n")