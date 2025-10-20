#create a list of files to copy and copy them across to copydir
copyall<-function(){
  
filestocopy <- list.files(origindir)

movelist <- paste(origindir, filestocopy, sep='')
file.copy(from=movelist, to=copydir, copy.mode = TRUE)

#step 2 run the rename script, which should automatically rename to the camera unique id.
#tip - don't look in this folder while this is running- it can cause one or two to miss. Wierd, but that's life.
files<<-list.files(copydir)
l<<-length(files)
a <- paste(copydir, files, sep='')
nameslist<<-paste0(cameraname, sprintf("_%06d", 1:l, sep = "")) # takes all six characters following an underscore in the file name
b<<-paste(copydir, nameslist, ".JPG", sep = "") 
file.rename(a, b)
}
