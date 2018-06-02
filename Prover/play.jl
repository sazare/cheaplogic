## real data
using Base.Test

include("loadall.jl")

#==
cmagi=readcore("data/magia.cnf")
printcore(cmagi)

cd001=readcore("data/data001.cnf")
printcore(cd001)

cd002=readcore("data/data002.cnf")
printcore(cd002)

ctime=readcore("data/time.cnf")
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

dd1=readstring("data/data001.cnf")
cc1=readcore(IOBuffer(dd1))
printcore(cc1)

#dd1 is
sd1 = "@ 1st example\nGoal\n[y].[-Q(a,y)]\n [x,y].[-Q(x,y)]\n\nFact\n[y].[+P(a,y)]\n[y].[+P(b,y)]\n[x].[+R(x,x)]\n[x].[+R(a,c)]\n\n\nTheory\n[x,y].[-P(x,y),+Q(x,y),-R(x,y)]\n[x,y].[-P(x,f(y)),+Q(x,y),-R(x,y)]\n"

sc1=readcore(IOBuffer(sd1))
printcore(sc1)

# templates
println("make all templates")
tmpl = alltemplateof(cd001)
printcore(cd001)

printtemplates0(cd001.level0, cd001)
printtemplates1(tmpl, cd001)


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

println("\n\n final core")
printcore(cd001)

println(proofcof(:R2, cd001))

itemp1 = alltemplateof(cd001)
applytemp(:L1, cd001)

itemp2 = alltemplateof(cd002)

goal1 = lidsof(:C1, cd002)
gs1 = []
for g1 in goal1
 push!(gs1, applytemp(g1, cd002))
end



##### friend3
cf03=readcore("data/friend3.cnf")
printcore(cf03)

tf03=alltemplateof(cf03)
tnf=tf03[Symbol("-F")]

g0 = [lidsof(:C1, cf03)]
g1 = dostep1goals(g0, cf03)
g2 = dostep1goals(g1, cf03)
g3 = dostep1goals(g2, cf03)

conds = contradictionsof(cf03)

printaproof1(:R20, cf03)
printaproof0(:R20, cf03)

tpr=templateof(:+, :R, cd002)
 g0=[:L12]
 g1=dostepagoal(g0, cd002)
 printaproof0(:R3, cd002)
 printaproof0(:R4, cd002)
 printaproof1(:R3, cd002)

cd010=readcore("data/data010.cnf")
printcore(cd010)
td010=alltemplateof(cd010)
tnp=td010[Symbol("-P")]
g0=[[:L7]]
g1=dostepagoal(g0[1], cd010)

function doit(cnf)
 cdx=readcore(cnf)
# printcore(cdx)
 tdx=alltemplateof(cdx)
 g0=[lidsof(:C1, cdx)]
 #gn=dostepgoals(g0, cdx)
 gn=dostepgoals1(g0, cdx)
 return cdx,tdx,g0,gn
end
@testset "data011" begin
 cdx,td,g0,g1=doit("data/data011.cnf")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3[1]) == 4
 @test_skip isempty(g4)
end
@testset "data012" begin
 cdx,td,g0,g1=doit("data/data012.cnf")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3[1]) == 4
 @test_skip isempty(g4)
end

@testset "data013" begin
 cdx,td,g0,g1=doit("data/data013.cnf")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 g4=dostepgoals1(g3, cdx)
 @test length(g3) == 2 
 @test length(g3[1]) == 4
 @test length(g3[2]) == 4
 @test_skip isempty(g4)
end

@testset "resolvent was satisfiable" begin
 cdx,td,g0,g1=doit("data/data014.cnf")
 g2=dostepgoals1(g1, cdx)
 g3=dostepgoals1(g2, cdx)
 @test length(g1[1]) == 2
 @test length(g2[1]) == 3
 @test length(g3[1]) == 4
 cf2=clause2of(:R3,cdx)
 @test satisfiable(cf2.vars, cf2.body)
end

 cdx,td,g0,g1=doit("data/data010.cnf")
 g2=dostep1goals(g1, cdx)
 g3=dostep1goals(g2, cdx)
 g4=dostep1goals(g3, cdx)

r11,c11 = simpleprover("data/data011.cnf", 5, 1)
r12,c12 = simpleprover("data/data012.cnf", 5, 1)
r13,c13 = simpleprover("data/data013.cnf", 5, 1)
r14,c14 = simpleprover("data/data014.cnf", 5, 1)
r15,c15 = simpleprover("data/data015.cnf", 5, 1)
r16,c16 = simpleprover("data/data016.cnf", 5, 1)
r17,c17 = simpleprover("data/data017.cnf", 5, 1)

r10,c10 = simpleprover("data/data010.cnf", 5, 1)
printaproof1(r10[1], c10)
printaproof0(r10[1], c10)

rm,cm = simpleprover("data/magia.cnf", 5, 1)
printaproof1(rm[1], cm)
printaproof0(rm[1], cm)

### estimate cnf

r3, c3 = simpleprover("data/data003.cnf", 10, 3)
atl=alltemplateof(c3)
printclauses(c3)
printaproof1(:R1, c3)


tk,ck=simpleprover("data/kuukai.cnf",5,1)
printaproof1(:R2,ck)
tk2,ck2=simpleprover("data/kuukai2.cnf",5,1)
printaproof1(:R2,ck2)

ted,ced=simpleprover("data/everyonedie.cnf",8,1)
printproofs1(ced)

tt2,ct2=simpleprover("data/time2.cnf",6,1)
printproofs1(ct2)

# (a) ok but not (c) maybe loop check
to1,ct1=simpleprover("data/to1.cnf",10,1);printproofs1(ct1)

# ofcouse function z() can't be found
to1,ct1=simpleprover("data/to1.cnf",10,1);printproofs1(ct1)
to2,ct2=simpleprover("data/to2.cnf",10,1);printproofs1(ct2)
to3,ct3=simpleprover("data/to3.cnf",10,1);printproofs1(ct3)

td1,cd1=simpleprover("data/db1.cnf",7,2);printproofs1(cd1)

tq1,cq1=simpleprover("data/20Q01.cnf",20,2);printproofs1(cq1)

# friends law
tf7,cf7=simpleprover("data/friend7.cnf",3,1);printproofs1(cf7)
tf8,cf8=simpleprover("data/friend8.cnf",3,1);printproofs1(cf8)

==#

## Before prooving
cdop001, mdop001=pairmakefromcore("data/dop001.cnf")
printpvms(mdop001, cdop001)

chis001, mhis001=pairmakefromcore("data/his001.cnf")
printpvms(mhis001, chis001)

## After proving
rdop001,cdop001=simpleprover("data/dop001.cnf",20,5)
ccdop001, mdop001=pairmakefromcore(cdop001)
# ccdop001 == cdop001
printpvms(mdop001, cdop001)
printatrace1(:R9, varsof(:C1, cdop001), cdop001)
inf = traceof(cdop001)
inf[1]
inf[2]


