###--- FUNCTION

raw_xy <- function(data, save){
  # All 'annotations' data end in ',"tool":0,"frame":0,"details":[],"tool_label":"Kittiwakes"'
  # ,\"tool\":0,\"frame\":0,\"details\":[],\"tool_label\":\"Kittiwakes\"                                              
  
  
  # Extract x and y coords from 'annotations' column
  data$raw_x <- sub('.*x', '', data$annotations) #extract all characters after 'x'
  data$raw_x <- sub('tool.*', '', data$raw_x) #extract all characters before 'tool'
  data$raw_x <- sub('y.*', '', data$raw_x) #extract all characters before 'y'
  data$raw_x <- str_sub(data$raw_x, 3) #removes first two letters in the string
  data$raw_x <- str_sub(data$raw_x,1, nchar(data$raw_x) -2) #removes last two letters in the string
  
  data$raw_y <- sub('tool.*', '', data$annotations) #extract all characters before 'tool'
  data$raw_y <- sub('.*y', '', data$raw_y) #extract all characters after 'y'
  data$raw_y <- str_sub(data$raw_y, 3) #removes first two letters in the string
  data$raw_y <- str_sub(data$raw_y,1, nchar(data$raw_y) -2) #removes last two letters in the string
  
  ## Remove rows where 'annotations' column contains " or is empty
  data <- data[!(data$raw_x == '"'), ]
  data <- data[!(data$raw_x == ""), ]
  
  ## Extract description of 'Other' object
  # Note - this is only necessary for some workflows where users could write a description of what an 'Other' object was e.g. 'predator'
  data$descrip <- sub('.*value', '', data$annotations) #extract all characters after 'value'
  data$descrip <- str_sub(data$descrip, 3) #removes first two letters in the string
  
  # Remove unnecessary columns and rename
  data_c <- subset(data, select=c(user_name, user_id, created_at, workflow_version, gold_standard, expert, subject_ids, image_id, cam_id, raw_x, raw_y, descrip))
  
  ## Write to csv 
  #write.csv(data_c, paste0(outdir, save, "_raw_xy.csv"), row.names = FALSE)
  
  return(data_c)
  
}
