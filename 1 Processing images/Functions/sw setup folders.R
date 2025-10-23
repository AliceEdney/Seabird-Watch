# Set-up folders for images to be saved in
setupfolders<-function(path, cameraname){

  
  colonyname <- substr(cameraname, 1,5)
  colonyyear <- substr(cameraname, 1,9)
  
 
  #step 1: create new directories for each camera.

  origindir<<-paste0(path, colonyname, "/", colonyname, "_raw", "/", cameraname, "_raw/", sep = "")
  
  copydir<<-paste0(path, colonyname, "/", colonyname, "_renamed", "/", cameraname, "_renamed/", sep = "")
  dir.create(path=copydir, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  metafolder<<-paste0(path, colonyname, "/", colonyname, "_metadata", "/", sep = "")
  #dir.create(path=metafolder, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  reduced<<-paste0(path, colonyname, "/", colonyname, "_zooniverse", "/", cameraname, "_zooniverse/", sep = "") 
  dir.create(path=reduced, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  selected <<-paste0(path, colonyname, "/", colonyname, "_threeaday", "/", cameraname, "_zooniverse_OGsize/", sep = "") 
  dir.create(path=selected, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  noonfolder<<-paste0(path, colonyname, "/", colonyname, "_midday", "/", cameraname, "_midday/", sep = "")
  dir.create(path=noonfolder, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  gold<<-paste0(path, colonyname, "/", colonyname, "_goldstandard", "/", cameraname, "_goldstandard/", sep = "")
  dir.create(path=gold, showWarnings = TRUE, recursive = FALSE, mode = "0777")
 
  rotater<<-paste0(path, colonyname, "/", colonyname, "_rotated", "/", cameraname, "_rotated/", sep = "")
  dir.create(path=rotater, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  cropfolder<<-paste0(path, colonyname, "/", colonyname, "_cropped", "/", cameraname, "_cropped/", sep = "")
  dir.create(path=cropfolder, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  alignedfolder<<-paste0(path, colonyname, "/", colonyname, "_aligned", "/", cameraname, "_aligned/", sep = "")
  dir.create(path=alignedfolder, showWarnings = TRUE, recursive = FALSE, mode = "0777")
  
  
  }



