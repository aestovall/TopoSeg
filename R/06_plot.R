
#Visualize final microtopographic model

setwd("input")
input_file = list.files(pattern = "tif")[1]

library(raster)

model<-raster(input_file)
crs(model)<-crs('+proj=utm +zone=11 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs')

slope = terrain(model, opt='slope')
aspect = terrain(model, opt='aspect')
hill = hillShade(slope, aspect, 40, 270)

grayalphas <- seq(-1,1,length=101)^2*255
plot(hill, col=grey(0:100/100), legend=FALSE, main='Hummock-Hollow Microtopography')
plot(model, col=viridis(25, alpha=0.67), add=TRUE)

#Smooth the surface model
model1<-focal(model, w=matrix(1, 3, 3), mean)
slope = terrain(model1, opt='slope')
aspect = terrain(model1, opt='aspect')
hill = hillShade(slope, aspect, 40, 270)

png(paste("../figures/",input_file,"_processed.png", sep = ""))
plot(hill, col=grey(0:100/100), legend=FALSE, main='Hummock-Hollow Microtopography')
plot(model, col=viridis(25, alpha=0.67), add=TRUE)
dev.off()

setwd("..")
