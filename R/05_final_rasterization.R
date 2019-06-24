#CREATE final microtopographic model
print(paste("Creating microtopographic model at", res, "m resolution for site"))

setwd(paste("processing/", dir_name, sep = ""))
input_file = list.files(pattern = "asc")[1]
file = gsub(".asc","*.asc",input_file)

min_density<-1/(res^2)*0.2

print(paste("Creating",res,"m resolution DTM for site"))
termId<-run(paste(cloudcompare,
                  "-SILENT",
                  "-AUTO_SAVE OFF",
                  "-C_EXPORT_FMT", "ASC", #Set asc as export format
                  "-NO_TIMESTAMP",
                  "-O", input_file,
                  # "-APPROX_DENSITY",
                  # "-FILTER_SF", min_density, "MAX",
                  "-AUTO_SAVE ON",
                  "-RASTERIZE", "-GRID_STEP", res, "-VERT_DIR", 2, "-PROJ", "MIN", "-SF_PROJ", "AVG", "-EMPTY_FILL", "INTERP", #calculate min raster grid
                  "-OUTPUT_RASTER_Z",
                  "-OUTPUT_MESH",
                  # "-OUTPUT_CLOUD",
                  sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

write.table(cbind(result,"04_delineation_preprocessing"), paste("../../output/",dir_name,"_log.txt", sep=""), append = TRUE)

file.move(input_file, paste("../../output/", dir_name, sep = ""))
file.move(list.files(), paste("../../output/", dir_name, sep = ""))

setwd("../..")

dir.remove(paste("processing/", dir_name, sep =""))
