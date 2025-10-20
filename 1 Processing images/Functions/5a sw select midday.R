# Select midday images - for reconyx and time-lapse systems images
# NOTE - this function could be adapted to select other specific times
# For example, changing t1 <- "10:00:00" and t2 <- "11:00:00" would select the 11am image 

selectmidday<-function(){

metafile<-paste0(cameraname, ' metadata.csv')
datafile2<-read.table(paste0(metafolder, metafile), head=TRUE, sep=",")

files<<-list.files(copydir)
l<<-length(files)

nameslist<-paste0(cameraname, sprintf("_%06d", 1:l, sep = ""))

hours <- as.POSIXct(unique(substr(datafile2$datetime, 12,19)), format = "%H:%M:%S")
t1 <- "11:00:00"
t2 <- "12:00:00"

t1 <- as.POSIXct(t1, format = "%H:%M:%S")
newhour1 <- hours[which.min(abs(t1-hours))]# need to select time closest to these hours
t1 <- substr(newhour1, 12,19)

t2 <- as.POSIXct(t2, format = "%H:%M:%S")
newhour2 <- hours[which.min(abs(t2-hours))]# need to select time closest to these hours

while (abs(newhour1 - newhour2) < 1){
  
  t2 <- t2 + 1*3600
  newhour2 <- hours[which.min(abs(t2-hours))]# need to select time closest to these hours
  
}

t2 <- substr(newhour2, 12,19)

b<-paste(copydir, nameslist, ".JPG", sep = "") 
selection2<-grep(pattern=t2, datafile2$datetime)

selectimages<-b[c( selection2)]
selectimages<-sort(selectimages)
file.copy(from=selectimages, to=noonfolder, copy.mode = TRUE)

} 
