##  use this to read  only as much data as needed
read.table(file, sep = ";", skip = , nrows = )
##  determine: the start of the needed data (skip value);
##  and the length of the data needed (nrows value)

library(lubridate)

filePath <- "./Data/household_power_consumption.txt"

powerHouse <- read.table(filePath, sep=";", as.is=T, nrows=6, header=T)
head(powerHouse)
str(powerHouse)

colNames <- read.table(filePath, sep=";", nrows=1, as.is=T)
colNames <- as.character(colNames)
str(colNames)

powerHouse <- read.table(filePath, sep=";", skip=1, nrows=100, as.is=T, col.names=colNames)
str(powerHouse)

powerHouse <- read.table(filePath, header=T, sep=";", na.strings="?", as.is=T)  ##  whole table
str(powerHouse)

day1 <- dmy("16/12/2006")
day2 <- dmy("21/12/2006")
day3 <- dmy("16/10/2006")
day1 < day2

powerHouse <- read.table(filePath, header=T, sep=";", as.is=T, skip=66000, nrows=3000, col.names=colNames)
head(powerHouse); str(powerHouse)

powerHouse <- read.table(filePath, sep=";", skip=1, nrows=100, as.is=T, col.names=colNames)
powerHouse[ , "Date"] <- dmy(powerHouse[ , "Date"])
str(powerHouse)

startDate <- dmy("1/2/2007"); endDate <- dmy("2/2/2007")
startDate; endDate

powerHouse[15, "Date"]
<= endDate & powerHouse[15, "Date"] >= startDate

powerHouse <- read.table(filePath, header=T, sep=";", as.is=T, skip=66000, nrows=3000, col.names=colNames)
powerHouse[ , "Date"] <- dmy(powerHouse[ , "Date"])
powerHouse[ , "Time"] <- hms(powerHouse[ , "Time"])
str(powerHouse); powerHouse[]

selData <- powerHouse[powerHouse$Date >= startDate & powerHouse$Date <=endDate, ]
str(selData)
length(selData); 
##sum(selData, na.rm=T); 
##[((powerHouse$Date >= startDate) & (powerHouse$Date <= endDate))]
##str(selData)

hist(selData[ , "Global_active_power"], 
     col="red", 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")

startSkip <- 66000; maxRead <- 4000  ##  bracket desired data to minimize data handling load
powerHouse <- read.table(filePath, header=T, sep=";", as.is=T, na.string="?", 
                         skip=startSkip, nrows=maxRead, col.names=colNames)
powerHouse[ , "DateTime"] <- paste(powerHouse$Date, powerHouse$Time, sep=" ")
powerHouse[ , "DateTime"] <- dmy_hms(powerHouse[ , "DateTime"])
powerHouse[ , "DoW"] <- wday(powerHouse[ , "DateTime"], label=T)
str(powerHouse);


#####################################################################################################
##  Project 1 WIP1

library(lubridate)
filePath <- "./Data/household_power_consumption.txt"
colNames <- as.character(read.table(filePath, sep=";", nrows=1, as.is=T))
startDate <- dmy_hms("1/2/2007 00:00:00"); endDate <- dmy_hms("2/2/2007 23:59:59")
startSkip <- 66000; maxRead <- 4000  ##  bracket desired data to minimize data handling load
labelGAP <- "Global active power"
labelGAPk <- "Global active power (kilowatts)"

powerHouse <- read.table(filePath, header=T, sep=";", as.is=T, na.string="?", 
                         skip=startSkip, nrows=maxRead, col.names=colNames)
##  combine Date and Time variables; convert to Posix format
powerHouse[ , "DateTime"] <- paste(powerHouse$Date, powerHouse$Time, sep=" ")
powerHouse[ , "DateTime"] <- dmy_hms(powerHouse[ , "DateTime"])
##  select data in date range
selData <- powerHouse[powerHouse$DateTime >= startDate & powerHouse$DateTime <=endDate, ]

##  Plot 1
drawPlot_1 <- function(){
hist(selData[ , "Global_active_power"], 
     col="red", 
     main=labelGAP, 
     xlab=labelGAPk)
}
drawPlot_1()
dev.copy(png, file ="plot1.png"); dev.off()

##  Plot 2  ##
drawPlot_2 <- function(){
  with(selData, 
     plot(DateTime, Global_active_power, 
          type="l", 
          ylab=labelGAPk, xlab=""))
}
drawPlot_2()
dev.copy(png, file ="plot2.png"); dev.off()

##  Plot 3
drawPlot_3 <- function(){
  with(selData, plot(DateTime, Sub_metering_1, type="n", ylab="Energy sub metering", xlab=""))
  with(selData, points(DateTime, Sub_metering_1, type="l"))
  with(selData, points(DateTime, Sub_metering_2, type="l", col="red"))
  with(selData, points(DateTime, Sub_metering_3, type="l", col="blue"))
  legend("topright", pch="_", lwd=2, col=c("black", "red", "blue"), 
         legend=c(colNames[7], colNames[8], colNames[9]))
}
drawPlot_3()
dev.copy(png, file ="plot3.png"); dev.off()

##  Setup for Plot 4
par(mfrow = c(2, 2))
##  Plot 4a same as plot 2
drawPlot_2()
##  Plot 4b, DateTime vs. Voltage
with(selData, plot(DateTime, Voltage, type="l"))
##  Plot 4c, same as plot 3
drawPlot_3()
##  Plot 4d, DateTime vs. Global_reactive_power
with(selData, plot(DateTime, Global_reactive_power, type="l"))
dev.copy(png, file ="plot4.png"); dev.off()


