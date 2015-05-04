## Author Truc Viet 'Joe' Le at tjle@andrew.cmu.edu

library(plyr)
library(ggplot2)
library(maptools)
library(rgdal)
library(rgeos)
# library(rmongodb)

## getwd()
## For Mac. setwd("/Users/shiqifanshiqifan/Documents/CMU/S15/MIB/taxi-fare-estimation/")

## Load all taxi GPS traces on Sept. 11, 2009 when occupied
taxi.data <- read.csv(file="./data/filtered-taxiTraj-2009-09-11.csv", header=TRUE)


## Compute the duration between each timestamp
duration <- vector()
trip_indicator <- vector()
threshold <- 5*60 # seconds (5 minutes)

## Create a progress bar
progress.bar <- create_progress_bar("text")
progress.bar$init(nrow(taxi.data)-1)
for(i in 1:(nrow(taxi.data)-1)) {
  this_taxi_no <- taxi.data$taxi_no[i]
  next_taxi_no <- taxi.data$taxi_no[i+1]
  
  if(this_taxi_no == next_taxi_no) {
    this_timestamp <- toString(taxi.data$time[i])
    this_timestamp <- strsplit(this_timestamp, ":")[[1]]
    this_second <- as.numeric(this_timestamp[1])*3600 + as.numeric(this_timestamp[2])*60 + as.numeric(this_timestamp[3])
    
    next_timestamp <- toString(taxi.data$time[i+1])
    next_timestamp <- strsplit(next_timestamp, ":")[[1]]
    next_second <- as.numeric(next_timestamp[1])*3600 + as.numeric(next_timestamp[2])*60 + as.numeric(next_timestamp[3])
    
    duration[i] <- next_second - this_second
    if(i == 1) {
      trip_indicator[i] <- "start"
    } else {
      if(trip_indicator[i-1] == "end" || trip_indicator[i-1] == "error") {
        trip_indicator[i] <- "start"
      } else {
        if(duration[i] >= threshold) {
          trip_indicator[i] <- "end"
        } else {
          trip_indicator[i] <- "going"
        }
      }
    }
  } else {
    duration[i] <- NA
    if(trip_indicator[i-1] == "end") {
      trip_indicator[i] <- "error"
    } else {
      trip_indicator[i] <- "end"
    }
  }
  
  progress.bar$step()
}

duration[nrow(taxi.data)] <- NA
trip_indicator[nrow(taxi.data)] <- "end"
taxi.data$duration <- duration
taxi.data$indicator <- trip_indicator

## Create a progress bar
progress.bar <- create_progress_bar("text")
progress.bar$init(nrow(taxi.data))
or.data <- data.frame() # data frame for the origins
dest.data <- data.frame() # data frame for the destinations
for(i in 1:nrow(taxi.data)) {
  indicator <- taxi.data$indicator[i]
  if(indicator == "start") {
    or_lon <- taxi.data$lon[i]
    or_lat <- taxi.data$lat[i]
    or_data <- data.frame(or_lon = or_lon, or_lat = or_lat)
    or.data <- rbind(or.data, or_data)
  } else if(indicator == "end") {
    dest_lon <- taxi.data$lon[i]
    dest_lat <- taxi.data$lat[i]
    dest_data <- data.frame(dest_lon = dest_lon, dest_lat = dest_lat)
    dest.data <- rbind(dest.data, dest_data)
  } else {
    ## Do nothing
  }
  
  progress.bar$step()
}

## Combine the OD pairs
od.data <- cbind(or.data, dest.data)

## save the result set
write.csv(od.data, file = "./data/taxiTraj-trip-2009-09-11.csv")
