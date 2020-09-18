# test for viewreso.jl
using Test
#include("load_cheaplogic.jl")
include("viewreso.jl")

e1=LForm2(:L1, :(+(fff(2,3))))
e2=LForm2(:L2, :(+(kkk(2,3))))
e3=LForm2(:L3, :(-(ggg(2))))

fff(x,y) = x+y
ggg(x) = x^2

@testset "isProc" begin
 @test isProc(e1) == true
 @test isProc(e2) == false
 @test isProc(e3) == true
end

cano="""
&[NAME,ID].[P(NAME, ID)]
&[NAME,AGE].[Q(NAME, AGE)]
&[ID,CARD].[Pay(ID,CARD)]
"""
cc = readcore(IOBuffer(cano))

e1=LForm2(:L1, :(+(P(ooo,3))))
e2=LForm2(:L2, :(+(nop(2,3))))
e3=LForm2(:L3, :(-(Pay(ooo,1033))))

@testset "isCano" begin

 @test isCano(e1, cc) == true
 @test isCano(e2, cc) == false
 @test isCano(e3, cc) == true
 
end

cnf="""
[x].[-P(x,a)]  #L2
[x,y].[+R(x,y)] #L1
[z].[-Q(a,b,z)] #L3
[x,y,z].[-Q(x,y,z)] #L4
&[NAME, AGE].[P(NAME, AGE)]
&[DOME!,ZOOM].[R(DOME!,ZOOM)]
&[W1!,W2!,W3].[Q(W1!,W2!,W3)]
"""
c1=readcore(IOBuffer(cnf))

@testset "cano's" begin
 @test canoof(:L2,c1) == ([:NAME,:AGE], :(P(NAME,AGE)))
 @test canovarsof(:L1,c1) == [:DOME!, :ZOOM]
 @test canolitof(:-, :L3, c1)==:(-(Q(W1!,W2!,W3)))
 @test canolitof(:+, :L3, c1)==:(+(Q(W1!,W2!,W3)))
end

@testset "incount" begin
 @test incount(:L2, c1) == 0
 @test incount(:L1, c1) == 1
 @test incount(:L3, c1) == 0
 @test incount(:L4, c1) == 2
end


cnf2="""
[x].[-P(x,a)]                         #C1=L4
[x,y,z].[+R(x,y),-Q(a,b,z),-Q(x,y,z)] #C2=L1,L2,L3
[x,y,z].[-Q(a,b,z),-Q(x,y,z)]         #C3=L8,L9
[x,y,z].[+R(x,y),-Q(x,y,z),-Q(a,z,z)] #C4=L10,L11,L12
[x].[-S(x),-P(x,a)]                   #C5=L13,L14
[x,z].[-S(x),-Q(x,a,z),-P(x,y)]       #C6=L5,L6,L7
&[NAME, AGE].[P(NAME, AGE)]
&[DOME!,ZOOM].[R(DOME!,ZOOM)]
&[W1!,W2!,W3].[Q(W1!,W2!,W3)]
"""
c2=readcore(IOBuffer(cnf2))

eee(x,y) = x==y

cnf3="""
[x].[-E(x,a)]                           #C1                
[x,y,z].[+E(x,y),-F(a,b,z),-F(x,y,z)]   #C2
[x,y,z].[+F(a,b,z),+F(x,y,z)]           #C3
[x,y,z].[+eee(3,3),-F(x,y,z),-R(a,z,z)] #C4
[x].[-S(x),-eee(2,2)]                   #C5
[x,z].[-S(x),-Q(x,a,z),-P(x,y)]         #C6
&[NAME, AGE].[P(NAME, AGE)]
&[DOME!,ZOOM].[R(DOME!,ZOOM)]
&[W1!,W2!,W3].[Q(W1!,W2!,W3)]
"""
c3=readcore(IOBuffer(cnf3))

@testset "chooselit" begin
 @test choosecanoid(:C1, c2) == :L4  ## only literal
 @test choosecanoid(:C2, c2) == :L2  ## L1 has 1 in, L2 has 0
 @test choosecanoid(:C3, c2) == :L8  ## L8 has 0
 @test choosecanoid(:C4, c2) == :L10 ## L10 has 1, L11 has 2, L12 has 1 
 @test choosecanoid(:C5, c2) == :L14 ## L13 is not cano, L14 has 0
 @test choosecanoid(:C6, c2) == :L7  ## L5 is not cano, L6 has 1, L7 has 0

 @test choosecanoid(:C1, c3) == nothing
 @test choosecanoid(:C2, c3) == nothing
 @test choosecanoid(:C3, c3) == nothing
 @test choosecanoid(:C4, c3) == :L12
 @test choosecanoid(:C5, c3) == nothing
 @test choosecanoid(:C6, c3) == :L7
end


