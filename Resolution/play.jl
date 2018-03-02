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

## readclause from string
cc=readcore(IOBuffer("[x].[+P(x)]\n[].[-Q(a)]"))
printcore(cc)

## read entire file and create core

dd1=readstring("data/data001.wff")
cc1=readcore(IOBuffer(dd1))
printcore(cc1)

#dd1 is
sd1 = "@ 1st example\nGoal\n[y].[-Q(a,y)]\n [x,y].[-Q(x,y)]\n\nFact\n[y].[+P(a,y)]\n[y].[+P(b,y)]\n[x].[+R(x,x)]\n[x].[+R(a,c)]\n\n\nTheory\n[x,y].[-P(x,y),+Q(x,y),-R(x,y)]\n[x,y].[-P(x,f(y)),+Q(x,y),-R(x,y)]\n"

sc1=readcore(IOBuffer(sd1))
printcore(sc1)

#resolution

### resolution step (image)
print("\nstep1 R1 = <L1,L6>")
printclause(:C2, cd001)
printclause(:C7, cd001)
r1= dvc_resolution(:L1, :L6, cd001)
printclause(:R1, cd001)

print("\n\nstep1 R2 = <L7R1, L2>")
printclause(:C1, cd001)
r2= dvc_resolution(:L7R1, :L2, cd001)
printclause(:R2, cd001)

print("\n\nstep1 R3 = <L8R1R2, L10>")
printclause(:C4, cd001)
r3= dvc_resolution(:L8R1R2, :L10, cd001)
printclause(:R3, cd001)

println("\n\n final core")
printcore(cd001)



