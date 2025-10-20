#                             ###              ###
#                    (^v^)    ##  Seabird Watch ##   (^v^)    
#                  <(     )>  ##                ## <(     )>
#                     W W     ##      code      ##    W W
#                             ###              ###



#thanks to baptiste from stack overflow
#http://stackoverflow.com/users/471093/baptiste
#Tom Hart, with original code from Robin Freeman
#Adapted and built-upon by Alice Edney

## clear the R environment
rm(list=ls())
ls()

#
##
###

#Step 1: Preparation

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

# Install jpeg, grid and exiftoolr packages
#install.packages('jpeg')
#install.packages('grid')
#install_exiftool()
#install.packages('exiftoolr') #this also requires installing strawberry perl https://strawberryperl.com/
#install.packages("exifr")

library(lubridate) 
library(jpeg)
library(grid)
library(exiftoolr)
library(exifr)


#
##
###

#Step 2: Select and run the full 'process' function below until the endbracket '}'

###
##
#


process<-function(cameras, path, codepath, t1, t2, t3, top, bottom, left, right, saveim){
  
  
  for (j in 1:length(cameras)){
    
    path <<-path
    t1 <<- t1
    t2 <<- t2
    t3 <<- t3
    top <<- top
    bottom <<- bottom
    left <<- left
    right <<- right
    saveim <<- saveim
    
    cameraname<<-cameras[j]
    
    print(cameraname)
    
    ## 1) Setup folders to write images to.
    foldersetup<-paste(codepath, "1 sw setup folders_Timelapse Systems.R", sep="")
    source(foldersetup, local = FALSE)
    setupfolders(path, cameraname)
    print(paste(cameraname, "Folder setup. TRUE"))
    
    ## 2) Read the copy images function and copy images across to "renamed" folder
    copyallpath<-paste(codepath, "2 sw copyall.R", sep="") 
    source(copyallpath, local = FALSE) 
    copyall()
    print(paste(cameraname, "Images copied. TRUE"))
    
    ## 3) Extract the metadata to a data file in the zooniverse folder
    metadataextractpath<-paste(codepath, "3 sw metadata extraction_Timelapse Systems.R", sep="") #This is for time-lapse systems images which do not have datetime and celsius stored as metadata
    source(metadataextractpath, local = FALSE)# this part of the code gives Warning messages apparently with no consequences
    metadataextract()
    print(paste(cameraname, "Metadata extraction. TRUE"))#Don't worry about warning messages here
    
    ## 4) Select three pictures per day and crop, to produce many smaller images 
    select3adaypath<-paste0(codepath, "/4 sw select and crop zooniverse_Timelapse Systems.R", sep="") # Crop Time-lapse systems images into smaller tiles
    source(select3adaypath, local = FALSE)
    selectreducezooniverse()
    print(paste(cameraname, "Three a day selected. TRUE"))
    
    ## 8) Create new metadata file with updated imageids, to reflect new cropped images 
    croppedmetadatapath<-paste(codepath, "/8 sw new metadata for cropped images_Timelapse Systems.R", sep="")
    source(croppedmetadatapath, local=FALSE)
    newmetadata()
    print(paste(cameraname, "New metadata created. TRUE. Cameras completed:" ,j, "/", length(cameras)))
    
    # The following lines of code are not essential, but can be unhashed if you would like to either:
    # select midday images, randomly select a subset of images, rotate images e.g. if they are upside down
    
    ## 5) Automatically select midday images
    # 5A) Select the midday images for reconyx or time-lapse systems cameras
    #selectmiddaypath<-paste(codepath, "5a sw select midday.R", sep="")
    #source(selectmiddaypath, local = FALSE)
    #selectmidday()
    #print(paste(cameraname, "Midday img selected. TRUE"))
    #print(paste0("Cameras completed:",j, "/", length(cameras)))
    
    ## 6) Randomly select photos from zooniverse folder to be 'gold standard'
    #selectgoldstandardpath<-paste(codepath, "/6 sw gold standard selection.R", sep="")
    #source(selectgoldstandardpath, local=FALSE)
    #selectgoldstandard()
    #print(paste(cameraname, "Gold standard selected. TRUE. Cameras completed:" ,j, "/", length(cameras)))
    
    ## 7) Rotate images in zooniverse folder to correct orientation
    # NOTE - you can choose whether to rotate reduced images from the _zooniverse folder or original size images from _zooniverseOGsize folder by going into the function and changing the selected folder
    #selectrotatepath<-paste(codepath, "/7 sw rotate.R", sep="")
    #source(selectrotatepath, local=FALSE)
    #rotateimages()
    #print(paste(cameraname, "Images rotated. TRUE. Cameras completed:" ,j, "/", length(cameras)))
    
  }
  
}


#
##
###

#Step 3: Using the function
###
##
#

#Arguments in the function:
# 'cameras': This argument should be a list of camera names to process. For example: c("AITCb2017a", "GASTa2018b", "ROOKa2018a")
# 'path': should be the address of the Seabird Watch Timelapse folder that contains all folder structure. For example: F:/Seabird Watch Timelapse/
# 'codepath': This is the location of the .R files where the code for the necessary functions is stored. For example C:/R code/Functions/
# 't1', 't2' and 't3' are the three hours at which we are retrieving photos in order to upload to the Zooniverse. Input format: "11:00:00"
# 'top', 'bottom', 'left', and 'right' 

#Warnings
# The 'process' function in this script is going to call functions from other scripts, make sure the .R code file names inside the process function are correct and you are using the latest version. 
# Make sure you end both the path and codepath arguments in a forward slash '/'
# Write the three hours in chronological order ( t1 sooner than t2 and t2 sooner than  t3)


#Example:

process(cameras = c("FOWLa2022e"),
        path = "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/Seabird Watch Timelapse/", 
        codepath = "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/1 Processing images/Functions/",
        t1 = "08:00:00",
        t2 = "13:00:00",
        t3 = "20:00:00",
        top = 1,
        bottom = 1600,
        left= 1550, 
        right= 3825,
        saveim="crop1")

#
##
###


#Step 4: Upload the images to Zooniverse. Once the script has finished running pictures should be ready to use in the folder named zooniverse
###
##
#

