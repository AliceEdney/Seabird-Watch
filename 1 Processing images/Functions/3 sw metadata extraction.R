# Extract metadata from reconyx and bushnell images e.g. datetime, temperature 

#install.packages("exiftoolr")
#install_exiftool()# you might need to do this if you haven't done this yet. installs ExifTool in the right place for you
#install.packages("exifr") ~you might need to use this other package


metadataextract<-function(){

  
  library("exifr")
  #library("exiftoolr")
  
#extract the metadata from each image and create a file of metadata in its own metadata folder
  samplemeta <- read_exif(b)
  istempin <-  grep("temp", colnames(samplemeta), ignore.case = TRUE, value = TRUE, fixed = FALSE)# Is temperature among the exif values?
  
  if(length(istempin)> 0){
  
  #datafile2 <<- exif_read(b, tags = c("DateTimeOriginal", "AmbientTemperature")) # Use tags to select only some data and reduce computing effort
  datafile2 <<- read_exif(b, tags = c("DateTimeOriginal", "AmbientTemperature")) # package exifr
  colnames(datafile2) <- c("imageid", "datetime", "celsius")
  }else{
    
    datafile2 <<- read_exif(b, tags = "DateTimeOriginal") # package exifr
    colnames(datafile2) <- c("imageid", "datetime")
  }

savepath<-paste0(metafolder, cameraname, " metadata.csv", sep = "")
write.csv(datafile2, savepath, row.names=FALSE) #Warnings, but working alright

#metacentral<- gsub(pattern="Timelapse/", replacement="Metadata/" , x=path)# We have a central Metadata folder at the same level as the root folder for all the pw data. You can delete this line
#write.csv(datafile2, paste0(metacentral, cameraname, " metadata.csv", sep = ""), row.names=FALSE) #Warnings, but working alright


}

