create_csv_release <- function(files, output_dir, data_version) {
  
  files <- files |>
    map(~ write_single_indicator_file(.x, output_dir, data_version)) |>
    unlist()

  files
}


write_single_indicator_file <- function(input_file, output_dir, data_version) {
  data = read_parquet(input_file) |> 
    mutate(data_version = as.character(data_version), .before = batch_id) |> 
    select(-batch_id) 
  
  indicator_name = data |> 
    filter(row_number() == 1) |> 
    pull(starts_with("indicator")) |> 
    make_clean_names()
    
  output_file_name = paste0(indicator_name, ".csv")
  
  output_file = file.path(output_dir, output_file_name)
  
  write_csv(data, output_file)
  
  output_file
}

create_binary_release <- function(files, output_dir, zip_file) {
  
  final_zip <- file.path(output_dir, zip_file)
  
  zip(final_zip, files, mode = "cherry-pick")
  
  final_zip
}

