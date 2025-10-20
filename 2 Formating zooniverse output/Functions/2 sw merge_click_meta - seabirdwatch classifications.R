
###-- FUNCTION: Merge raw/consensus/goldstandard coordinate point data with metadata (i.e. datetime and temp) --### 
# (c) Alice Edney
## This codes aims to produce a spreadsheet with imageid, x and y coords for every image, datetime and temp. 
## Data required: 

merge_click_meta <- function(cluster_data, tools, meta_inputdir, site, site_save, siteyear, outputdir, datatype){
  print(site)
  # Load metadata
  meta_list <- data.frame()
  for(i in 1:length(siteyear)){
    metadata <- try(read.csv(paste0(meta_inputdir,site, "/", site, "_metadata/", siteyear[i], " metadata-CorrectedDateTime.csv"))) #This is for sites where the metadata was altered e.g. APPAa2021a, KIPPa2022a
    metadata <- try(read.csv(paste0(meta_inputdir,site, "/", site, "_metadata/", siteyear[i], " metadata-CorrectedImageId.csv"))) #This is for sites where the metadata was altered e.g. because of ImageJ processing to remove camera wobble
    if(inherits(metadata, "try-error")){
      metadata <- read.csv(paste0(meta_inputdir,site, "/", site, "_metadata/", siteyear[i], " metadata.csv"))
    }
    
    metadata$image_id <- stri_sub(metadata$imageid, -21, -1) #create new image_id column without directory
    metadata <- metadata[, -1] # remove imageid column
    meta_list <- rbind(meta_list, metadata)
    print(paste0(i, "/", length(siteyear), " metadata loaded"))
  }
  #meta_list
  
  # Merge metadata (datetime and temp) with cluster_xy 
  for(i in 1:length(cluster_data)){
    ## Select site of interest from cluster_xy
    cluster_xy <- cluster_data[[i]]
    cluster_xy$colonyname <- substr(cluster_xy$image_id, 1, 5) #select first five letters (i.e. letters 1 to 5) in 'image_id' column 
    cluster_xy_site <- cluster_xy[grep(pattern=site, x=cluster_xy$colonyname), ]
    
    ## Remove end part from image_id so it matches image_id in meta_list 
    # This is necessary if the image_end has 'crop' in it, but the code works fine for image_id without 'crop' in it too
    cluster_xy_site$imageid <- substr(cluster_xy_site$image_id, 1, 17)
    meta_list$imageid <- substr(meta_list$image_id, 1, 17)
    
    ## Merge metadata and long format data by 'image_id'
    consensus_click <- merge(cluster_xy_site, meta_list, by.x="imageid", by.y="imageid", all.x=TRUE, all.y=FALSE)
    consensus_click <- subset(consensus_click, select = -c(imageid, image_id.y))
    
    names(consensus_click)[names(consensus_click) == 'image_id.x'] <- 'image_id'
    
    # Unlist image_id column
    consensus_click$image_id <- paste0(consensus_click$image_id)
    
    # Save output
    write.csv(consensus_click, paste0(outputdir, site_save, "_", datatype, "_", tools[i], ".csv"), row.names=FALSE)
    
    ## Count number of images in the dataset
    # Number should be the same for kadult, kchick, gadult, gchick e.g. if no adult guilles in an image, then image is still included in the table but cluster_x and cluster_y are 'NA'
    print(paste0("Number of images in tool ", i, " data is ", length(unique(consensus_click$image_id))))
    
    print(paste0( i, "/", length(cluster_data), " tools complete"))
  }
}
