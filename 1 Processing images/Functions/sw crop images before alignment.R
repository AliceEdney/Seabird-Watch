# Select three images and crop to produce many smaller images
# (C) Alice Edney

cropborder<-function(){

  
metafile<-paste0(cameraname, ' metadata.csv')
datafile2<-read.table(paste0(metafolder, metafile), head=TRUE, sep=",")

datafile2$datetime <- paste0(substr(datafile2$datetime, 1, 17), "00") # This rounds the seconds to 00 to avoid the problems with bushnell cameras

selecteddf<-as.character(datafile2$imageid, datafile2$datetime)


#Crop selected images
require("OpenImageR")
require("imager")
require("jpeg")
require("grid")
require("stringr")
require("magick")

destlist<- gsub(pattern="_renamed/", replacement="_cropped/" , x=selecteddf)

for(i in 1:length(selecteddf)) {
  currpic <- image_read(selecteddf[i])
  imagename <- str_sub(selecteddf[i],-21,-5)
  #image_info(currpic)
  crop <- image_crop(currpic, value1)
  #plot(crop)
  #image_info(crop)
  crop1 <- image_crop(crop, value2)
  #plot(crop1)
  image_write(crop1, path = paste0(cropfolder, imagename,".jpg"), format="jpg")

}

}




