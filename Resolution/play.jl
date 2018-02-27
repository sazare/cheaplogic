## real data
include("loadall.jl")

cmagi=readcore("data/magia.wff")
printcore(cmagi)

cd001=readcore("data/data001.wff")
printcore(cd001)

ctime=readcore("data/time.wff")
printcore(ctime)


## rename steps
c6=clause2of(:C6, cd001)
r11=rename_clause(:R11, c6.vars, c6.body)
r11.cid
r11.vars
r11.body

