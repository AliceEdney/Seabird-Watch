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
  unique(data_nocrop$cam_id)
  
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
  unique(data_crop$cam_id)
  

  ## Check that data_crop and data_nocrop include all data in original dataframe
  if (nrow(data_crop) + nrow(data_nocrop) == nrow(data)) {
    print("All metadata included")
  } else {
    print("Some metadata have not been accounted for")
  } 
  
  data <- rbind(data_nocrop, data_crop)
  
  # Check that cam_id follows the required structure e.g. MITTa2016a
  unique(data$cam_id) 
  
  # Some of the data is example data from when Seabird Watch was set-up an can be removed
  # Example data that can be removed, KAPP_2018, OSSI_2018pt1, SKOM_2018a is SKOMd2018a, SKOM_2018b is SKOMd2018b, SKOM_2018c is SKOMd2018c
  # Remove example data 
  data<- data[-grep(pattern='Example', x=data$metadata), ] 

  # Some of the images were incorrectly named when uploading to Seabird Watch and so need further processing to extract image_id
  # For example:
  #d/SKOMd201 should be SKOMd2017b
  #d/SKOMd201 should be SKOMd2017b
  
  ## Convert incorrect cam and image_ids to required structure 
  # OSSI_2018pt1 on zooniverse is exactly the same as OSSIa2018a on server 
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data, function(x) {
    gsub("SI_2018pt1", "OSSIa2018a", x)
  }))
  
  # OSSI_2018pt2_000016 to OSSI_2018pt2_001952 on zooniverse matches OSSIa2017b_0000016 to OSSIa2017b_001952 on server
  # OSSI_2018pt2_001969 to OSSI_2018pt2_003904 on zooniverse are just repeats of images already uploaded
  # e.g OSSI_2018pt2_001969 on zooniverse is the same as OSSIa2018a_000017 on server
  # --> need to delete OSSI_2018pt2 images from OSSI_2018pt2_001969 to OSSI_2018pt2_003904
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("SI_2018pt2", "OSSIa2017b", x)
  }))
  
  delete <- list()
  j = 1
  for(i in 1969:3904){
    delete[j] <- paste0("OSSIa2017b_00", i, ".JPG")
    j = j + 1
  }
  
  for(i in 1:length(1969:3904)){
    data_correct <- subset(data_correct, data_correct$image_id != delete[i])
  }
  
  # KAPP_2018_000001 to KAPP_2018_000285 on zooniverse matches KAPWa2018_000001 to KAPWa2018a_000295 on server
  # KAPP_2018_000300 to KAPP_2018_000575 on zooniverse are just repeats of images already uploaded
  # e.g KAPP_2018_000300 on zooniverse is the same as KAPWa2018a_000010 on server
  # --> need to delete KAPP_2018 images from KAPP_2018_000300 to KAPP_2018_000575
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("\"KAPP_2018", "KAPWa2018a", x)
  }))
  
  delete <- list()
  j = 1
  for(i in 300:575){
    delete[j] <- paste0("KAPWa2018a_000", i, ".JPG")
    j = j + 1
  }
  
  for(i in 1:length(300:575)){
    data_correct <- subset(data_correct, data_correct$image_id != delete[i])
  }
  
  # SKOM_2018a on zooniverse is exactly the same as SKOMd2018a on server 
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("SKOM_2018a", "SKOMd2018a", x)
  }))
  
  # SKOM_2018b on zooniverse is exactly the same as SKOMd2018b on server 
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("SKOM_2018b", "SKOMd2018b", x)
  }))

  # SKOM_2018c on zooniverse is the same as SKOMd2018c on server from SKOMd2018c_000001 to SKOMd2018c_000236
  # THEN SKOM_2018c_000236 on zooniverse matches SKOMd2018c_000253 on server
  # Zooniverse 230 to 669 are all 17 'out' compared to server --> need to add 17 to zooniverse image_id number
  # Zooniverse 675 to 797 are all 34 'out' compared to server --> need to add 34 to zooniverse image_id number
  # Zooniverse 807 to 839 are all 54 'out' compared to server --> need to add 54 to zooniverse image_id number
  
  # zooniverse == server
  #230 == 230
  #236 == 253 --> +17 
  #up to 669 == 686 --> +17
  #675 == 709 --> +34 
  #up to 797 == 831 --> +34
  #807 == 861 --> +54 
  #up to 839 == 893 --> +54
  
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("SKOM_2018c", "SKOMd2018c", x)
  }))
  
  #subset SKOMd2018c data and alter image_id so zooniverse image_id matches server image_id
  skomd <- data_correct[grep(pattern="SKOMd2018c", x=data_correct$image_id), ]
  skomd$num <- str_sub(skomd$image_id, 15, 17)
  skomd$num <- as.numeric(skomd$num)
  skomd$num2 <- ifelse(skomd$num < 236, skomd$num, skomd$num + 17)
  skomd$num3 <- ifelse(skomd$num > 669, skomd$num2 + 17, skomd$num2)
  skomd$num4 <- ifelse(skomd$num > 797, skomd$num3 + 20, skomd$num3)
  
  skomd$image_id1 <- paste0("SKOMd2018c_000", skomd$num4, ".JPG")
  skomd$image_id <- ifelse(skomd$num4 < 236, skomd$image_id, skomd$image_id1)
  skomd <- dplyr::select(skomd, -num, -num2, -num3, -num4, -image_id1) #remove columns that were added during calculations

  #remove SKOMd2018c from data_correct
  data_correct <- data_correct[!grepl(pattern="SKOMd2018c", x=data_correct$image_id), ]
  
  #append SKOMd2018c to data_correct 
  data_correct <- rbind(data_correct, skomd)
  
  # SKOMd2017b images on zooniverse are missing '00' at the start of the image name
  data_correct <- data.frame(stringsAsFactors=FALSE, lapply(data_correct, function(x) {
    gsub("d/SKOMd2017b_", "SKOMd2017b_00", x)
  }))
  
  # Replace cam_id column based on correct image_ids 
  data_correct$cam_id <- str_sub(data_correct$image_id, start=1, end=10)
  
  # Check all cam_ids are correct
  print(unique(data_correct$cam_id))
  # There are 3 incorrect cam_ids, but they do not correspond to data required by current projects, so ignore these
  # "me\":\"BROSa", "\":\"BRNSa20", "lename\":\"R"
  
  data_correct <- as.data.frame(data_correct)
  return(data_correct)
}

