# Seabird Watch
This repository is for the zooniverse citizen science project, Seabird Watch ([www.seabirdwatch.org](https://www.zooniverse.org/projects/penguintom79/seabirdwatch)). It provides code for processing images so they can be uploaded to Seabird Watch, and for extracting volunteer classifications from Seabird Watch for subsequent analysis. 

<img width="1852" height="780" alt="Fig 2 example screenshot of SW" src="https://github.com/user-attachments/assets/7ab38ab1-fcad-40b9-b082-d594be64cba3" />

## Usage
Code is saved in two separate folders:
- '1 Processing images' is run before uploading images to Seabird Watch. The output (images and metadata) can then be uploaded to the Seabird Watch project. 
- '2 Formating zooniverse output' is run after images have finished being classifised on Seabird Watch (i.e. they have been retired). This extracts the x, y coordinates for where volunteers clicked on objects in images, and classified them (e.g. as an adult, chick, egg, etc).

### 1 Processing images
_AIM:_ To process raw images into the required format for upload to Seabird Watch. 

_INPUT:_ Raw unprocessed images in '_raw' folder.  

_OUTPUT:_ Folders of processed images and metadata

There are two options for processing raw images. The first (preferred) option, uses 'sw process images with alignment.R' and requires aligning the images to remove movement between images created by camera shake BEFORE upload to Seabird Watch. The second option, uses 'sw process images without alignment.R' and does not have an image alignment step. However, this means alignment must be completed on the volunteer classifications once they have been downloaded from Seabird Watch. This can be achieved using https://github.com/CarlosArteta/pengbot-aligner. Image alignment is an essential step if you want to follow individual nests across the breeding season, because it ensures that the x, y coordinates of each nest remain the same across a time-series. If you do not align the images, then small movements of the camera (e.g. due to the tripod wobbling in strong winds) will cause the nests to move between images, and so it will be difficult to automatically track the progress of individual nests across the time-series.  

## sw process images with alignment.R
1) Assign a 4 letter identifier to the site where the images were taken, and append a letter to indicate the camera within that site e.g. BERNa, BERNb - BERNa is camera A on Berneray, and BERNb is camera B on Berneray.

3) Create the following folder structure (replacing the first 5 letters with your camera's identifier). 
<img width="243" height="443" alt="image" src="https://github.com/user-attachments/assets/8d3e1d37-eb19-43b1-8ce3-2b23b7bfced5" />

4) Within the _raw folder, create a folder that includes the year the images were collected from the camera. If there are multiple folders with images on the camera SD card, label them 'a', 'b', 'c', etc. Do not try and save them in a single folder as images may have the same name and overwrite each other.  
e.g. BERNa2025a, BERNa2025b, and BERNa2025c are all images collected from camera A on Berneray in 2025. 
  <img width="218" height="144" alt="image" src="https://github.com/user-attachments/assets/47b17c9a-268f-459f-9a8e-0866a82a1a2b" />

5) Open '**1 sw process cameras with alignment.R**' for images collected on Reconyx and Bushnell cameras (will likely work for other camera types). Read through this script, change the necessary lines to match your camera name, times to select, and values that define where the image will be cropped. 

6) Run the Process1 function. This will rename and copy the raw images into a _renamed folder. 

7) Take the images from the _renamed folder and align them to remove movement between images created by camera shake. A variety of software can be used to align images. We recommend trying the method described by Merkel et al. 2016 in the Appendix of the following paper: Merkel, F.R., Johansen, K.L. and Kristensen, A.J., 2016. Use of time‐lapse photography and digital image analysis to estimate breeding success of a cliff‐nesting seabird. Journal of Field Ornithology, 87(1), pp.84-95.

8) Save the aligned images in the _aligned folder e.g. BERNa2025a_aligned
   
10) Run the Process2 function. 

## sw process images without alignment.R
1) Assign a 4 letter identifier to the site where the images were taken, and append a letter to indicate the camera within that site e.g. BERNa, BERNb - BERNa is camera A on Berneray, and BERNb is camera B on Berneray.

3) Create the following folder structure (replacing the first 5 letters with your camera's identifier). 
<img width="245" height="352" alt="Screenshot 2025-10-20 112322" src="https://github.com/user-attachments/assets/46dcfb52-6fe1-4fd4-8cd4-06c19ebf4cc7" />

4) Within the _raw folder, create a folder that includes the year the images were collected from the camera. If there are multiple folders with images on the camera SD card, label them 'a', 'b', 'c', etc. Do not try and save them in a single folder as images may have the same name and overwrite each other.  
e.g. BERNa2025a, BERNa2025b, and BERNa2025c are all images collected from camera A on Berneray in 2025. 
  <img width="218" height="144" alt="image" src="https://github.com/user-attachments/assets/47b17c9a-268f-459f-9a8e-0866a82a1a2b" />

5) Open '**sw process cameras without alignment.R**' for images collected on Reconyx and Bushnell cameras (will likely work for other camera types). Read through this script, change the necessary lines to match your camera name and run the Process function.

## Functions 
The other scripts saved within the 'Functions' folder are called from 'sw process cameras with alignment.R' and 'sw process cameras without alignment.R', but do not need to be open in R when 'sw processs cameras with alignment.R' or 'sw process cameras without alignment.R' are running. These functions are as follows:   
(NOTE - not all functions will be required e.g. midday, goldstandard, rotate, and can be hashed out in the code. Please read the above scripts to understand when to use each one.)
 
 --> **sw setup folders**    
    Creates the rest of the folders needed for the script. 

--> **sw setup folders directories**
    Creates the directories for the folders needed for the script, but does not create the folders themselves (as this has already been done by 'sw setup folders.R'
    
 --> **sw copyall**  
    Copies all images from 'raw' to 'renamed' folder, assigning each image a new name in the process   
    Images saved in '_renamed' folder 

 --> **sw metadata extraction**  
    Creates a spreadsheet with imageid, datetime and temperature   
    Images saved in '_metadata' folder

--> **sw crop images before alignment**
    Removes the black border at the top and bottom of camera trap images.   
    Images saved in '_cropped' folder

 --> **sw select and reduce zooniverse**  
    Selects specific images from the 'renamed' folder (e.g. 11.00, 12.00, 13.00), compresses them, and copies to 'zooniverse folder'  
    Images saved in '_zooniverse' folder
    
OR **sw select and reduce zooniverse_round minutes bushnell**   
    Rounds the time of all images to the nearest hour (e.g. 10:07:01 --> 10:00:00, 11:54:00 --> 12:00:00)  
    This is required for Bushnell cameras, which take images at different minutes/seconds, rather than exactly on the hour  
    Then, selects specific images from 'renamed' folder (e.g. 11.00, 12.00, 13.00), compresses them, and copies to 'zooniverse folder'  
    Images saved in '_zooniverse' folder 

OR **sw select zooniverse**  
    Selects specific images from the 'renamed' folder (e.g. 11.00, 12.00, 13.00), and copies to 'zooniverse folder'. These images remain at their orignal size, they are not reduced.  
    Images saved in '_threeaday' folder 

OR **sw select zooniverse_round minutes bushnell**     
    Rounds the time of all images to the nearest hour (e.g. 10:07:01 --> 10:00:00, 11:54:00 --> 12:00:00)  
    This is required for Bushnell cameras, which take images at different minutes/seconds, rather than exactly on the hour  
    Then, selects specific images from 'renamed' folder (e.g. 11.00, 12.00, 13.00), and copies to 'zooniverse folder'  
    Images saved in '_zooniverse' folder 
 
--> **sw select midday**
   Selects the midday images  
   Images saved in '_midday' folder  

OR **sw select midday_ round minutes bushnell**  
   Rounds the time of all images to the nearest hour (e.g. 10:07:01 --> 10:00:00, 11:54:00 --> 12:00:00)  
   This is required for Bushnell cameras, which take images at different minutes/seconds, rather than exactly on the hour  
   Then, selects the midday images  
   Images saved in 'midday' folder   

--> **sw gold standard select**  
    Randomly chooses images for gold standard classification  
    Images saved in '_goldstandard' folder  

--> **sw rotate** 
    Rotates the images by a specific angle (e.g. 90) so they are the correct orientation  
    Images saved in '_rotated' folder   
    
### 2 Formating zooniverse output 
_OVERALL AIM:_ To extract volunteer classifications (x, y coordinates where volunteers clicked) from Seabird Watch for subsequent analysis.

_INPUT:_ new classification export and new subjects export downloaded from Seabird Watch  

_OUTPUT:_ csvs containing x, y coordinates where volunteers clicked on birds in each image, as well as metadata such as datetime and temperature. One csv will be created for each tool in the workflow e.g. kittiwake adult and kittiwake chick. 

1) Request new classification export and new subject export from the Seabird Watch lab. 

2) Run '**1 sw manifest.R**'.  
Make sure to change the 'workflow_id' to the workflow you would like to extract data from.

3) Run '**2 sw format zooniverse extracted workflow - .....R**'    
Select the script that is specific to the workflow you would like to extract data from e.g. '2 sw format zooniverse extracted workflow - Kittiwake nests.R'.

NOTE - For the Timelapse workflow on Seabird Watch, two separate scripts need to be run: '2 sw format zooniverse extracted workflow - Timelapse 55.97.R' and '2 sw format zooniverse extracted workflow - Timelapse 57.1.R'. This is because the Timelapse workflow has multiple versions. Version 55.97 has images annotated from 2017-10-23 to 2020-03-03, and has tools: 'Chicks', 'Kittiwakes', 'Guillemots'. Whereas, version 57.1 has images annotated from 2020-03-03 onwards, and has tools: Kittiwake, Guillemot, Kittiwake chicks, Guillemot chicks. 'sw join zooniverse extracted workflows.R' can then be run to join csvs from version 55.97 and 57.1 together. 
  
## Associated papers
Edney, A.J., Danielsen, J., Descamps, S., Jónsson, J.E., Owen, E., Merkel, F., Stefánsson, R.A., Wood, M.J., Jessopp, M.J. and Hart, T., 2025. Using citizen science image analysis to measure seabird phenology. Ibis, 167(1), pp.56-72. https://doi.org/10.1111/ibi.13317. 

