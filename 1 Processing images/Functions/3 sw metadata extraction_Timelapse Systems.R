# Extract metadata from time-lapse systems images e.g. datatime, temperature
# (C) Alice Edney

metadataextract<-function(){
  # Get raw file names and renamed filenames
  original_files<-data.frame(list.files(origindir, full.names = TRUE))
  renamed_files <-data.frame(list.files(copydir, full.names = TRUE))
  datafile1 <- cbind(renamed_files, original_files)
  
  # Raw file names have the datetime in them, so need to extract datetime from the raw filename
  colnames(datafile1) <- c("imageid", "datetime")
  #Change datetime format so it matches reconyx and bushnell datetime
  datafile1$datetime <- gsub("-", ":", datafile1$datetime)
  datafile1$datetime <- gsub("_", " ", datafile1$datetime)
  
  # extract datetime from string using str_sub function
  library(stringr)
  datafile1$datetime <- str_sub(datafile1$datetime,-23,-5)
  datafile2 <- datafile1
  
  savepath<-paste0(metafolder, cameraname, " metadata.csv", sep = "")
  write.csv(datafile2, savepath, row.names=FALSE) #Warnings, but working alright

}

