#### INITIAL SETUP ######

DTM_res <- 2.00
res <- 0.04
chm_res <- 4*res

# Put your LiDAR data in the "input" folder
base_name<-list.files('input', pattern = "asc")
dir_name<-gsub(".asc","",base_name)

dir.remove(paste("processing/", dir_name, sep =""))
dir.remove(paste("output/", dir_name, sep =""))

if(!file.exists("processing")) dir.create("processing")
if(!file.exists(paste("processing/", dir_name, sep =""))) dir.create(paste("processing/", dir_name, sep =""))

if(!file.exists("output")) dir.create("output")
if(!file.exists(paste("output/", dir_name, sep =""))) dir.create(paste("output/", dir_name, sep =""))


#### EDIT THE SETUP FILE FOR YOUR SYSTEM ####

#Make sure the setup file is correct and save
# The most important step is to have Cloud Compare installed
# and add the executable into the setup file

# file.edit('R/01_setup.R')


###### RUN THE PIPELINE #########

#load packages, site list, and functions
source('R/01_setup.R')

#CREATE Subsampled point cloud and SURFACE MODELS
source('R/02_model.R')

#Remove Trunks
source('R/03_trunk_rem.R')

#FINAL uncorrected MODEL
source('R/model_final.R')

#Normalize Site elevation
source('R/04_delineation_preprocessing.R')

#OUTPUT as RASTER and MESH
source('R/05_final_rasterization.R')

#OUTPUT PLOT
source('R/06_plot.R')

#LOAD TopoSeg Functions
source('R/07_TopoSeg_FUN')

#TopoSeg PROCESSING####
source('R/08_TopoSeg')









####COMING SOON#####

#Delineate hummocks

# tol_p<-0.05
# th_tree_p<-0.2
# setwd(wd)
# ow = 0
# dens = 1 #density analysis?
# chm_res<-res*10
# 
# source('R/density.R')
# 
# source('R/delineation.R')