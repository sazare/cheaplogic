#sample for directed by adjecnt matrix

library(igraph)

source("mjda.r")

nv = 16
# 16 = sqrt(length(ad))
rgr = graph.adjacency(matrix(mjda, ncol=nv, nrow=nv))

gr = simplify(rgr, remove.loop=T)

quartz()
plot(gr)

