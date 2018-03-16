## real data
using Base.Test

include("loadall.jl")

#==
cmagi=readcore("data/magia.wff")
printcore(cmagi)

cd001=readcore("data/data001.wff")
printcore(cd001)

cd002=readcore("data/data002.wff")
printcore(cd002)


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

# templates
println("make all templates")
aeq = alltemplateof(cd001)
printcore(cd001)

printtemplates0(cd001.level0, cd001)
printtemplates1(aeq, cd001)


# resolution
print("\nstep1 R1 = <L1,L6>")
printclause(:C2, cd001)
printclause(:C7, cd001)
r1= dvc_resolution(:L1, :L6, cd001)
printclause(:R1, cd001)

print("\n\nstep1 R2 = <L7_R1, L2>")
printclause(:C1, cd001)
r2= dvc_resolution(:L7_R1, :L2, cd001)
printclause(:R2, cd001)

print("\n\nstep1 R3 = <L8_R2, L10>")
printclause(:C4, cd001)
r3= dvc_resolution(:L8_R2, :L10, cd001)
printclause(:R3, cd001)

println("\n\n final core")
printcore(cd001)

println(proofcof(:R3, cd001))

itemp1 = alltemplateof(cd001)
applytemp(:L1, cd001)

itemp2 = alltemplateof(cd002)

goal1 = lidsof(:C1, cd002)
gs1 = []
for g1 in goal1
 push!(gs1, applytemp(g1, cd002))
end

#goal2 = lidsof(:R1, cd002)


##### friend3
cf03=readcore("data/friend3.wff")
printcore(cf03)

tf03=alltemplateof(cf03)
tnf=tf03[Symbol("-F")]

g0 = [lidsof(:C1, cf03)]
g1 = dostepgoals(g0, tf03, cf03)
g2 = dostepgoals(g1, tf03, cf03)
g3 = dostepgoals(g2, tf03, cf03)

conds = contradictionsof(cf03)

printaproof1(:R20, cf03)
printaproof0(:R20, cf03)

tpr=templateof(:+, :R, cd002)
 g0=[:L12]
 g1=dostepagoal(g0, tpr, cd002)
 printaproof0(:R3, cd002)
 printaproof0(:R4, cd002)
 printaproof1(:R3, cd002)

cd010=readcore("data/data010.wff")
printcore(cd010)
td010=alltemplateof(cd010)
tnp=td10[Symbol("-P")]
g0=[[:L7]]
g1=dostepagoal(g0[1], tnp, cd010)
==#

function doit(wff)
 cdx=readcore(wff)
# printcore(cdx)
 tdx=alltemplateof(cdx)
 g0=[lidsof(:C1, cdx)]
 #gn=dostepgoals(g0, cdx)
 gn=dostepgoals1(g0, cdx)
 return cdx,tdx,g0,gn
end
#==
@testset "data011" begin
 cdx,td,g0,g1=doit("data/data011.wff")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3[1]) == 4
 @test_skip isempty(g4)
end
@testset "data012" begin
 cdx,td,g0,g1=doit("data/data012.wff")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3[1]) == 4
 @test_skip isempty(g4)
end

@testset "data013" begin
 cdx,td,g0,g1=doit("data/data013.wff")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3) == 2 
 @test length(g3[1]) == 4
 @test length(g3[2]) == 4
 @test_skip isempty(g4)
end

@testset "resolvent was satisfiable" begin
 cdx,td,g0,g1=doit("data/data014.wff")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 @test length(g1[1]) == 2
 @test length(g2[1]) == 3
 @test length(g3[1]) == 4
 cf2=clause2of(:R3,cdx)
 @test satisfiable(cf2.vars, cf2.body)
end
==#
#==
 cdx,td,g0,g1=doit("data/data010.wff")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
==#
rids,cdx = simpleprover("data/data011.wff", 5, 1)
@test rids == :NOCONT
rids,cdx = simpleprover("data/data012.wff", 5, 1)
@test rids == :NOCONT
rids,cdx = simpleprover("data/data013.wff", 5, 1)
@test rids == :NOCONT
rids,cdx = simpleprover("data/data014.wff", 5, 1)
@test rids == :NOCONT

rids,cdx = simpleprover("data/data010.wff", 5, 1)
printaproof1(rids[1], cdx)
printaproof0(rids[1], cdx)

