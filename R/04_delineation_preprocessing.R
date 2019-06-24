#Delineation preprocessing

setwd(paste("processing/", dir_name, sep = ""))
input_file = list.files(pattern = "asc")[1]
file = gsub(".asc","*.asc",input_file)

print(paste("Creating",DTM_res,"m resolution DTM for site"))

termId<-run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH
            "-SILENT",
            "-AUTO_SAVE OFF",
            "-C_EXPORT_FMT", "ASC", #Set asc as export format
            "-NO_TIMESTAMP",
            "-O", input_file,
            "-AUTO_SAVE ON",
            "-RASTERIZE", "-GRID_STEP", DTM_res, "-VERT_DIR", 2, "-PROJ", "AVG", "-SF_PROJ", "AVG","-EMPTY_FILL","INTERP", #calculate min raster grid
            "-OUTPUT_MESH",
            # "-OUTPUT_RASTER_Z",
            sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

write.table(cbind(result,"04_delineation_preprocessing"), paste("../../output/",dir_name,"_log.txt", sep=""), append = TRUE)

mesh = list.files(pattern = "bin")

print(paste("Creating",res,"m resolution DTM for site"))
termId<-run(paste(cloudcompare,
          "-SILENT",
          "-AUTO_SAVE OFF",
          "-C_EXPORT_FMT", "ASC", #Set asc as export format
          "-NO_TIMESTAMP",
          "-O", input_file,
          "-AUTO_SAVE ON",
          "-RASTERIZE", "-GRID_STEP", res, "-VERT_DIR", 2, "-PROJ", "MIN", "-SF_PROJ", "AVG", #calculate min raster grid
          "-OUTPUT_CLOUD",
          sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

write.table(cbind(result,"04_delineation_preprocessing"), paste("../../output/",dir_name,"_log.txt", sep=""), append = TRUE)

file.move(input_file, paste("../../output/", dir_name, sep = ""))

input_file = list.files(pattern = "asc")[1]

print(paste("Creating normalized point cloud from",DTM_res,"m resolution DTM for site"))
termId <-run(paste(cloudcompare,
                  "-SILENT",
                  "-AUTO_SAVE OFF",
                  "-C_EXPORT_FMT", "ASC", #Set asc as export format
                  "-NO_TIMESTAMP",
                  "-AUTO_SAVE ON",
                  "-O", input_file,
                  "-REMOVE_ALL_SFS",
                  "-O", mesh,
                  "-C2M_DIST",
                  sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

write.table(cbind(result,"04_delineation_preprocessing"), paste("../../output/",dir_name,"_log.txt", sep=""), append = TRUE)

file.move(input_file, paste("../../output/", dir_name, sep = ""))
file.move(mesh, paste("../../output/", dir_name, sep = ""))


setwd("../..")


