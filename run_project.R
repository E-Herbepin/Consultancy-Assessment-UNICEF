# run_project.R
# This script runs the full data analysis workflow

# Source the environment setup
source("user_profile.R")

# Step 1: Prepare raw data
# Check if the script for data preparation already ran, if not, run it, else load the processed data.
if (!dir.exists(processed_data_dir)) {
  dir.create(processed_data_dir, recursive = TRUE)
  dir.create(docs_dir, recursive = TRUE)
  source(here(scripts_dir, "data_preparation.R"))
  rm(list = setdiff(ls(), c("df_indicators", "df_demo", "df_status", "ls_tb_corres")))
  cat("Data prepared.\n")
} else {
  load(here(processed_data_dir, "correspondence_tables.RData"))
  read.csv2(here(processed_data_dir, "df_indicators.csv"))
  read.csv2(here(processed_data_dir, "demographic_indicators.csv"))
  read.csv2(here(processed_data_dir, "status.csv"))
  cat("Data loaded\n")
}

# Step 3: Render final report
rmarkdown::render(
  input = file.path(scripts_dir, "report.Rmd"),
  output_format = "pdf_document",
  output_file = file.path(docs_dir, "final_report.pdf")
)
cat("Report rendered successfully.\n")