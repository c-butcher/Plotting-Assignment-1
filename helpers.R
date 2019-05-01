#---------------------------------------------------------------
# This function is used between all the plotting files, and
# does the following:
#    1. Downloads the archive.
#    2. Extracts the archive.
#    3. Deletes the archive.
#    4. Makes sure there is enough memory to open the data.
#    5. Reads the entire data set and returns it.
#---------------------------------------------------------------
fetch.data <- function() {
  # First we need to check to see if we already have the
  # data in our data directory. If not, then we know that
  # we have to download our zip file.
  filename <- file.path("data", "household_power_consumption.txt")
  if (!file.exists(filename)) {
    fetch.zip("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "power_consumption.zip",
              "./data")
  }
  
  # Next we need to make sure that we have enough memory to
  # actually load the data file. We do that by checking the
  # size of the file (in bytes), against the available memory.
  #
  # You can see more about the memory.has() function below.
  filesize <- file.info(filename)$size
  if (!memory.has(filesize)) {
    stop("Your system does not have enough memory to load the data file.")
  }

  # Here we are opening the entire data set, and then subsetting
  # it to only have the data from February 1st and 2nd of 2017.
  data <- read.table(filename, header=TRUE, sep=";", as.is=TRUE)
  data <- subset(data, Date == "1/2/2007" | Date == "2/2/2007")
  
  # Convert the date column to have date objects, rather than strings.
  data$Date <- dmy(data$Date)
  
  # Return our data.
  data
}

#---------------------------------------------------------------
# Downloads a zip file from the specified url, and then extracts
# the files into the supplied folder. When completed, it will
# remove the download zip file.
#---------------------------------------------------------------
fetch.zip <- function(url, filename, folder) {
  
  # Remove the forward slash at the end of the folder name
  # and then combine the folder name and the filename.
  folder   <- gsub("\\/$", "", folder)
  filepath <- paste0(folder, "/", filename)
  
  if (!file.exists(folder)) {
      dir.create(folder, recursive=TRUE)
  }
  
  # Attempt to download the file.
  tryCatch(download.file(url, filepath, method="curl"), error = function(err) {
    message("Unable to download the supplied zip file.")
    stop(err)
  })
  
  # Unzip the file to the destination folder, which is
  # the same folder that the zip file is located in.
  tryCatch(unzip(filepath, exdir=folder, junkpaths = TRUE), error = function(err) {
    message("Unable to unzip the downloaded file.")
    stop(err)
  })
  
  unlink(filepath, TRUE)
}

#---------------------------------------------------------------
# Check to see if the system has enough memory to handle the
# specified size in bytes
#
# NOTE: This function will only work on linux operating systems,
# as it requires a system() call that only works on linux.
#---------------------------------------------------------------
memory.has <- function(bytes) {
  library(stringr)
  
  # We are retrieving the memory that is available in bytes.
  memory.available <- system('free -b', intern=TRUE)
  memory.available <- as.numeric(str_extract(memory.available[2], "[0-9]+$"))
  
  memory.available > bytes
}