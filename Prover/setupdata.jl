include("load_cheaplogic.jl")

magia=readclausefromfile("data/magia.cnf")
cmagi=createcore(magia)

data001=readclausefromfile("data/data001.cnf")
cd001=createcore(data001)

ctime=readcore("data/time.cnf")
printcore(ctime)



