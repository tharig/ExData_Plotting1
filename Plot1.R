#####################################################################################################
##  Project 1  Plot 1
##    Draw the first plot and save to PNG file
#####################################################################################################
##  setup
setwd("/Volumes/MBP_VMs/VM_Share/Coursera_Fall2014/EDAv2/CourseProject1/WorkingDirectory")
dataDir <- "./Data"
dir.create(dataDir); dir.create("./figure")  ##  if needed, create subdirectories
##  use lower case 'f' to match forked repository

remoteZip_Loc <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
localZip_Loc <- "./Data/compressedFile.zip"

if(!file.exists(localZip_Loc)){
  download.file(remoteZip_Loc, localZip_Loc, method="curl")
}
localFileName <- unzip(localZip_Loc, list=T)$Name
localFilePath <- paste(dataDir, "/", localFileName, sep="")

if(!file.exists(localFilePath)){
  unzip(localZip_Loc, exdir=dataDir, unzip="internal")
}
colNames <- as.character(read.table(localFilePath, sep=";", nrows=1, as.is=T))

library(lubridate)
startDate <- dmy_hms("1/2/2007 00:00:00"); endDate <- dmy_hms("2/2/2007 23:59:59")
startSkip <- 66000; maxRead <- 4000  ##  bracket desired data to minimize data handling load

labelGAP <- "Global active power"
labelGAPk <- "Global active power (kilowatts)"
##  setup complete
##  load data to DF object
powerHouse <- read.table(localFilePath, header=T, sep=";", as.is=T, na.string="?", 
                         skip=startSkip, nrows=maxRead, col.names=colNames)

##  combine Date and Time variables; convert to Posix format
powerHouse[ , "DateTime"] <- paste(powerHouse$Date, powerHouse$Time, sep=" ")
powerHouse[ , "DateTime"] <- dmy_hms(powerHouse[ , "DateTime"])

##  select data in date range
selData <- powerHouse[powerHouse$DateTime >= startDate & powerHouse$DateTime <=endDate, ]

##  Setup Plot 1 to display as 1x1 grid
par(mfrow = c(1, 1))  ##  This step corrects par(mfrow...) setting if plot 4 is run first
##  Plot 1 Function  (Note: plotting commands are defined as a function to facilitate making plot 4.)
drawPlot_1 <- function(){
  hist(selData[ , "Global_active_power"], 
       col="red", 
       main=labelGAP, 
       xlab=labelGAPk)
}
##  Draw and save
drawPlot_1()
dev.copy(png, file ="./figure/plot1.png"); dev.off()

#####################################################################################################
