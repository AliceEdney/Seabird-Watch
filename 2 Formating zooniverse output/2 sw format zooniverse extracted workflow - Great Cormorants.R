## Convert to long format data like seabird watch citsci data ##  
# (C) Original from Alice Edney

## clear the R environment
rm(list=ls())
ls()

## set working directory
indir <- #insert directory where csvs downloaded from Seabird Watch are saved
meta_indir <- #insert directory where metadata associated with images is saved (should be stored in a folder labelled 'metadata' with the images)
outdir <- #insert directory where output will be saved
codepath <- #insert directory where external functions needed to run this script are saved
  
meta_indir <- "D:/1_University_of_Oxford/Seabird_Watch/1_Data/Seabirdwatch_Timelapse/Version_2/" 
indir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/1 Raw classifications/"
outdir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/2 Processed classifications/Great Cormorants/"
codepath <- "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/2 Formating zooniverse output/Functions/"

## set source of external functions
source(paste0(codepath, "2 sw extract_imageid - seabirdwatch classifications.R"), local = FALSE)
source(paste0(codepath, "2 sw extract xy coordinates - seabirdwatch classifications.R"), local = FALSE)
source(paste0(codepath, "2 sw merge_click_meta - seabirdwatch classifications.R"), local = FALSE)

## libraries 
library(tidyr)
library(stringi)
library(stringr)
library(dplyr)
library(splitstackshape) #for text-col (splitting 'annotations' column by '{')

## Read in data 
sw_classifications <- read.csv(paste0(indir, "seabirdwatch-classifications.csv"), header = TRUE, sep =",")

## Select workflow required
unique(sw_classifications$workflow_name)

## --- This code is for extracting x,y coordinates from 'Great Cormorants Best on the Nest' workflow only 
sw_class <- sw_classifications[grep("Great Cormorants", sw_classifications$workflow_name), ] 
rm(sw_classifications)

##---------------
## NOTE: ## Need to separate 'annotations' column by '{', so there is one x,y coord pair per column
# There are two methods:

#--- METHOD 1: Use EXCEL
# Export to csv and use 'text to column' tool in Excel to separate 'annotations' column by '{' 
#write.csv(sw_class, paste0(indir, "cormorant-classifications_text-col.csv"))
#sw_class <- read.csv(paste0(indir, "cormorant-classifications_text-col.csv"), header = TRUE, sep =",")

#--- METHOD 2: Use 'splitstackshape' R package 
sw_class <- cSplit(sw_class, splitCols = "annotations", sep="}", direction="long", type.convert=FALSE)
##---------------

## Select data for each tool 
#-- Adult tool 
# select any row with 'Adult' in annotations column
adult <- sw_class[grep(pattern="Adult", x=sw_class$annotations),]

#-- Chick tool 
# select any row with 'Adult' in annotations column
chick <- sw_class[grep(pattern="Chick", x=sw_class$annotations),]

#-- Egg tool 
# select any row with 'Adult' in annotations column
egg <- sw_class[grep(pattern="Egg", x=sw_class$annotations),]

#-- Other tool 
# select any row with 'Adult' in annotations column
other <- sw_class[grep(pattern="Other", x=sw_class$annotations),]

## Remove unnecessary data to clear space
#rm(sw_class)

## Make sure R is using the required laptop memory to complete the function
memory.limit()
memory.limit(size=25000)

## External function: extract image_id 
adult$metadata <- adult$subject_data # change column name to work with function
adult <- extract_imageid_rawclicks(data=adult)

chick$metadata <- chick$subject_data # change column name to work with function
chick <- extract_imageid_rawclicks(data=chick)

egg$metadata <- egg$subject_data # change column name to work with function
egg <- extract_imageid_rawclicks(data=egg)

other$metadata <- other$subject_data # change column name to work with function
other <- extract_imageid_rawclicks(data=other)

## External function: extract x,y coords
adult_xy <- raw_xy(data = adult, save="adult")
chick_xy <- raw_xy(data = chick, save="chick")
egg_xy <- raw_xy(data = egg, save="egg")
other_xy <- raw_xy(data = other, save="other")

## Remove 'descrip' column from adult, chick and egg --> only need this for 'other' category
adult_xy <- subset(adult_xy, select=-descrip)
chick_xy <- subset(chick_xy, select=-descrip)
egg_xy <- subset(egg_xy, select=-descrip)

# stop imageid column being a list
adult_xy$image_id <- paste0(adult_xy$image_id)
chick_xy$image_id <- paste0(chick_xy$image_id)
egg_xy$image_id <- paste0(egg_xy$image_id)
other_xy$image_id <- paste0(other_xy$image_id)

write.csv(adult_xy, paste0(outdir, "Great Cormorants adult_citsciRaw.csv"), row.names=FALSE)
write.csv(chick_xy, paste0(outdir, "Great Cormorants chick_citsciRaw.csv"), row.names=FALSE)
write.csv(egg_xy, paste0(outdir, "Great Cormorants egg_citsciRaw.csv"), row.names=FALSE)
write.csv(other_xy, paste0(outdir, "Great Cormorants other_citsciRaw.csv"), row.names=FALSE)

# If want to start the code from this point and read in the above files
#adult <-read.csv(paste0(outdir, "Great Cormorants adult_citsciRaw.csv"), row.names=1) #row.names=1 means the row names in the csv (i.e. 1, 2, 3...) become row names in the table, rather than being the first column of the dataset
#chick <-read.csv(paste0(outdir, "Great Cormorants chick_citsciRaw.csv"), row.names=1) 

## Run external function to merge metadata with raw x,y coords
cam_id <- data.frame(unique(adult$cam_id))
cam_id

# Example:
# Ignore warnings about not being able to open file, provided all tools complete e.g. prints '4/4 tools complete' 
SWEYa <- merge_click_meta(cluster_data = list(adult_xy, chick_xy, egg_xy, other_xy), 
                          tools = c("adult_cormorant", "chick_cormorant", "egg_cormorant", "other_cormorant"),
                          meta_inputdir = meta_indir,
                          site = "SWEYa",
                          siteyear = c("SWEYa2023a"), 
                          site_save="SWEYa",
                          outputdir = outdir,
                          datatype="citsciRaw")

