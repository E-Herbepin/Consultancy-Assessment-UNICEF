# 📊 Test for Consultancy with the D&A Education Team
Application for the position of Learning and Skills Data Analyst Consultant

This repository is structured to support a fully **reproducible data analysis workflow**, from raw data to final report output.

## 📁 Folder Structure

```
.
├── 01_rawdata/         # Original, unmodified data files (never edited manually)
├── 02_data/            # Cleaned, processed, and transformed data
├── 03_scripts/         # All analysis scripts and helper functions
├── 04_documentation/   # Reports, protocol files, and documentation
├── user_profile.R      # Configuration script for reproducible environments
├── run_project.R       # Script to run the entire workflow end-to-end
└── README.md           # This file
```

## 📝 Folder Descriptions

- **01_rawdata/**:  
  Store raw input data files here. These files should remain unchanged to ensure reproducibility.

- **02_data/**:  
  Contains intermediate and final data products after cleaning and processing.

- **03_scripts/**:  
  Includes all R or Python scripts used for cleaning, analysis, visualization, and reporting.

- **04_documentation/**:  
  Contains written documentation, such as methodology notes, report drafts, and final outputs (e.g., PDF, HTML, DOCX reports).

## 🧩 Key Scripts

- **`user_profile.R`**:  
  This script ensures compatibility and reproducibility across different systems. It may include:
  - Package loading/install instructions
  - Path configuration
  - Environment variables

- **`run_project.R`**:  
  This master script runs the entire pipeline from raw data to final report.  
  ✅ Input: files from `01_rawdata/`  
  ✅ Output: report in `04_documentation/`
  ⚠️ The file from the UNICEF Global Data Repository [LINK](https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022) at the country level for the years 2018–2022 must have been downloaded in `01_rawdata/

To execute the full workflow, simply run:

```r
source("run_project.R")
```
---
