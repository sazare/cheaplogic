## real data
include("loadall.jl")
include("newcore.jl")

magia=readclausefromfile("magia.def")
#magidb=makedb(magia)
#printdb(magidb)

cmagi=createcore(magia)
printcore(cmagi)


