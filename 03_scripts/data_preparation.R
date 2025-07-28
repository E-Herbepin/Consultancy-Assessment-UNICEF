#------------------#
# Data Preparation #
#------------------#

# This script prepares the data for analysis

# --------------------------- #
#   1. Load Status Table ----
# --------------------------- #

# Load country status data (on-track / off-track)
df_status <- read_xlsx(
  path = here("01_rawdata", "On-track and off-track countries.xlsx"),
  col_names = TRUE,
  col_types = c("text", "text", "text")
) |> 
  clean_names() |> 
  # Ensure the status table has correct column names (no spaces, special characters or capital letters)
  mutate(
    group = case_when(
      status_u5mr %in% c("On Track", "Achieved") ~ "on_track",
      status_u5mr == "Acceleration Needed" ~ "off_track"
    )
  )

# ---------------------------------------------------- #
#   2. Load and Clean Demographic Indicators Data ----
# ---------------------------------------------------- #

# Read demographic indicators (skip metadata rows)
df_demo_pre <- read_xlsx(
  path = here("01_rawdata", "WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx"),
  sheet = "Projections",
  col_names = FALSE,
  .name_repair = "minimal",
  skip = 15
)

# There are two header rows in the dataset. The first row contains categories (e.g., "Population", "Fertility"), and the second row contains variable names (e.g., "Total population", "Crude birth rate").
# We will merge these two rows to create meaningful column names.

# The categories are written in a single column and are not repeated for each sub-variable.
# We need to fill in the categories from the right.

# Extract and propagate merged column categories
names_cat <- df_demo_pre[1, ] |> 
  t() |> 
  as.data.frame() |> 
  fill(1, .direction = "down") |> 
  t()

# Construct cleaned column names by combining categories and variable names
colnames(df_demo_pre) <- ifelse(
  # If the category name is NA, use the second row (variable names)
  is.na(names_cat),
  df_demo_pre[2, ],
  # Otherwise, combine category and variable name with an underscore
  paste(names_cat, df_demo_pre[2, ], sep = "_")
) |> 
  # Clean column names to remove spaces and special characters
  janitor::make_clean_names()

# Remove header rows (1 and 2) to keep only data
df_demo <- df_demo_pre |> 
  slice(-c(1:2)) |> 
  filter(year == "2022")

# ------------------------------------------- #
#   3. Load Global Indicator Raw Dataset ----
# ------------------------------------------- #

# Read the indicators dataset (with CODE:label structure)
df_indicators_raw <- read.csv(
  here("01_rawdata", "fusion_GLOBAL_DATAFLOW_UNICEF_1.0_all.csv"),
  check.names = FALSE
) |> 
  # Remove unnecessary first column
  select(-1)  |> 
  group_by(`INDICATOR:Indicator`,`REF_AREA:Geographic area`) |>
  # Keep only the most recent time period for each area
  filter(`TIME_PERIOD:Time period` == max(`TIME_PERIOD:Time period`))

# -------------------------------------------------- #
##   3.1 Separate CODE and Label in All Columns ----
# -------------------------------------------------- #

# Function to split values into separate components
split_code_label <- function(col) {
  tibble(
    code = sub(":.*", "", col),
    label = sub(".*?:", "", col)
  )
}

# Apply the function to each column
separated <- map(df_indicators_raw, split_code_label)

# Create a cleaned dataset with only the CODE values
df_indicators <- map(separated, ~ .x$code) |> 
  bind_cols()

# Save original column names
original_names <- names(df_indicators_raw)

# Create correspondence tables (code : label) for each variable
ls_tb_corres <- imap(separated, function(tbl, var) {
  tbl |> distinct()|> 
    mutate(label = label |> 
             make_clean_names())
}) |> 
  # We add a correspondence table for column names.
  append(list(names = tibble(
    original = original_names,
    code = sub(":.*", "", original_names),
    label = sub(".*?:", "", original_names)
  )))

# Rename columns of the cleaned indicator dataset using extracted codes
colnames(df_indicators) <- ls_tb_corres$names$code


# -------------------------- #
##   3.2 Merge database ----
# -------------------------- #

# Merge demographic indicators with status and indicators datasets
df_total <- df_indicators |> 
  left_join(
    df_status,
    by = join_by(REF_AREA == iso3code)
  ) |> 
left_join(
  df_demo,
  by = join_by(
    REF_AREA == iso3_alpha_code
  )
) |>
  # Filter out rows with missing status
  filter(!is.na(status_u5mr)) |> 
  select(
    REF_AREA,
    INDICATOR,
    status_u5mr,
    group,
    TIME_PERIOD,
    OBS_VALUE,
    fertility_births_thousands,
  ) |> 
mutate(
  fertility_births_thousands = as.numeric(fertility_births_thousands),
  OBS_VALUE = as.numeric(OBS_VALUE)
)

# ----------------------------------- #
#   4. Save Cleaned Data Outputs ----
# ----------------------------------- #

write.csv(df_total, here("02_data", "interest_indicators.csv"), row.names = FALSE)

# Save correspondence tables (for later lookup of CODE -> Label)
save(
  ls_tb_corres,
  file = here("02_data", "correspondence_tables.RData")
)
