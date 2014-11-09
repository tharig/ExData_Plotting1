#####################################################################################################
##  Project 1 Plot 3
##    Draw plot 3, save to PNG file
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

##  Setup Plot 3 to display as 1x1 grid
##  This step corrects par(mfrow...) setting if plot 4 is run first
par(mfrow = c(1, 1))
##  Plot 3  Function
drawPlot_3 <- function(){
  with(selData, plot(DateTime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
  with(selData, points(DateTime, Sub_metering_1, type="l"))
  with(selData, points(DateTime, Sub_metering_2, type="l", col="red"))
  with(selData, points(DateTime, Sub_metering_3, type="l", col="blue"))
  legend("topright", pch="_", lwd=2, col=c("black", "red", "blue")
         legend=c(colNames[7], colNames[8], colNames[9]))
}
##  Draw and save file
drawPlot_3()
dev.copy(png, file ="./figure/plot3.png"); dev.off()

#####################################################################################################
