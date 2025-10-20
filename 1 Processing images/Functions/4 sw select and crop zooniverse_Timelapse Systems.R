# Select three images and crop to produce many smaller images
# (C) Alice Edney

selectreducezooniverse<-function(){

  
metafile<-paste0(cameraname, ' metadata.csv')
datafile2<-read.table(paste0(metafolder, metafile), head=TRUE, sep=",")

datafile2$datetime <- paste0(substr(datafile2$datetime, 1, 17), "00") # This rounds the seconds to 00 to avoid the problems with bushnell cameras

l<-nrow(datafile2)

if(l >= 3){# to avoid an error when there is too little data



hours <- as.POSIXct(unique(substr(datafile2$datetime, 12,19)), format = "%H:%M:%S")


t1 <- as.POSIXct(t1, format = "%H:%M:%S")
newhour1 <- hours[which.min(abs(t1-hours))]# need to select time closest to these hours
hours2 <- hours[-which.min(abs(t1-hours))] # create a new 'hours' list, removing the hours already selected for newhour1

t1 <- substr(newhour1, 12,19)




t2 <- as.POSIXct(t2, format = "%H:%M:%S")
newhour2 <- hours2[which.min(abs(t2-hours2))]# need to select time closest to these hours
hours3 <- hours2[-which.min(abs(t2-hours2))] # create a new 'hours' list, removing the hours already selected for newhour2
t2 <- substr(newhour2, 12,19)



t3 <- as.POSIXct(t3, format = "%H:%M:%S")
newhour3 <- hours3[which.min(abs(t3-hours3))]# need to select time closest to these hours
t3 <- substr(newhour3, 12,19)


selecteddf<-as.character(datafile2$imageid[grep(pattern = paste(t1, t2, t3, sep = "|"), datafile2$datetime)])


#Crop selected images
library("OpenImageR")
library("jpeg")
require("grid")
destlist<- gsub(pattern="_renamed/", replacement="_cropped/" , x=selecteddf)

for(i in 1:length(selecteddf)) {

  currpic<- readImage(selecteddf[i])
  imagename <- str_sub(selecteddf[i],-21,-5)
  crop <- cropImage(currpic, new_width = top:bottom, new_height = left:right, type = 'user_defined')
  writeImage(crop, file_name = paste0(cropfolder, imagename, "_", saveim,".jpg"))

}

}

}

