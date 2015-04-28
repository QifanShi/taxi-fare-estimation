library(igraph)

source("./R Script/Util/plotNetwork.R")

## set west-southern corner as origion (0,0)
## set west and north boundry
w_bound <- 113.756905
s_bound <- 22.446048

## set interval distance
lon_step <- (114.627914 - 113.756905) / 10;
lat_step <- (22.849712 - 22.446048) / 6;

## create a map graph using matrix with 10 columns and 6 rows
map_graph <- matrix( c(1:60), nrow = 6, ncol = 10, byrow= TRUE)

## create a directed graph using matrix with 60 columns and 60 rows
traj_graph <- matrix(0, nrow = 60, ncol = 60)

## for windows
##setwd("C:/Users/Qifan/Documents/GitHub/taxi-fare-estimation/")
trip.data <- read.csv(file="./data/taxiTraj-trip-2009-09-11.csv")
##trip.data <- read.csv(file="./data/taxiTraj-trip-2009-09-11-hour-0-1.csv")

##head(trip.data)

for(i in 1:(nrow(trip.data))){
  ## calculate start node
  s_x <- trunc((trip.data$or_lon[i] - w_bound) / lon_step, digits = 0) + 1 
  s_y <- 6 - trunc((trip.data$or_lat[i] - s_bound) / lat_step, digits = 0)
  s_node <- map_graph[s_y, s_x]
  
  ## calculate end node
  e_x <- round((trip.data$dest_lon[i] - w_bound) / lon_step, digits = 0)
  e_y <- 6 - round((trip.data$dest_lat[i] - s_bound) / lat_step, digits = 0)
  e_node <- map_graph[e_y, e_x]

  traj_graph[s_node, e_node] <- traj_graph[s_node, e_node] + 1
}

## build a social network graph
mode(traj_graph) <- "numeric"
g <- graph.adjacency(traj_graph, weighted=TRUE, mode = "directed")

## give label to each nodes, from 1 to 60
nodeId <- vector()

for(i in 1: length(V(g))){
  nodeId[i] <- i;
}

V(g)$label <- nodeId
## Exclude nodes which do not have any traffic
bad.nodes <- V(g)[degree(g) == 0] # mark unconnected nodes as bad nodes
g <- delete.vertices(g, bad.nodes) 

## remove loops
g <- simplify(g)

V(g)$degree <- degree(g)

##plotNetwork(g, "Test", "./Image/Taxi_SNA.pdf", width=15, height=15)
##plotNetwork(g, "Test", "./Image/Taxi_SNA_Simplify.pdf", width=15, height=15)

##plotNetwork(g, "Test", "./Image/Taxi_SNA_hour_0_1.pdf", width=15, height=15)
##plotNetwork(g, "Test", "./Image/Taxi_SNA_Simplify_hour_0_1.pdf", width=15, height=15)

