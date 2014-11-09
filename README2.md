---
title: "README2"
author: "tharig"
date: "October 12, 2014"
output: html_document
---
Details of the requirements for this project can be found in README.md.

The plot files "plotx.R", where x = 1, 2, 3 or 4 can be run in any order.  Each will save a copy of the plot it generates in the "./figure"" folder.  

Programming Notes:

Reduced size powerHouse data frame:  Values for "startSkip" and "maxRead" were found by manual inspection of the data file.  This reduces the time required to load the data.

selData:  The "selData" data frame contains only the records for the time period 2007-02-01 to 2007-02-02.  Time values are included in the variables "startDate" and "endDate" to include the whole day for each of the dates.

Structureing plot code as functions:  Plots 1, 2 and 3 have the plotting code inside a function.  This maintains consistency with Plot 4 that uses some of the functions.  

