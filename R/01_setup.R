#Setup
library(raster)
library(data.table)
library(lidR)
library(rgeos)
library(viridis)
library(filesstrings)

sites <- c("input")

OS<-"mac"
if(OS=="mac") run<-function(x) rstudioapi::terminalExecute(x) else shell(x)

# Add the path to your cloud compare executable
cloudcompare<-"/Applications/CloudCompare.app/Contents/MacOS/CloudCompare"

# On a Windows machine your path to CC may look like:
# cloudcompare<-"C:/Program Files/CloudCompare/cloudcompare.exe"

# source('R/delineation_validation_FUN.R')

