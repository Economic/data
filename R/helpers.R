create_csv_release <- function(files, output_dir, data_version) {
  
  check_batch_id_equal(files)
  
  files <- files |> 
    map(~ write_single_indicator_file(.x, output_dir, data_version)) |> 
    unlist()
  
  files 
}

check_batch_id_equal <- function(files) {
  dataset = open_dataset(files) 
  
  # some problem with the meta data I don't understand
  # going to silence for now
  suppressWarnings({
    number_batch_ids = dataset |> 
      select(batch_id) |> 
      collect() |> 
      pull(batch_id) |> 
      unique() |> 
      length()
  })

  
  stopifnot(number_batch_ids == 1)
}

write_single_indicator_file <- function(input_file, output_dir, data_version) {
  data = read_parquet(input_file) |> 
    mutate(data_version = data_version, .before = batch_id) |> 
    select(-batch_id) 
  
  indicator_name = data |> 
    filter(row_number() == 1) |> 
    pull(indicator_name) |> 
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


create_new_gh_version <- function(repo, version_number) {
  pb_release_create(repo = repo, paste0("v", version_number))
  
  version_number
}

upload_gh_release_files <- function(repo, files) {
  files |> 
    walk(~ pb_upload(.x, repo = repo))
}