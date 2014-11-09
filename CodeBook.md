---
title: "CodeBook"
author: "tharig"
date: "October 12, 2014"
output: html_document
---

Variable descriptions for Plot1.R, Plot2.R, Plot3.R and Plot4.R.

Constants:

filePathPath <- "./Data/household_power_consumption.txt"
    Path and file name information of source data.
    
colNames <- as.character(read.table(filePath, sep=";", nrows=1, as.is=T))
    First row of data used for column variable names.
    
startDate <- dmy_hms("1/2/2007 00:00:00")
endDate <- dmy_hms("2/2/2007 23:59:59")
    starting and ending dates and times for data analysis.  Times are set to include the whole day for the starting and ending days.
    
startSkip <- 66000; maxRead <- 4000
    Values determined by manual inspection of original data and a little bit of testing.  Designed to bracket a subset of the original data to minimize data handling load.
    
labelGAP <- "Global active power"
labelGAPk <- "Global active power (kilowatts)"
    Label values used in two of the plots

Variables:

powerHouse - a data frame to hold a subset of the original data set that includes the desired time period. 

selData - a data frame containing records of the time period for analysis.

