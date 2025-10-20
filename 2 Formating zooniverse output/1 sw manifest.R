### --- Create seabird watch manifest --- ###

## (C) Alice Edney
## This code aims to create the 'seabird watch manifest' which is a spreadsheet containing 2 columns:
#1) subject_id (number assigned to the image by zooniverse)
#2) metadata (image_id)
# for all images uploaded to zooniverse. This is needed to extract data back out of the zooniverse once the images have been processed.
## Data required: 'seabirdwatch-subjects' from 'Data export' section of the Zooniverse Seabird Watch 'Lab'

## clear the R environment
rm(list=ls())
ls()

## set directories 
indir <- # insert directory where csvs downloaded from Seabird Watch are saved
outdir <- # insert directory where output will be saved
codepath <- # insert directory where external functions needed to run this script are saved

indir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/1 Raw classifications/"
outdir <- "C:/Users/Ladmin/Documents/1 Seabird Watch/Data/2 Processed classifications/"
codepath <- "C:/Users/Ladmin/Documents/1 Seabird Watch/R code/2 Formating zooniverse output/Functions/"

## set source of external functions
source(paste0(codepath, "1 sw extract_imageid - seabirdwatch subjects.R"), local = FALSE)

## Libraries 
library(tidyr)
library(dplyr)
library(stringr)
library(stringi)
library(exifr)
library(data.table) 
library(tidyverse)


## Read in data
subjects <- read.csv(paste0(indir, "seabirdwatch-subjects.csv"), sep =",")

## Examine data 
#head(subjects)
#str(subjects)

## Call external function to convert image_id to correct format
subject_data <- extract_imageid_rawclicks(data=subjects)

## Select the required workflows only by changing 'pattern=...' to the workflow you would like to extract data for
# The number assigned to each workflow can be found in the Labs --> Workflows section of the project
unique(subject_data$workflow_id)
# workflow_id = 251 is for the "Timelapse (#251)" workflow
# workflow id = 20264 is for "European Shag nests - Guernsey (#20264)" workflow
# workflow_id = 16861 is for "Round Island Petrels (#16861)" workflow
# workflow_id = 23632 is for the "Kittiwake nests (#23632)" workflow
# workflow_id = 25959 is for the "Great Cormorants: Best on the Nest (#25959)"

# The following example selects data for the Cormorant workflow 
subject_data <- subject_data[grep(pattern='25959', x=subject_data$workflow_id), ] # Cormorant data
workflow_name <- "Great Cormorants"

# Select only necessary columns
subject_data_full <- dplyr::select(subject_data, subject_id, classifications_count, retirement_reason, image_id, cam_id)
manifest <- dplyr::select(subject_data_full, subject_id, image_id, cam_id)

# Remove duplicate rows for manifest as some image_ids are present twice i.e. some image_ids are present twice
subject_data_full <- subject_data_full[!duplicated(subject_data_full$image_id),]
manifest <- manifest[!duplicated(manifest$image_id),]

## Write to csv
write.csv(subject_data_full, paste0(outdir, "sw manifest_full_", workflow_name, ".csv"), row.names=FALSE)
write.csv(manifest, paste0(outdir, "sw manifest_", workflow_name, ".csv"), row.names=FALSE)

