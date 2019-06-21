DTM_res <- 2.00
res <- 0.01
chm_res <- 4*res

base_name<-list.files('input', pattern = "asc")
dir_name<-gsub(".asc","",base_name)
dir.create(paste("output/", dir_name, sep =""))

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