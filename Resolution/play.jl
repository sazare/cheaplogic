## real data
include("loadall.jl")
include("newcore.jl")

magia=readclausefromfile("magia.def")

cmagi=createcore(magia)
printcore(cmagi)

db001=readclausefromfile("data001.def")
cd001=createcore(db001)

printresolvent(:R1, rdb001, cd001)

