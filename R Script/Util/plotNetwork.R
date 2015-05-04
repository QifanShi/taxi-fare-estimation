## Author Qifan Shi
## Reference: : https://github.com/vietexob/mobile-intelligence/

## This function plots the input igraph object 'g' and saves it as a PDF file (if
## a non-empty filename is given).

plotNetwork <- function(g, mainStr="Untitled Graph", filename="", edgeWeight.theta=0,
                        width=10, height=10) {
  require(igraph)
  
  ## Highlight the edges with heavy weights
  max.weight <- max(E(g)$weight)
  weight.factor <- max.weight / 5
  
  if(edgeWeight.theta == 0) {
    summ.edgeWeight <- summary(E(g)$weight)
    edgeWeight.theta <- exp(1) * summ.edgeWeight[3] # the median
  }
  V(g)$size <-  3 * V(g)$degree / max(V(g)$degree)+ 3 ## change node size
  V(g)$label.cex <- 1.5 * V(g)$degree / max(V(g)$degree)+ .4 ## change label size
  E(g)$color <- ifelse(E(g)$weight >= edgeWeight.theta, 'darkorange', 'azure4')
  E(g)$width <- E(g)$weight / weight.factor
  E(g)$arrow.width <- E(g)$width / 2

  
  ## Plot and save the network
  if(nchar(filename) > 0) {
    pdf(file = filename, width=width, height=height)
  }
  op <- par(mai = c(0, 0, 1, 0)) # reduce the sizes of the margins
  
  plot(g, # the network to be plotted
       layout = layout.fruchterman.reingold, # the layout method
       main = mainStr, # specifies the title
       ##vertex.label.dist = 0.1,  # puts the name labels slightly off the dots
       # vertex.frame.color = 'blue', # the color of the border of the dots 
       vertex.label.color = 'black', # the color of the name labels
       ##vertex.label.font = 1,  	# the font of the name labels
       vertex.label = V(g)$name,	# specifies the lables of the vertices
       ##vertex.label.cex = 0.5,		# specifies the size of the font of the labels
       edge.curved = TRUE,
       edge.arrow.size = 1
  )
  
  if(nchar(filename) > 0) {
    dev.off()
  }
  par(op)
}
