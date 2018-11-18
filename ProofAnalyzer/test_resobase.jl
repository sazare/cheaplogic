# test for test_resobase.jl
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
 b0 = Dict()
 @test represent_as(b0, [:y,:x,:x,:z]) == [:y,:x,:x,:z]

 b1 = make_binding2([:x,:y,:z],[:a,:b,:c]) 
 @test represent_as(b1, [:y,:x,:x,:z]) == [:b,:a,:a,:c]
# @test represent_as(b1, :(P(x,y,x))) == :(P(a,b,a))
end


@testset "mapexpr" begin
 fn0(x) = x
 @test mapexpr(fn0, Meta.parse("P(x,f(y))")) == Meta.parse("P(x,f(y))")

 b1 = make_binding2([:x,:y],[:a,:b])
 fn1(x) = get(b1,x,x)
 @test mapexpr(fn1, Meta.parse("P(x,f(y))")) == Meta.parse("P(a,f(b))")

end

@testset "subst" begin
  @test subst(Dict(),:(P(x))) == :(P(x))
  @test subst(Dict(:x=>:a),:x) == :a
  @test subst(Dict(:x=>:a),:(x)) == :(a)
  @test subst(Dict(:x=>:a),:(P(x))) == :(P(a))
  @test subst(Dict(:x=>:a, :y=>:b),:(P(x,f(y)))) == :(P(a,f(b)))

  @test subst(Dict(:x=>:(f(a,b)), :y=>:b),:(P(x,g(y,b)))) == :(P(f(a,b),g(b,b)))
  @test subst(Dict(:x=>:(f(a,b)), :y=>:b, :z=>:w),:(P(x,g(y,w),z))) == :(P(f(a,b),g(b,w),w))

# [:x,:y] <- [:a,:x] is incorrect. 
  @test subst(Dict(:x=>:a,:y=>:x),:(P(x,y))) == :(P(a,x))
  @test subst(Dict(:x=>:a,:y=>:x),:(P(x,y))) != :(P(a,a))
end

