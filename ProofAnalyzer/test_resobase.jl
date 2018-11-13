# test for resobase.jl
using Test

include("resobase.jl")

#@testset "make_binding" begin
# b1 = make_binding([:x], :a)
# @test b1[:x] == :a_1
# b2 = make_binding([:x,:y,:z], :right)
# @test b2[:x] == :right_1
# @test b2[:y] == :right_2
# @test b2[:z] == :right_3
#end

@testset "make_binding2" begin
  b1 = make_binding2([:x],[:a])
  @test b1[:x] == :a
  b2 = make_binding2([:x,:y,:z],[:a,:b,:c])
  @test b2[:x] == :a
  @test b2[:y] == :b
  @test b2[:z] == :c
end

@testset "represent_as" begin
 b1 = make_binding2([:x,:y,:z],[:a,:b,:c]) 
 @test represent_as(b1, [:y,:x,:x,:z]) == [:b,:a,:a,:c]
# @test represent_as(b1, :(P(x,y,x))) == :(P(a,b,a))
end

#@testset "subst" begin
# @test subst([],:(P(x)),[]) == :(P(x))
# @test subst([:x],:x,[:a]) == :a
# @test subst([:x],:(x),[:a]) == :(a)
# @test subst([:x],:(P(x)),[:a]) == :(P(a))
# @test subst([:x,:y],:(P(x,f(y))),[:a,:b]) == :(P(a,f(b)))
#
## [:x,:y] <- [:a,:x] is incorrect. 
# @test subst([:x,:y],:(P(x,y)),[:a,:x]) == :(P(a,x))
# @test subst([:x,:y],:(P(x,y)),[:a,:x]) != :(P(a,a))
#
#end

