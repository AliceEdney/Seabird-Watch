## Create new metadata file for cropped images, because the imageid has changed 
# (C) Alice Edney

newmetadata<- function(){
  
  colonyname <- substr(cameraname, 1,5)
  
  metafile<-read.csv(paste0(path, colonyname, "/", colonyname, "_metadata", "/", cameraname, ' metadata.csv'))
  # Remove .JPG from end of string
  metafile$imageid <- str_sub(metafile$imageid,-140,-5)
  # Paste new ending to the imageid
  metafile$imageid <- paste0(metafile$imageid, "_", saveim, ".jpg") 
  # Save new metadata 
  write.csv(metafile, paste0(path, colonyname, "/", colonyname, "_metadata", "/", cameraname, ' metadata_', saveim, '.csv'), row.names=FALSE)
}

