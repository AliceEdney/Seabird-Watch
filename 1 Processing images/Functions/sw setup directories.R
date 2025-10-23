# Set-up folders for images to be saved in
setupfolders<-function(path, cameraname){

  
  colonyname <- substr(cameraname, 1,5)
  colonyyear <- substr(cameraname, 1,9)
  
 
  #step 1: create new directories for each camera.

  origindir<<-paste0(path, colonyname, "/", colonyname, "_raw", "/", cameraname, "_raw/", sep = "")
  
  metafolder<<-paste0(path, colonyname, "/", colonyname, "_metadata", "/", sep = "")

  reduced<<-paste0(path, colonyname, "/", colonyname, "_zooniverse", "/", cameraname, "_zooniverse/", sep = "") 

  selected <<-paste0(path, colonyname, "/", colonyname, "_threeaday", "/", cameraname, "_zooniverse_OGsize/", sep = "") 
  
  noonfolder<<-paste0(path, colonyname, "/", colonyname, "_midday", "/", cameraname, "_midday/", sep = "")

  gold<<-paste0(path, colonyname, "/", colonyname, "_goldstandard", "/", cameraname, "_goldstandard/", sep = "")

  rotater<<-paste0(path, colonyname, "/", colonyname, "_rotated", "/", cameraname, "_rotated/", sep = "")

  cropfolder<<-paste0(path, colonyname, "/", colonyname, "_cropped", "/", cameraname, "_cropped/", sep = "")

  copydir<<-paste0(path, colonyname, "/", colonyname, "_aligned", "/", cameraname, "_aligned/", sep = "")

  }



