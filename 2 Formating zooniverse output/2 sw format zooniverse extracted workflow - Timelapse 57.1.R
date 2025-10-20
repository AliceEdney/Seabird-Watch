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
outdir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/2 Processed classifications/Timelapse 57.1/"
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

## --- This code is for extracting x,y coordinates from Timelapse workflow version 57.1 only 
sw_class <- sw_classifications[grep("57.1", sw_classifications$workflow_version), ] 
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

#-- Chick guillemots 
# select any row with 'Guillemot chicks' in annotations column
chick_guille <- sw_class[grep(pattern="Guillemot chicks", x=sw_class$annotations),]

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

chick_guille$metadata <- chick_guille$subject_data # change column name to work with function
chick_guille <- extract_imageid_rawclicks(data=chick_guille)

other$metadata <- other$subject_data # change column name to work with function
other <- extract_imageid_rawclicks(data=other)

## External function: extract x,y coords
adult_kitt_xy <- raw_xy(data = adult_kitt, save="adult_kitt")
adult_guille_xy <- raw_xy(data = adult_guille, save="adult_guille")
chick_kitt_xy <- raw_xy(data = chick_kitt, save="chick_kitt")
chick_guille_xy <- raw_xy(data = chick_guille, save="chick_guille")
other_xy <- raw_xy(data = other, save="other")

## Remove 'descrip' column from adult, chick and egg --> only need this for 'other' category
adult_kitt_xy <- subset(adult_kitt_xy, select=-descrip)
adult_guille_xy <- subset(adult_guille_xy, select=-descrip)
chick_kitt_xy <- subset(chick_kitt_xy, select=-descrip)
chick_guille_xy <- subset(chick_guille_xy, select=-descrip)

# stop imageid column being a list
adult_kitt_xy$image_id <- paste0(adult_kitt_xy$image_id)
adult_guille_xy$image_id <- paste0(adult_guille_xy$image_id)
chick_kitt_xy$image_id <- paste0(chick_kitt_xy$image_id)
chick_guille_xy$image_id <- paste0(chick_guille_xy$image_id)
other_xy$image_id <- paste0(other_xy$image_id)

write.csv(adult_kitt_xy, paste0(outdir, "Timelapse v57.1 adult_kitt_citsciRaw.csv"), row.names=FALSE)
write.csv(adult_guille_xy, paste0(outdir, "Timelapse v57.1 adult_guille_citsciRaw.csv"), row.names=FALSE)
write.csv(chick_kitt_xy, paste0(outdir, "Timelapse v57.1 chick_kitt_citsciRaw.csv"), row.names=FALSE)
write.csv(chick_guille_xy, paste0(outdir, "Timelapse v57.1 chick_guille_citsciRaw.csv"), row.names=FALSE)
write.csv(other_xy, paste0(outdir, "Timelapse v57.1 other_citsciRaw.csv"), row.names=FALSE)

# If want to start the code from this point and read in the above files
#adult <-read.csv(paste0(outdir, "Great Cormorants adult_citsciRaw.csv"), row.names=1) #row.names=1 means the row names in the csv (i.e. 1, 2, 3...) become row names in the table, rather than being the first column of the dataset
#chick <-read.csv(paste0(outdir, "Great Cormorants chick_citsciRaw.csv"), row.names=1) 

## Run external function to merge metadata with raw x,y coords
cam_id <- data.frame(unique(chick_guille$cam_id))
cam_id

# Examples:
# Ignore warnings about not being able to open file, provided all tools complete e.g. prints '4/4 tools complete' 
ALKEa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_kitt_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "ALKEa",
                          siteyear = c("ALKEa2016a"), 
                          site_save="workflow 57.1 ALKEa",
                          outputdir = outdir,
                          datatype="citsciRaw")

APPAa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_kitt_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "APPAa",
                          site_save = "workflow 57.1 APPAa",
                          siteyear = c("APPAa2017a", 
                                       "APPAa2017b", "APPAa2018a", "APPAa2019a", "APPAa2020a",
                                       "APPAa2021a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

ELLIa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "ELLIa",
                          site_save = "workflow 57.1 ELLIa",
                          siteyear = c("ELLIa2015a", "ELLIa2015b", 
                                       "ELLIa2016a", "ELLIa2016b", 
                                       "ELLIa2017a", "ELLIa2017b",
                                       "ELLIa2018a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

FORGa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "FORGa",
                          site_save = "workflow 57.1 FORGa",
                          siteyear = c("FORGa2019b", "FORGa2021a",
                                       "FORGa2022a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

HVITa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "HVITa",
                          site_save="workflow 57.1 HVITa",
                          siteyear = c("HVITa2016a", "HVITa2016b", "HVITa2016c", "HVITa2016d", 
                                       "HVITa2017b"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

HVITa_notemp <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                                 tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                                 meta_inputdir = meta_indir,
                                 site = "HVITa",
                                 site_save = "workflow 57.1 HVITa_notemp",
                                 siteyear = c("HVITa2018a", "HVITa2018b",
                                              "HVITa2019a", 
                                              "HVITa2020a", "HVITa2020b",
                                              "HVITa2021a", "HVITa2021b",
                                              "HVITa2022a", "HVITa2022b",
                                              "HVITa2023a"), 
                                 outputdir = outdir,
                                 datatype="citsciRaw")

KAPWa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "KAPWa",
                          site_save="workflow 57.1 KAPWa",
                          siteyear = c("KAPWa2018a", "KAPWa2019a", "KAPWa2021a",
                                       "KAPWa2022a", "KAPWa2023a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

KIPPa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "KIPPa",
                          site_save="workflow 57.1 KIPPa",
                          siteyear = c("KIPPa2016a", "KIPPa2016b",
                                       "KIPPa2017a", "KIPPa2018a", "KIPPa2019a",
                                       "KIPPa2021a", "KIPPa2022a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

MARGa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "MARGa",
                          site_save="workflow 57.1 MARGa",
                          siteyear = c("MARGa2022a"), 
                          outputdir = outdir,
                          datatype="citsciRaw") 

MITTa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "MITTa",
                          site_save="workflow 57.1 MITTa",
                          siteyear = c("MITTa2015b", 
                                       "MITTa2017a",
                                       "MITTa2018a", 
                                       "MITTa2021a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

MITTb <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille, chick_kitt, chick_guille, otherdata), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "MITTb",
                          site_save = "workflow 57.1 MITTb",
                          siteyear = c("MITTb2015a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

OSSIa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille, chick_kitt, chick_guille, otherdata), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "OSSIa",
                          site_save="workflow 57.1 OSSIa",
                          siteyear = c("OSSIa2016a", 
                                       "OSSIa2017a", "OSSIa2017b", "OSSIa2017c", 
                                       "OSSIa2018a", "OSSIa2018b",
                                       "OSSIa2019a", 
                                       "OSSIa2020a",
                                       "OSSIa2021a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

SKELa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille, chick_kitt, chick_guille, otherdata), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "SKELa",
                          site_save="workflow 57.1 SKELa",
                          siteyear = c("SKELa2015a", 
                                       "SKELa2016a", 
                                       "SKELa2017a",
                                       "SKELa2020a",
                                       "SKELa2021a",
                                       "SKELa2023a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

SKOMd <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille, chick_kitt, chick_guille, otherdata), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "SKOMd",
                          site_save="workflow 57.1 SKOMd",
                          siteyear = c("SKOMd2017a", "SKOMd2017b", 
                                       "SKOMd2018a", "SKOMd2018b", "SKOMd2018c",
                                       "SKOMd2019a", "SKOMd2019b", 
                                       "SKOMd2020a", "SKOMd2020b",
                                       "SKOMd2022a", "SKOMd2023a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

MYBRa_notemp <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                                 tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                                 meta_inputdir = meta_indir,
                                 site = "MYBRa",
                                 site_save = "workflow 57.1 MYBRa_notemp",
                                 siteyear = c("MYBRa2014a"), 
                                 outputdir = outdir,
                                 datatype="citsciRaw")

MYBRa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy), 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "MYBRa",
                          site_save="workflow 57.1 MYBRa",
                          siteyear = c("MYBRa2015a", "MYBRa2015b",
                                       "MYBRa2016a", "MYBRa2016b", 
                                       "MYBRa2018a", "MYBRa2018b", 
                                       "MYBRa2019a", "MYBRa2019b", "MYBRa2019c", "MYBRa2019d", "MYBRa2019e", 
                                       "MYBRa2020a", "MYBRa2020b",
                                       "MYBRa2021a",
                                       "MYBRa2022a", "MYBRa2023a"), 
                          outputdir = outdir,
                          datatype="citsciRaw")

STAGa <- merge_click_meta(cluster_data = list(adult_kitt_xy, adult_guille_xy, chick_kitt_xy, chick_guille_xy, other_xy, 
                          tools = c("adult_kitt", "adult_guille", "chick_kitt", "chick_guille", "other"),
                          meta_inputdir = meta_indir,
                          site = "STAGa",
                          site_save="workflow 57.1 STAGa",
                          siteyear = c("STAGa2019d", "STAGa2019e"),
                          outputdir = outdir,
                          datatype="citsciRaw")


