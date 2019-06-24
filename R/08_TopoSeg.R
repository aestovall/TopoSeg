######TopoSeg PROCESSING####
input_file <- list.files(paste("output/", dir_name, sep = ""), pattern = ".asc", full.names = TRUE)[1]

#For this example we will input a classification based on Stovall et al. 2019
# using maximum liklihood classification

library(RStoolbox)

ml_class<-readRSTBX("classification/mlc_result")
class_ras<-raster(extent(model), resolution = 0.25)
chm_clip<-resample(model, class_ras)
crs(chm_clip)<-crs(model)
chm_clip@file@name<-'Z'
chm_clip@data@names<-'Z'

slope = terrain(chm_clip, opt=c('slope'), unit='degrees', neighbors=4)
tri = terrain(chm_clip, opt=c('TRI'), neighbors=4)
roughness = terrain(chm_clip, opt=c('roughness'), neighbors=4)

r_pred<-stack(chm_clip, slope, tri, roughness)

class_pred<-predict(ml_class, r_pred)
class_resamp<-resample(class_pred,model, method='bilinear')
class_resamp<-round(class_resamp, 0)

pts <- fread(input_file, 
             select = c(1:2,7), 
             skip = 0, 
             header = FALSE, 
             sep = " ")


hum_out<-toposeg(pts, dem = model,
                 classify = class_resamp,
                 res = res,
                 subcircleF = 1.3, 
                 filter_density = FALSE, 
                 smooth = FALSE, 
                 filter_hum = TRUE,
                 th_tree_p = NULL,
                 tol_p = 0.05,
                 s_th = NULL,
                 h_th = NULL, 
                 ext = 1)

writeRaster(hum_out, gsub(".asc", "_TopoSeg_class.tif", input_file))

png(paste("figures/",gsub(".asc", "_TopoSeg_class.png", base_name), sep = ""))
plot(hill, col=grey(0:100/100), legend=FALSE, main='Hummock-Hollow Microtopography')
plot(hum_out, col = pastel.colors(250), add=TRUE, alpha = 0.6)
dev.off()

hum_clip<-model
hum_clip[is.na(hum_out)]<-NA

writeRaster(hum_clip, gsub(".asc", "_TopoSeg.tif", input_file))
