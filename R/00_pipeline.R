#load packages, site list, and functions
library(filesstrings)

OS<-"mac"

if(OS=="mac") run<-function(x) rstudioapi::terminalExecute(x) else shell(x)

cloudcompare<-"/Applications/CloudCompare.app/Contents/MacOS/CloudCompare"

source('R/01_setup.R')
# wd <- getwd()

#OVERWRITE?
ow <- 1 #overwrite? 1 = true, 0 = false
# 
# val_ls<-list()
# all_val_ls<-list()

# res = 0.01
# int_res<-0.05

base_name<-list.files('input', pattern = "asc")
dir_name<-gsub(".asc","",base_name)
dir.create(paste("output/", dir_name, sep =""))

#CREATE Subsampled point cloud and SURFACE MODELS
ow = 1
source('R/02_model.R')

#Remove Trunks
ow = 1
source('R/03_trunk_rem.R')

#FINAL MODEL
ow = 1
source('R/model_final.R')

#Normalize Site elevation
ow = 1
DTM_res <- 2.00
# source('R/elev_norm.R')
source('R/04_delineation_preprocessing.R')

source('R/05_final_rasterization.R')

#Delineate hummocks

tol_p<-0.05
th_tree_p<-0.2
setwd(wd)
ow = 0
dens = 1 #density analysis?
chm_res<-res*10

source('R/density.R')

source('R/delineation_preprocessing.R')

source('R/delineation.R')