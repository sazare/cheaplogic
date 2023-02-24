#sample for directed by adjecnt matrix

library(igraph)

source("mjda.r")

s = sqrt(length(mjda))
rgr = graph.adjacency(matrix(mjda, ncol=s, nrow=s))
gr = simplify(rgr, remove.loop=T)

# s == length(vertex_attr(gr, "label"))

for (i in 1:s){
  vertex_attr(gr, "label", i) = (i-1)
}

quartz()
plot(gr)

tkplot(gr)
