extract_imageid_rawclicks <- function(data){
  ## Extract image_id from metadata column
  
  ## 1) For image names without 'crop' in them
  # This relies on the image names always being the same format: 17 characters long, before the .JPG, .jpg etc
  # e.g. MITTa2015a_007322.JPG has 17 characters before .JPG
  
  data_nocrop <- data[!grepl("crop", data$metadata),]
  
  # Extract image_id for images ending with .JPG or .jpg
  extract_nocrop <- function(x) {
    # Find all matches of 17 chars + .jpg or .JPG, case-insensitive
    matches <- regmatches(x, gregexpr(".{17}\\.jpg", x, ignore.case = TRUE))[[1]]
    unique_match <- unique(matches)
    if(length(unique_match) > 0) unique_match[1] else NA
  }
  
  data_nocrop$image_id <- sapply(data_nocrop$metadata, extract_nocrop)
  # Extract cam_id
  data_nocrop$cam_id <- str_sub(data_nocrop$image_id, end=-12)
  #unique(data_nocrop$cam_id)
  
  ## 2) For image names with 'crop' in them
  # This relies on the image names always being the same format: 23 characters long, before the .JPG, .jpg etc
  # e.g. FOWLa2022a_007322_crop1.JPG has 23 characters before .jpg
  
  data_crop <- data[grepl("crop", data$metadata),]
  
  # Extract image_id for images ending with .JPG or .jpg
  extract_crop <- function(x) {
    # Find all matches of 17 chars + .jpg or .JPG, case-insensitive
    matches <- regmatches(x, gregexpr(".{23}\\.jpg", x, ignore.case = TRUE))[[1]]
    unique_match <- unique(matches)
    if(length(unique_match) > 0) unique_match[1] else NA
  }
  
  data_crop$image_id <- sapply(data_crop$metadata, extract_crop)
  # Extract cam_id
  data_crop$cam_id <- str_sub(data_crop$image_id, end=-18)
  #unique(data_crop$cam_id)
  
  
  ## Check that data_crop and data_nocrop include all data in original dataframe
  if (nrow(data_crop) + nrow(data_nocrop) == nrow(data)) {
    print("All metadata included")
  } else {
    print("Some metadata have not been accounted for")
  } 
  
  data <- rbind(data_nocrop, data_crop)
  
  # Check that cam_id follows the required structure e.g. MITTa2016a
  unique(data$cam_id) 
  
  data <- as.data.frame(data)
  return(data)
}

