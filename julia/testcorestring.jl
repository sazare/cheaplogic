using Test
include("corestring.jl")

cnf = "[x].[+P(x,a),-Q(x,f(x))]
[].[-P(a,b)]
[].[+Q()]"
cc = readcore(IOBuffer(cnf))

@testset "stringliteral" begin
 @test stringliteral(:(+(P(x)))) == "+(P(x))"
 @test stringliteral(:(+(P(x_C1, a)))) == "+(P(x_C1,a))"
 @test stringliteral(:(-(Q(x_C1, f(x_C1))))) == "-(Q(x_C1,f(x_C1)))"
 @test stringliteral(:(+(Q()))) == "+(Q())"
end


@testset "stringlid" begin
 @test stringlid(:L1, cc) == "L1:-(P(a,b))"
 @test stringlid(:L2, cc) == "L2:+(P(x_C1,a))"
 @test stringlid(:L3, cc) == "L3:-(Q(x_C1,f(x_C1)))"
 @test stringlid(:L4, cc) == "L4:+(Q())"
end
@testset "stringlids" begin
 @test stringlids([:L1,:L2], cc) == "L1:-(P(a,b)),L2:+(P(x_C1,a))"
end

@testset "stringvars" begin
 @test stringvars([]) == "[]"
 @test stringvars([:x,:y]) == "[x,y]"
end

@testset "stringclause" begin
 @test stringclause(:C1, cc) == "C1:[x_C1].[L2:+(P(x_C1,a)),L3:-(Q(x_C1,f(x_C1)))]"
 @test stringclause(:C2, cc) == "C2:[].[L1:-(P(a,b))]"
 @test stringclause(:C3, cc) == "C3:[].[L4:+(Q())]"
end

