# Select three images per day and reduce in size - for reconyx and time-lapse systems images

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




#Reduce selected images

library("OpenImageR")
require("grid")
destlist<- gsub(pattern="_renamed/", replacement="_zooniverse/" , x=selecteddf)

for(i in 1:length(selecteddf)) {

  currpic<-readImage(selecteddf[i], native=TRUE)
  dims<-dim(currpic)          ## calculate the dimensions of currpic      
  aspect<-round(dims[1]/dims[2],4)     ## calculate the aspect ratio of currpic
  
  
  jpeg(paste(destlist[i]), width = 1000, height = 1000*aspect) 
  grid.raster(currpic, width=unit(1,"npc"), height=unit(1,"npc"))
  dev.off() 
  
}

}

}


