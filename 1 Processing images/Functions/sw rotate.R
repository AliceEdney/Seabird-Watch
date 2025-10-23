# Select images and rotate them, save them in the _rotated folder
#(c) Alice Edney, January 2020

rotateimages <-function(){
  library(magick)  

  #choose between taking photos from '_zooniverse' or '_threeaday' folder
  rotatepath<-reduced # photos taken from zooniverse folder, which have been reduced in size, so they are same 'quality' as those shown to citizens
  #rotatepath<-selected # photos taken from zooniverse_OGsize folder, which have not been reduced in size 
  
  rotatefolder<-rotater
  samplelist<-list.files(paste0(rotatepath))

  for(i in 1:length(samplelist)) {
    image <- image_read(paste0(rotatepath, samplelist[i]))
    r = image_rotate(image, -90) # choose the angle you want to rotate the image by e.g.-90
    image_write(r, path=paste0(rotatefolder, samplelist[i]), format="jpeg")
    #plot(r)
    #print(r) # view information about the image
    #image_browse(r) # view the image in a separate window
  }
  
}
