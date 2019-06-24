####PACKAGES####
library(raster)
library(lidR)

####FUNCTIONS####

pts2las<-function(pts){
  colnames(pts)<-c("X","Y","Z")
  
  las<-LAS(cbind(pts[,1:3]))
  crs(las)<-crs('+proj=utm +zone=11 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs')
  las@data$Classification<-1 #2 is ground 1 is vegetation
  las@data$Classification<-as.integer(las@data$Classification)
  
  print(paste("Removing 99th percentile values from surface model"))
  las_clip<-lasfilter(las, las@data$Z<quantile(las@data$Z[las@data$Classification==1],0.99))
  
  las<-las_clip
  las@data$Z<-las@data$Z-quantile(las@data$Z,0.001)
  las@data$ReturnNumber<-1
  las@data$ReturnNumber<-as.integer(las@data$ReturnNumber)
  
  return(las)
}

filter_density<-function(las, dem, res = 1, smooth = FALSE){
  print(paste("Creating surface model density estimate"))
  density<-grid_density(las, res = 1)
  if(smooth==TRUE) density<-resample(density,dem)
  las<-lasmergespatial(las, density>2000)
  las_clip<-lasfilter(las, id == TRUE)
  return(las_clip)
}

humF<-function(hum_seg, lower = 0.1, upper = Inf){
  rres<-res(hum_seg)
  zoneF<-as.data.frame(zonal(hum_seg>0,hum_seg, fun = "sum"))
  zoneF$sum<-zoneF$sum*rres[1]*rres[2]
  zoneF<-zoneF[zoneF$sum>lower&zoneF$sum<upper,]
  hum_seg[!(hum_seg %in% zoneF$zone)]<-NA
  return(hum_seg)
}

hum_class<-function(dem, s_th, h_th){
  print("Classifying hollows/ground points")
  #calculate dem slope
  slope <- terrain(dem, opt=c('slope'), unit='degrees', neighbors=4)
  
  print("Identify low slope and elevation locations")
  #limit analysis based on slope and hummock height
  
  if(is.null(s_th)) s_th<-mean(slope@data@values, na.rm = TRUE)
  if(is.null(h_th)) h_th<-mean(dem@data@values, na.rm = TRUE)
  
  ground <- (slope<s_th&dem<s_th)
  
  ground@data@values[ground@data@values==1]<-2
  ground@data@values[ground@data@values!=2]<-1
  setMinMax(ground)
  return(ground)
}

# res = 0.05 
# subcircleF = 1.1
# filter = TRUE
# filter_hum = TRUE

toposeg<-function(pts=NULL, dem=NULL,
                  classify = NULL,
                  res = 0.05,
                  subcircleF = 1.1, 
                  filter_density = TRUE, 
                  smooth = FALSE, 
                  filter_hum = TRUE,
                  th_tree_p = NULL,
                  tol_p = 0.05,
                  s_th = NULL,
                  h_th = NULL,
                  ext = 1){
  
  if(is.null(dem)|!is.null(pts)){
    if(length(pts)>3){
      print("Input cloud must only be XYZ")
      stop()
    }
    
    if(length(pts)<3){
      print("Input cloud must have XYZ")
      stop()
    }
    
    ###PREPROCESS####
    las<-pts2las(pts)
    
    ###DEM####
    print("Creating pit-free surface model")
    dem <- grid_canopy(las, res = res, pitfree(subcircle = res*subcircleF))
    
    ####FILTER####
    if (filter_density == TRUE) las<-filter_density(las, dem, res = 1, smooth)
  }
  
  
  ####CLASSIFY####
  if(is.null(classify)){
    print("Classify hollows and filter LiDAR")
    ground<-hum_class(dem, s_th, h_th)
  } else ground<-classify
  
  las<-lasmergespatial(las, ground)
  las@data$Classification<-as.integer(las@data$id)
  
  ######TOPOSEG#####
  print(paste("Calculating clipping parameters for TopoSeg"))
  if(is.null(th_tree_p)) th_tree_p <- quantile(las@data$Z[las@data$Classification==1],0.6, na.rm = TRUE)
  
  # tol_p<-0.05
  
  print(paste("Delineating hummock features using a",
              tol_p, "m minimum hummock threshold and a",
              th_tree_p, "m local maxima threshold"))
  
  hum_seg<-watershed(chm = dem, th_tree = th_tree_p, tol = tol_p, ext = ext)()
  hum_seg[ground==2]<-NA
  
  
  ###FILTER HUMMOCKS####
  if(filter_hum == TRUE) hum_seg<-humF(hum_seg)
  return(hum_seg)
}
