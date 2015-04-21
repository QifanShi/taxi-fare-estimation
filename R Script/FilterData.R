## get gps data
taxiTraj <- read.csv("C:/Users/Qifan/Documents/CMU/MIB/taxi_gps_2009_09_11.csv")

## get income data
taxiInc <- read.csv("C:/Users/Qifan/Documents/CMU/MIB/taxiIncome-2009-09-11-full.csv")

## filter taxiInc by type = 1
taxiInc <- taxiInc[taxiInc$taxi_type == "1",]

## filter taxiInc based on taxi_no in taxiTraj
taxi_no_lis <- intersect(unique(taxiTraj$taxi_no), unique(taxiInc$taxi_no)) ## 488 unique value

## filter taxiTraj and taxiInc by taxi_no_lis
new_taxiTraj <- taxiTraj[taxiTraj$taxi_no %in% taxi_no_lis, ]
new_taxiInc <- taxiInc[taxiInc$taxi_no %in% taxi_no_lis, ]


write.csv(new_taxiTraj, "C:/Users/Qifan/Documents/CMU/MIB/filtered-taxiTraj-2009-09-11.csv")
write.csv(new_taxiInc, "C:/Users/Qifan/Documents/CMU/MIB/filtered-taxiIncome-2009-09-11.csv")