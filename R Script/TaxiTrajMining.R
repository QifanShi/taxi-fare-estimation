library(igraph)

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

trip.data <- read.csv(file="./data/taxiTraj-trip-2009-09-11.csv")
##head(trip.data)

for(i in 1:(nrow(trip.data) - 1)){
  ## calculate start node
  s_x <- round((trip.data$or_lon[i] - w_bound) / lon_step, digits = 0)
  s_y <- 6 - round((trip.data$or_lat[i] - s_bound) / lat_step, digits = 0)
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


nodeId <- vector()
for(i in 1: length(V(g))){
  V(g)$label <- V(g)[i]$name
}

V(g)$label <- nodeId
## Exclude nodes which do not have any traffic
bad.nodes <- V(g)[degree(g) == 0] # low-degree nodes
g <- delete.vertices(g, bad.nodes) # f is the new network


V(g)$degree <- degree(g)

V(g)$size <-  8 + log(V(g)$degree) * 3
V(g)$label.cex <- 2.2 * V(g)$degree / max(V(g)$degree)+ .4
V(g)$label.color <- rgb(0, 0, .2, .8)
V(g)$frame.color <- NA
egam <- (log(E(g)$weight)+.4) / max(log(E(g)$weight)+.4)
E(g)$color <- rgb(.5, .5, 0, egam)
E(g)$width <- egam
E(g)$arrow <- egam

# plot the graph in layout1
plot(g, layout=layout.fruchterman.reingold)

