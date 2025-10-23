#                             ###              ###
#                    (^v^)    ##  Seabird Watch ##   (^v^)    
#                  <(     )>  ##                ## <(     )>
#                     W W     ##      code      ##    W W
#                             ###              ###



#thanks to baptiste from stack overflow
#http://stackoverflow.com/users/471093/baptiste
#Tom Hart, with original code from Robin Freeman
#Adapted and built-upon by Alice Edney

## Clear the R environment
rm(list=ls())
ls()

#
##
###

# Step 1: Preparation

###
##
#

# Photos should be in a folder with their cameraname (e.g. MITTa2018a) 
# If done manually an example of this would be C:/Seabirdwatch_Timelapse/MITTa/MITTa_raw/MITTa2018a_raw/IMG_0001.JPG
# You must also create the following folders, using MITTa as an example: MITTa_metadata, MITTa_threeaday, MITTa_renamed, MITTa_zooniverse, MITTa_goldstandard, MITTa_midday, MITTa_rotated
# NOTE - _midday, _rotated, and _goldstandard are only required if you run the last three functions (see L117-138)
# If done manually an examples of this would be:
# C:/Seabirdwatch_Timelapse/MITTa/MITTa_metadata/
# C:/Seabirdwatch_Timelapse/MITTa/MITTa_threeaday/
# C:/Seabirdwatch_Timelapse/MITTa/MITTa_renamed/
# C:/Seabirdwatch_Timelapse/MITTa/MITTa_zooniverse/
# The following script will then populate these folders with images

# Install and load necessary packages
#install_exiftool()
#install.packages('exiftoolr') #this also requires installing strawberry perl https://strawberryperl.com/
#install.packages("exifr")
library(lubridate) 
library(jpeg)
library(grid)
library(exiftoolr) 
library(exifr)
library(OpenImageR)
library(imager)
library(grid)
library(stringr)
library(magick)


#
##
###

#Step 2: Select and run the full 'process1' and 'process2' functions below until the endbracket '}'

###
##
#


process1<-function(cameras, path, codepath, value1, value2){
  
  
  for (j in 1:length(cameras)){
    
    path <<-path # <<- arrow makes these available in the global environment so they can be called by external functions
    
    value1 <<- value1
    value2 <<- value2 
    
    cameraname<<-cameras[j]
    
    print(cameraname)
    
    ## Setup folders to write images to.
    foldersetup<-paste(codepath, "sw setup folders.R", sep="")
    source(foldersetup, local = FALSE)
    setupfolders(path, cameraname)
    print(paste(cameraname, "Folder setup. TRUE"))
    
    ## Read the copy images function and copy images across to "renamed" folder
    copyallpath<-paste(codepath, "sw copyall.R", sep="") 
    source(copyallpath, local = FALSE) 
    copyall()
    print(paste(cameraname, "Images copied. TRUE"))
    
    ## Extract the metadata to a data file in the metadata folder
    metadataextractpath<-paste(codepath, "sw metadata extraction.R", sep="") #This is for reconyx and bushnell images 
    source(metadataextractpath, local = FALSE)# this pardata:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAbElEQVR4Xs2RQQrAMAgEfZgf7W9LAguybljJpR3wEse5JOL3ZObDb4x1loDhHbBOFU6i2Ddnw2KNiXcdAXygJlwE8OFVBHDgKrLgSInN4WMe9iXiqIVsTMjH7z/GhNTEibOxQswcYIWYOR/zAjBJfiXh3jZ6AAAAAElFTkSuQmCCt of the code gives Warning messages apparently with no consequences
    metadataextract()
    print(paste(cameraname, "Metadata extraction. TRUE"))#Don't worry about warning messages here
    
    ## Crop images to remove top and bottom border, ready for alignment
    bordercroppath<-paste0(codepath, "sw crop images before alignment.R", sep="") # Crop Time-lapse systems images into smaller tiles
    source(bordercroppath, local = FALSE)
    cropborder()
    print(paste(cameraname, "Border cropped. TRUE"))
    
  }
  
}


process2<-function(cameras, path, codepath, t1, t2, t3){
  
  
  for (j in 1:length(cameras)){
    
    path <<-path
    t1 <<- t1
    t2 <<- t2
    t3 <<- t3
    
    cameraname<<-cameras[j]
    
    print(cameraname)
    
    ## Setup folders to write images to.
    foldersetup<-paste(codepath, "sw setup directories.R", sep="")
    source(foldersetup, local = FALSE)
    setupfolders(path, cameraname)
    print(paste(cameraname, "Folder setup. TRUE"))
    
    ## Change metadata from _renamed to _aligned imageid
    metafile<-paste0(cameraname, ' metadata.csv')
    datafile2<-read.table(paste0(metafolder, metafile), head=TRUE, sep=",")
    datafile2$imageid <- gsub("renamed", "aligned", datafile2$imageid)
    write.csv(datafile2, paste0(metafolder, cameraname, " metadata.csv"), row.names=FALSE)
    
    ## Reduce image size and select three pictures per day 
    # run A), B), C), OR D), do not run all of them (put a # in front of the line you are not running)
    # A) Select and reduce three reconyx or time-lapse systems images
    #select3adaypath<-paste(codepath, "sw select and reduce zooniverse.R", sep="")
    # B) Select and reduce three bushnell images
    #select3adaypath<-paste(codepath, "sw select and reduce zooniverse_round minutes bushnell.R", sep="") # Round minutes down to nearest hour, for when Bushnell cameras took images at 'random' times (e.g. 11:13:12, 10:49:00, 18:17:11 will become 11:00:00, 10:00:00, 18:00:00)
    # C) Select three reconyx or time-lapse systems images but do not reduce, keep at original size
    select3adaypath<-paste(codepath, "sw select zooniverse.R", sep="") # Keep original image size and select three pictures a day
    # D) Select three bushneel images but do not reduce, keep at original size 
    #select3adaypath<-paste(codepath, "sw select zooniverse_round minutes bushnell.R", sep="") # Keep original image size and select three pictures a day; Round minutes down to nearest hour, for when Bushnell cameras took images at 'random' times (e.g. 11:13:12, 10:49:00, 18:17:11 will become 11:00:00, 10:00:00, 18:00:00)
    
    source(select3adaypath, local = FALSE)
    selectreducezooniverse()
    print(paste(cameraname, "Three a day selected. TRUE"))
    
    # The following lines of code are not essential, but can be unhashed if you would like to either:
    # select midday images, randomly select a subset of images, rotate images e.g. if they are upside down
    
    ## Automatically select midday images
    # run A) OR B), do not run both (put a # in front of the line you are not running)
    # A) Select the midday images for reconyx or time-lapse systems cameras
    #selectmiddaypath<-paste(codepath, "sw select midday.R", sep="")
    # B) Select the midday images for bushnell cameras
    #selectmiddaypath<-paste(codepath, "sw select midday_round minutes bushnell.R", sep="") # Round minutes down to nearest hour, for when Bushnell cameras took images at 'random' times (e.g. 11:13:12, 10:49:00, 18:17:11 will become 11:00:00, 10:00:00, 18:00:00)
    
    #source(selectmiddaypath, local = FALSE)
    #selectmidday()
    #print(paste(cameraname, "Midday img selected. TRUE"))
    #print(paste0("Cameras completed:",j, "/", length(cameras)))
    
    ## Randomly select photos from zooniverse folder to be 'gold standard'
    #selectgoldstandardpath<-paste(codepath, "sw gold standard selection.R", sep="")
    #source(selectgoldstandardpath, local=FALSE)
    #selectgoldstandard()
    #print(paste(cameraname, "Gold standard selected. TRUE. Cameras completed:" ,j, "/", length(cameras)))
    
    ## Rotate images in zooniverse folder to correct orientation
    # NOTE - you can choose whether to rotate reduced images from the _zooniverse folder or original size images from _zooniverseOGsize folder by going into the function and changing the selected folder
    #selectrotatepath<-paste(codepath, "sw rotate.R", sep="")
    #source(selectrotatepath, local=FALSE)
    #rotateimages()
    #print(paste(cameraname, "Images rotated. TRUE. Cameras completed:" ,j, "/", length(cameras)))
    
  }
  
}


#
##
###

#Step 3: Using the functions
###
##
#

#Arguments in the functions:
# 'cameras': This argument should be a list of camera names to process. For example: c("AITCb2017a", "GASTa2018b", "ROOKa2018a")
# 'path': should be the address of the Seabird Watch Timelapse folder that contains all folder structure. For example: F:/Seabird Watch Timelapse/
# 'codepath': This is the location of the .R files where the code for the necessary functions is stored. For example C:/R code/Functions/
# 'value1' and 'value2' define how much of the bottom and top of the image to crop, in order to remove the black border; this is necessary for alignment and will vary based on image size
# 't1', 't2' and 't3' are the three hours at which we are retrieving photos in order to upload to the Zooniverse. Input format: "11:00:00"

#Warnings
# The 'process1' and 'process2' functions in this script are going to call functions from other scripts, make sure the .R code file names inside the process function are correct and you are using the latest version. 
# Make sure you end both the path and codepath arguments in a forward slash '/'

#Usage
# 1) Run process1
# 2) Remove images that are too dark or blurry from _renamed folder, as these could affect the alignment 
# 2) Align your _renamed folder of images and save output in _aligned folder e.g. using ImageJ, see Appendix of Merkel et al. 2016 for an example (https://doi.org/10.1111/jofo.12143)
# 3) Run process2 

#Example:
#process(cameras = c("APPAa2017a", "KIPPa2016a"),
#        path = "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/Seabird Watch Timelapse/", 
#        codepath = "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/1 Processing images/Process_v3/")

process1(cameras = c("BERNa2023a"),
        path = "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/Seabird Watch Timelapse/", 
        codepath = "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/1 Processing images/Functions/",
        value1 = "2048x1440+0+35",
        value2 = "2048x1370")

## You MUST align the images and save them in the _aligned folder, before running process2

process2(cameras = c("BERNa2023a"),
        path = "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/Seabird Watch Timelapse/", 
        codepath = "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/1 Processing images/Functions/",
        t1 = "08:00:00",
        t2 = "12:00:00",
        t3 = "20:00:00")

# Most errors & warnings can be ignored
# Check the folders where you expect images to be saved, to see if the code has worked!

#
##
###

#Step 4: Upload the images to Zooniverse. Once the script has finished running pictures should be ready to use in the folder named zooniverse or threeaday, depending on whether images were reduced or kept at orignal size
###
##
#


