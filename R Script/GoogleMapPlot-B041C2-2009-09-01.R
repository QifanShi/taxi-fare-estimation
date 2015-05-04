## Author Qifan Shi
## Reference: : https://github.com/vietexob/mobile-intelligence/

## import from a CSV file
taxi.data <- read.csv("C:/Users/Qifan/Documents/CMU/MIB/2009-09-11.csv")

## mapping taxi data

library(ggmap)

## convert characters to numerics
taxi.lon <- as.numeric(taxi.data$lon)
taxi.lat <- as.numeric(taxi.data$lat)

## Give location data to taxi.locs
taxi.locs <- data.frame(taxi.lon, taxi.lat)


## Retrieve a map from Google Maps with center at the means of all the coordinatest
taxi.loc.map <- get_map(location = c(lon = mean(taxi.lon),
                                     lat = mean(taxi.lat)),
                        zoom = 11, scale = 2) 
# scale specifies the resolution of the map, possible values are 1,2, 4
# however 4 is reserved for business value 

## Make a map that plots each taxi location using a little orange dot
taxi.loc.pts <- geom_point(data = taxi.locs, aes(x = taxi.lon, y = taxi.lat,
                                                       fill = "red", alpha = 0.50),
                             size = 1, shape = 21)
## This line overlays the taxi location locations onto the retrieved map
taxi.loc.map <- ggmap(taxi.loc.map) + taxi.loc.pts + guides(fill = FALSE, alpha = FALSE,
                                                            size = FALSE)
## Give the map a title
taxi.loc.map <- taxi.loc.map + ggtitle("Locations of Taxi B041C2 on 1st Sept 2009")

## Add the density contours
taxi.loc.map <- taxi.loc.map + geom_density2d(data = taxi.locs,
                                              aes(x = taxi.lon, y = taxi.lat))
## Print the map
print(taxi.loc.map)

## save plotted image
ggsave(taxi.loc.map, file="C:/Users/Qifan/Documents/CMU/MIB/myPlot8.png")

