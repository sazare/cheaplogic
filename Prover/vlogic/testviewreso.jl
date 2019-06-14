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
&P(NAME, ID)
&Q(NAME, AGE)
&Pay(ID,CARD)
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
