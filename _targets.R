## Load your packages, e.g. library(targets).
source("./packages.R")

## Update these for a new doc push and release
### Data release version
data_release_version = "2025.4.16"

# Dashboard data location
dashboard_data_path = Sys.getenv("DASHBOARD_DATA_DIR")
raw_release_files = dir_ls(dashboard_data_path)

## Load your R files
lapply(list.files("./R", full.names = TRUE), source)

tar_assign({
  
  csv_release_files = create_csv_release(
    raw_release_files,
    "release",
    data_release_version
  ) |> 
    tar_file()
  
  binary_release = create_binary_release(
    csv_release_files,
    "release",
    "epi_swa_data_library.zip"
  ) |> 
    tar_file()
  
  all_data = read_csv(
    csv_release_files, 
    show_col_types = FALSE, 
    guess_max = 10000
  ) |> 
    tar_parquet()

  # documentation site
  website = tar_quarto(quiet = FALSE)
})



