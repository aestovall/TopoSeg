![TopoSeg](TopoSeg.png)

Algorithms described in "Quantifying Wetland Microtopography with Terrestrial Laser Scanning" (Stovall et al. 2019) for generating microtopographic surface models

## INITIAL SETUP

```{r,echo=FALSE}
DTM_res <- 2.00 #DTM for the normalization step
DTM_min_avg <- "MIN" # can also be "AVG" for an average normalization
res <- 0.04 #final model resolution
chm_res <- 4*res
```

Now, you need to put your LiDAR data in the "input" folder. We will read those files and create directories based on the file names.

```{r,echo=FALSE}
base_name<-list.files('input', pattern = "asc")
dir_name<-gsub(".asc","",base_name)

dir.remove(paste("processing/", dir_name, sep =""))
dir.remove(paste("output/", dir_name, sep =""))

if(!file.exists("processing")) dir.create("processing")
if(!file.exists(paste("processing/", dir_name, sep =""))) dir.create(paste("processing/", dir_name, sep =""))

if(!file.exists("output")) dir.create("output")
if(!file.exists(paste("output/", dir_name, sep =""))) dir.create(paste("output/", dir_name, sep =""))
```

Note: If you do not want to overwrite previous runs on the site comment out the `dir.remove()` lines.


## EDIT THE SETUP FILE FOR YOUR SYSTEM

Make sure the setup file is correct and save. The most important step is to have Cloud Compare installed and add the executable path into the setup file.

```{r,echo=FALSE}
file.edit('R/01_setup.R')
```

Add your operating system type and specify the path to CloudCompare. Further testing is necessary to ensure this works on a Windows machine.

## RUN THE PIPELINE

Load packages, site list, and functions

```{r,echo=FALSE}
source('R/01_setup.R')
```

Create subsampled point cloud and SURFACE MODELS
```{r,echo=FALSE}
source('R/02_model.R')
```

Remove Trunks
```{r}
source('R/03_trunk_rem.R')
```

Normalize Site elevation
```{r}
source('R/04_delineation_preprocessing.R')
```

OUTPUT as RASTER and MESH
```{r,echo=FALSE}
source('R/05_final_rasterization.R')
```

OUTPUT PLOT
```{r}
source('R/06_plot.R')
```

LOAD TopoSeg Functions
```{r}
source('R/07_TopoSeg_FUN.R')
```

TopoSeg PROCESSING
```{r}
source('R/08_TopoSeg.R')
```
Success (hopefully)! You will find all of the processed files in the `output` directory within a folder named after the original LiDAR dataset.
The `figures` folder should also include a preview of the final surface models as well as microtopographic delineation with TopoSeg.

