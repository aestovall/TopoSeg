
#REMOVE TRUNKS
print(paste("Removing trunks from site"))

setwd("input")
input_file = list.files(pattern = "asc")[1]
file = gsub(".asc","*.asc",input_file)

termId<-run(paste(cloudcompare, # call Cloud Compare. The .exe file folder must be in the system PATH
                  "-SILENT",
                  "-AUTO_SAVE OFF",
                  "-C_EXPORT_FMT", "ASC", #Set asc as export format
                  "-NO_TIMESTAMP",
                  "-O", file, #open the subsampled file
                  "-REMOVE_ALL_SFS",
                  "-COORD_TO_SF","Z",
                  "-SF_GRAD TRUE",
                  "-FILTER_SF", "MIN", 0.40,
                  "-SOR", 6, 2, #remove outliers'
                  "-AUTO_SAVE ON",
                  "-SOR", 500, 5, #remove outliers'
                  sep = " "))

while (is.null(rstudioapi::terminalExitCode(termId))) {
  Sys.sleep(0.1)
}

result <- rstudioapi::terminalBuffer(termId)

# Delete the buffer and close the session in the IDE
rstudioapi::terminalKill(termId)

file.move(input_file, paste("../output/", dir_name, sep = ""))
setwd("..")

write.table(cbind(result,"03_trunk_rem"), paste("output/",dir_name,"_log.txt", sep=""), append = TRUE)

