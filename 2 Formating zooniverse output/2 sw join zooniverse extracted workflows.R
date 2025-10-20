## Join multiple data workflows to create single csv ##  
# (C) Original from Alice Edney

## clear the R environment
rm(list=ls())
ls()

## libraries
library(tidyverse) #for drop_na function

## set directories
indir = "C:/Users/sedm6412/OneDrive - Nexus365/Documents/1 University of Oxford/Seabird Watch/1 Data/Seabirdwatch Classifications/2 Processed classifications/1 Raw click/"

## Function to join the workflows
joinNoTempData <- function(input_dir, tool, workflow1, workflow2, site, type1, type2){
  wf1 <- read.csv(paste0(input_dir, workflow1, site, "_", type1, "_",  tool, ".csv"), header = TRUE, sep =",")
  wf2 <- read.csv(paste0(input_dir, workflow2, site, "_", type2, "_", tool, ".csv"), header = TRUE, sep =",")
  print(paste0(site, " ", tool, ":",  workflow1, type1, " & ", workflow2, type2, " loaded"))
  # Remove rows where datetime is NA from each dataframe 
  # i.e. rows where datetime is NA in wf1, should have datetime values in wf2
  # and rows where datetime is NA in wf2, should have datetime values in wf1
  wf1 <- wf1[!is.na(wf1$datetime), ]
  wf2 <- wf2[!is.na(wf2$datetime), ]
  # For no_temp data need to add a 'celsius' column and fill it with NAs
  if(ncol(wf1) == 13){ #dataframe with celsius as a column has 14 columns, so if column number is 13 then celsius column does not exist as camera did not record temperature
    wf1$celsius <- "NA"
  }
  if(ncol(wf2) == 13){
    wf2$celsius <- "NA"
  }
  wf <- rbind(wf1, wf2)
  write.csv(wf, paste0(input_dir, site, "_", type1, "_", tool, ".csv"), row.names=FALSE)
  print("Complete")
}

joinWorkflows <- function(input_dir, tool, workflow1, workflow2, site, type1, type2){
  wf1 <- read.csv(paste0(input_dir, workflow1, site, "_", type1, "_",  tool, ".csv"), header = TRUE, sep =",")
  wf2 <- read.csv(paste0(input_dir, workflow2, site, "_", type2, "_", tool, ".csv"), header = TRUE, sep =",")
  print(paste0(site, " ", tool, ":",  workflow1, type1, " & ", workflow2, type2, " loaded"))
  if(ncol(wf1) == 11){ #dataframe with celsius as a column has 12 columns, so if column number is 11 then celsius column does not exist as camera did not record temperature
    wf1$celsius <- "NA"
  }
  if(ncol(wf2) == 11){
    wf2$celsius <- "NA"
  }
  wf <- rbind(wf1, wf2)
  write.csv(wf, paste0(input_dir, site, "_", type1, "_", tool, ".csv"), row.names=FALSE)
  print("Complete")
}

## Function to copy and rename data that was only processed by one workflow
copyRename <- function(input_dir, tool, workflow, site, type){
  wf <- read.csv(paste0(input_dir, workflow, site, "_", type, "_",  tool, ".csv"), header = TRUE, sep =",")
  write.csv(wf, paste0(input_dir, site, "_", type, "_", tool, ".csv"), row.names=FALSE)
  print("Complete")
}

## Run function
# NOTE: can only join workflow datasets for kadult, gadult and kchick, cannot join for gchick
# This is because the old workflow (55.97) had a 'Chicks' tool, and did not distinguish between kitt and guill chicks.
# I have assumed that birds classified as 'Chicks' were kittiwake chicks as it is so hard to spot chick guillemots

# NOTE: only need to do this for the datasets that were processed using the old workflow
# e.g. APPAa, KIPPa, KAPWa, MYBRa were only processed with new workflow 57.1, so no old data to join with
# e.g. PUFFa and RATHs were only procesed with old workflow 55.97, so no new data to join with


# In both workflows & Temperature data not present
# Join HVITa and HVITa no temp data
joinNoTempData(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 57.1 ",
              tool = "kadult",
              site = "HVITa",
              type1="citsciRaw",
              type2="notemp_citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "HVITa",
              type1="citsciRaw",
              type2="citsciRaw")


joinNoTempData(input_dir = indir,
               workflow1 = "workflow 57.1 ",
               workflow2 = "workflow 57.1 ",
               tool = "gadult",
               site = "HVITa",
               type1="citsciRaw",
               type2="notemp_citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "HVITa",
              type1="citsciRaw",
              type2="citsciRaw")

joinNoTempData(input_dir = indir,
               workflow1 = "workflow 57.1 ",
               workflow2 = "workflow 57.1 ",
               tool = "kchick",
               site = "HVITa",
               type1="citsciRaw",
               type2="notemp_citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "HVITa",
              type1="citsciRaw",
              type2="citsciRaw")


# Join MYBRa and MYBRa no temp data
joinNoTempData(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 57.1 ",
              tool = "kadult",
              site = "MYBRa",
              type1="citsciRaw",
              type2="notemp_citsciRaw")

joinNoTempData(input_dir = indir,
               workflow1 = "workflow 57.1 ",
               workflow2 = "workflow 57.1 ",
               tool = "gadult",
               site = "MYBRa",
               type1="citsciRaw",
               type2="notemp_citsciRaw")

joinNoTempData(input_dir = indir,
               workflow1 = "workflow 57.1 ",
               workflow2 = "workflow 57.1 ",
               tool = "kchick",
               site = "MYBRa",
               type1="citsciRaw",
               type2="notemp_citsciRaw")


# In both workflows & Temperature data present
joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "ALKEa", 
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "ALKEa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "ALKEa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "ELLIa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "ELLIa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "ELLIa",
              type1="citsciRaw",
              type2="citsciRaw")


joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "MITTa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "MITTa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "MITTa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "MITTb",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "MITTb",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "MITTb",
              type1="citsciRaw",
              type2="citsciRaw")


joinWorkflows(input_dir = indir, 
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "OSSIa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "OSSIa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "OSSIa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "SKELa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "SKELa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "SKELa",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kadult",
              site = "SKOMd",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "gadult",
              site = "SKOMd",
              type1="citsciRaw",
              type2="citsciRaw")

joinWorkflows(input_dir = indir,
              workflow1 = "workflow 57.1 ",
              workflow2 = "workflow 55.97 ",
              tool = "kchick",
              site = "SKOMd",
              type1="citsciRaw",
              type2="citsciRaw")


## Copy and rename sites that were only processed in one workflow
#workflow 57.1
copyRename(input_dir = indir,
              workflow = "workflow 57.1 ",
              tool = "kadult",
              site = "KAPWa",
              type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "KAPWa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "KAPWa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kadult",
           site = "APPAa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "APPAa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "APPAa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kadult",
           site = "KIPPa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "KIPPa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "KIPPa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kadult",
           site = "STAGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "STAGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "STAGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kadult",
           site = "MARGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "MARGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "MARGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kadult",
           site = "FORGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "kchick",
           site = "FORGa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 57.1 ",
           tool = "gadult",
           site = "FORGa",
           type="citsciRaw")

#workflow 55.97
copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "kadult",
           site = "PUFFa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "kchick",
           site = "PUFFa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "gadult",
           site = "PUFFa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "kadult",
           site = "RATHa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "kchick",
           site = "RATHa",
           type="citsciRaw")

copyRename(input_dir = indir,
           workflow = "workflow 55.97 ",
           tool = "gadult",
           site = "RATHa",
           type="citsciRaw")


