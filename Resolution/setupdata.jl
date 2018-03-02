include("loadall.jl")

magia=readclausefromfile("data/magia.wff")
cmagi=createcore(magia)

data001=readclausefromfile("data/data001.wff")
cd001=createcore(data001)

ctime=readcore("data/time.wff")
printcore(ctime)



