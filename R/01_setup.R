#Setup
# install.packages('devtools')
# require(devtools)
# install.packages('raster')
# install.packages('data.table')
# install.packages('lidR')
# install_version("lidR", version = "1.5.1", repos = "http://cran.us.r-project.org")
# install.packages('rgeos')
# install.packages('viridis')
# install.packages('ggplot2')

# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("EBImage", version = "3.8")

library(raster)
library(data.table)
library(lidR)
library(rgeos)
library(viridis)

sites <- c("input")

#Set up relative folder structure with a folder for each site
#add an "output" and "R" folder for the output and scripts

# source('R/delineation_validation_FUN.R')

res <- 0.01
chm_res <- 4*res

