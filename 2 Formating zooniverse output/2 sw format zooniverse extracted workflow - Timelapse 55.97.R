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
outdir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/2 Processed classifications/Timelapse 55.97/"
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

## --- This code is for extracting x,y coordinates from Timelapse workflow version 55.97 only 
sw_class <- sw_classifications[grep("55.97", sw_classifications$workflow_version), ] 
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
#-- Adult kittiwakes
# select any row with 'Kittiwakes' in annotations column
adult_kitt <- sw_class[grep(pattern="Kittiwakes", x=sw_class$annotations),]

#-- Adult guillemots 
# select any row with 'Guillemots' in annotations column
adult_guille <- sw_class[grep(pattern="Guillemots", x=sw_class$annotations),]

#-- Chick kittiwakes
# select any row with 'Kittiwake chicks' in annotations column
chick_kitt <- sw_class[grep(pattern="Kittiwake chicks", x=sw_class$annotations),]

#-- Other tool 
# select any row with 'Adult' in annotations column
other <- sw_class[grep(pattern="Other", x=sw_class$annotations),]

## Remove unnecessary data to clear space
#rm(sw_class)

## Make sure R is using the required laptop memory to complete the function
memory.limit()
memory.limit(size=25000)

## External function: extract image_id 
adult_kitt$metadata <- adult_kitt$subject_data # change column name to work with function
adult_kitt <- extract_imageid_rawclicks(data=adult_kitt)

adult_guille$metadata <- adult_guille$subject_data # change column name to work with function
adult_guille <- extract_imageid_rawclicks(data=adult_guille)

chick_kitt$metadata <- chick_kitt$subject_data # change column name to work with function
chick_kitt <- extract_imageid_rawclicks(data=chick_kitt)

other$metadata <- other$subject_data # change column name to work with function
other <- extract_imageid_rawclicks(data=other)

## External function: extract x,y coords
adult_kitt_xy <- raw_xy(data = adult_kitt, save="adult_kitt")
adult_guille_xy <- raw_xy(data = adult_guille, save="adult_guille")
chick_kitt_xy <- raw_xy(data = chick_kitt, save="chick_kitt")
other_xy <- raw_xy(data = other, save="other")

## Remove 'descrip' column from adult, chick and egg --> only need this for 'other' category
adult_kitt_xy <- subset(adult_kitt_xy, select=-descrip)
adult_guille_xy <- subset(adult_guille_xy, select=-descrip)
chick_kitt_xy <- subset(chick_kitt_xy, select=-descrip)

# stop imageid column being a list
adult_kitt_xy$image_id <- paste0(adult_kitt_xy$image_id)
adult_guille_xy$image_id <- paste0(adult_guille_xy$image_id)
chick_kitt_xy$image_id <- paste0(chick_kitt_xy$image_id)
other_xy$image_id <- paste0(other_xy$image_id)

write.csv(adult_kitt_xy, paste0(outdir, "Timelapse v55.97 adult_kitt_citsciRaw.csv"), row.names=FALSE)
write.csv(adult_guille_xy, paste0(outdir, "Timelapse v55.97 adult_guille_citsciRaw.csv"), row.names=FALSE)
write.csv(chick_kitt_xy, paste0(outdir, "Timelapse v55.97 chick_kitt_citsciRaw.csv"), row.names=FALSE)
write.csv(other_xy, paste0(outdir, "Timelapse v55.97 other_citsciRaw.csv"), row.names=FALSE)

# If want to start the code from this point and read in the above files
#adult <-read.csv(paste0(outdir, "Great Cormorants adult_citsciRaw.csv"), row.names=1) #row.names=1 means the row names in the csv (i.e. 1, 2, 3...) become row names in the table, rather than being the first column of the dataset
#chick <-read.csv(paste0(outdir, "Great Cormorants chick_citsciRaw.csv"), row.names=1) 

## Run external function to merge metadata with raw x,y coords
cam_id <- data.frame(unique(chick_guille$cam_id))
cam_id

# Examples: 
# Ignore warnings about not being able to open file, provided all tools complete e.g. prints '4/4 tools complete' 
ALKEa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),
                          meta_inputdir = meta_indir,
                          site = "ALKEa",
                          siteyear = c("ALKEa2016a"), 
                          site_save="workflow 55.97 ALKEa",
                          outputdir = outdir,
                          datatype="citsciRaw")


ELLIa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "ELLIa",
                          site_save = "workflow 55.97 ELLIa",
                          siteyear = c("ELLIa2016a", "ELLIa2016b"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

HVITa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "HVITa",
                          site_save="workflow 55.97 HVITa",
                          siteyear = c("HVITa2016a", "HVITa2016b", "HVITa2016c", "HVITa2016d"), 
                          outputdir = outdir,
                          datatype="citsciRaw")


MITTa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "MITTa",
                          site_save="workflow 55.97 MITTa",
                          siteyear = c("MITTa2015b", 
                                       "MITTa2017a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

MITTb <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "MITTb",
                          site_save="workflow 55.97 MITTb",
                          siteyear = c("MITTb2015a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

OSSIa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "OSSIa",
                          site_save="workflow 55.97 OSSIa",
                          siteyear = c("OSSIa2016a", 
                                       "OSSIa2017a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

SKELa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "SKELa",
                          site_save="workflow 55.97 SKELa",
                          siteyear = c("SKELa2015a", 
                                       "SKELa2016a", 
                                       "SKELa2017a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

SKOMd <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "SKOMd",
                          site_save="workflow 55.97 SKOMd",
                          siteyear = c("SKOMd2017a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

RATHa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "RATHa",
                          site_save="workflow 55.97 RATHa",
                          siteyear = c("RATHa2017a", "RATHa2017b"),
                          outputdir = outdir,
                          datatype="citsciRaw")

PUFFa <- merge_click_meta(cluster_data = list(adult_kitt, adult_guille, chick_kitt, otherdata), 
                          tools = c("adult_kitt_xy", "adult_guille_xy", "chick_kitt_xy", "other_xy"),                          meta_inputdir = meta_indir,
                          site = "PUFFa",
                          site_save="workflow 55.97 PUFFa",
                          siteyear = c("PUFFa2017a", "PUFFa2017b", "PUFFa2017c"),
                          outputdir = outdir,
                          datatype="citsciRaw")
