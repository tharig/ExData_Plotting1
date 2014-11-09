#####################################################################################################
##  Project 1 Plot 4
##    Draw all four plots in one image, save the image to a PNG file
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

##  Plot 2  Function
drawPlot_2 <- function(){
  with(selData, 
       plot(DateTime, Global_active_power, 
            type="l", 
            ylab=labelGAPk, xlab=""))
}
##  Plot 3 Function
##    modified to reduce the size of the legend
drawPlot_3 <- function(){
  with(selData, plot(DateTime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
  with(selData, points(DateTime, Sub_metering_1, type="l"))
  with(selData, points(DateTime, Sub_metering_2, type="l", col="red"))
  with(selData, points(DateTime, Sub_metering_3, type="l", col="blue"))
  legend("topright", pch="_", lwd=2, col=c("black", "red", "blue"),, cex=0.5,
         legend=c(colNames[7], colNames[8], colNames[9]))
}

##  Setup Plot 4 to display as 2x2 grid
par(mfrow = c(2, 2))
##  Plot 4a same as plot 2
drawPlot_2()
##  Plot 4b, DateTime vs. Voltage
with(selData, plot(DateTime, Voltage, type="l"))
##  Plot 4c, same as plot 3
drawPlot_3()
##  Plot 4d, DateTime vs. Global_reactive_power
with(selData, plot(DateTime, Global_reactive_power, type="l"))
##  Save composite image as PNG file
dev.copy(png, file ="./figure/plot4.png"); dev.off()

#####################################################################################################
