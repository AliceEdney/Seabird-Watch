# Select midday images - for bushnell images
# NOTE - this function could be adapted to select other specific times
# For example, changing t1 <- "10:00:00" and t2 <- "11:00:00" would select the 11am image 
# (C) Alice Edney

selectmidday<-function(){

metafile<-paste0(cameraname, ' metadata.csv')
datafile2<-read.table(paste0(metafolder, metafile), head=TRUE, sep=",")

datafile2$hours <- as.POSIXct(datafile2$datetime, format = "%Y:%m:%d %H:%M:%S")
datafile2$rtime1 <- round_date(datafile2$hours,unit="1 hour") # Round the time up/down to the nearest hour (so that minutes and seconds are all 00:00)

#datafile2$datetime <- paste0(substr(datafile2$datetime, 1, 17), "00") # This rounds the seconds to 00 to avoid the problems with bushnell cameras
#datafile2$datetime <- paste0(substr(datafile2$datetime, 1, 14), "00") # This rounds the minutes to 00 to avoid the problems with bushnell cameras

files<<-list.files(copydir)
l<<-length(files)

nameslist<-paste0(cameraname, sprintf("_%06d", 1:l, sep = ""))

hours <- as.POSIXct(unique(substr(datafile2$rtime1, 12,19)), format = "%H:%M:%S")
t2 <- "12:00:00"

t2 <- as.POSIXct(t2, format = "%H:%M:%S")
newhour2 <- hours[which.min(abs(t2-hours))]# need to select time closest to these hours
t2 <- substr(newhour2, 12,19)

b<-paste(copydir, nameslist, ".JPG", sep = "") 
selection2<-grep(pattern=t2, datafile2$rtime1)

selectimages<-b[c( selection2)]
selectimages<-sort(selectimages)
file.copy(from=selectimages, to=noonfolder, copy.mode = TRUE)

} 
