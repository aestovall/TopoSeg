
#CREATE Subsampled point cloud and SURFACE MODELS
print(paste("Creating minumum cloud at", res, "m resolution for site"))

setwd("input")
input_file = list.files(pattern = "asc")[1]
file = gsub(".asc","*.asc",input_file)

termId<-run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH
                  "-SILENT",
                  "-AUTO_SAVE OFF",
                  "-C_EXPORT_FMT", "ASC", #Set asc as export format
                  "-NO_TIMESTAMP",
                  "-O", file, #open the subsampled file
                  "-AUTO_SAVE ON",
                  "-RASTERIZE", "-GRID_STEP", res, "-VERT_DIR", 2, "-PROJ", "MIN", "-SF_PROJ", "AVG","-EMPTY_FILL", "INTERP", #calculate min raster grid
                  "-OUTPUT_CLOUD",
                  sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

file.move(input_file, paste("../output/", dir_name, sep = ""))
setwd("..")

write.table(cbind(result,"02_model"), paste("output/",dir_name,"_log.txt", sep=""), append = TRUE)
