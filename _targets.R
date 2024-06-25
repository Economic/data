## Load your packages, e.g. library(targets).
source("./packages.R")

## Update these for a new doc push and release
### Data release version
data_release_version = "0.0.4"

# Dashboard data location
dashboard_data_path = Sys.getenv("DASHBOARD_DATA_DIR")

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

tar_plan(
  
  raw_release_files = dir_ls(dashboard_data_path),
  
  # to do: modify CSV column names
  # remove date column and replace with year and month
  # rename and revalue date_interval to time_frequency
  # maybe dimension should be group name
  # maybe dimension_value should be group value
  # indicator_name => indicator
  # measure_name => measure
  
  tar_file(csv_release_files, create_csv_release(
    raw_release_files,
    "release",
    data_release_version
  )),
  
  tar_file(binary_release, create_binary_release(
    csv_release_files,
    "release",
    "epi_swa_data_library.zip"
  )),
  
  # documentation site
  tar_parquet(
    all_stats, 
    open_dataset(csv_release_files, format = "csv") |> collect()
  ),
  tar_quarto(website, execute_params = list(meta = data_release_version), quiet = FALSE),
  
  # github releases
  #gh_version = create_new_gh_version(doc_gh_repo, database_version),
  #gh_release = pb_upload(binary_release, doc_gh_repo),

)



