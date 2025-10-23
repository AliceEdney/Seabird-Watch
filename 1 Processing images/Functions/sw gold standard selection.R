# Select a random subset of the renamed images and save them in the goldstandard folder
#(c) Alice Edney

selectgoldstandard<-function(){

gspath<-reduced #goldstandard photos taken from zooniverse folder, which have been reduced in size, so they are same 'quality' as those shown to citizens
gsfolder<-gold
samplelist<-list.files(paste0(gspath))
randgs<-sample(samplelist, 34, replace = FALSE, prob = NULL)

#as sw upload data usually 3 per day, we might need to generate full list then subset.
movelist <- paste(gspath, randgs, sep='')
file.copy(from=movelist, to=gsfolder, copy.mode = TRUE)

}
