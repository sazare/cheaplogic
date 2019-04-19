# test for subst.jl which has operator over substitution
using Test

#include("subst.jl")

@testset "apply subst" begin
 @test apply([],:(P(x)),[]) == :(P(x))
 @test apply([:x],:x,[:a]) == :a
 @test apply([:x],:(x),[:a]) == :(a)
 @test apply([:x],:(P(x)),[:a]) == :(P(a))
 @test apply([:x,:y],:(P(x,f(y))),[:a,:b]) == :(P(a,f(b)))

 @test apply([:x,:y],:(P(x,y)),[:y,:x]) == :(P(y,x))
 @test apply([:x,:y],:(P(x,y)),[:a,:x]) == :(P(a,x))
 @test apply([:x,:y],:(P(x,y)),[:a,:b]) == :(P(a,b))
 @test apply([:x,:y,:z],:(P(x,y,z)),[:y,:z,:x]) == :(P(y,z,x))
 @test apply([:x,:y,:z],:(P(x,y,z)),[:(f(y,z)),:(f(y,x)),:(f(g(x),h(y)))]) == :(P(f(y,z), f(y,x), f(g(x),h(y))))


end

