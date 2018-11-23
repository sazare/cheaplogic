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

@testset "fp_subst" begin
  @test fp_subst(Dict(:x=>:x, :y=>:y)) == Dict(:x=>:x,:y=>:y)
  @test fp_subst(Dict(:x=>:x, :y=>:a)) == Dict(:x=>:x,:y=>:a)
  @test fp_subst(Dict(:x=>:(f(y)), :y=>:a)) == Dict(:x=>:(f(a)),:y=>:a)
  @test fp_subst(Dict(:x=>:a, :y=>:(f(x)))) == Dict(:x=>:a,:y=>:(f(a)))
  @test fp_subst(Dict(:x=>:a,:y=>:(f(x,z)),:z=>:b)) == Dict(:x=>:a,:y=>:(f(a,b)),:z=>:b)
  @test fp_subst(Dict(:x=>:x,:y=>:(f(g(z,w),h(w))),:z=>:(k(w)),:w=>:(m(a)))) == Dict(:x=>:x,:y=>:(f(g(k(m(a)),m(a)),h(m(a)))),:z=>:(k(m(a))),:w=>:(m(a)))
   
end

@testset "is" begin
  @test isconst(Dict(:x=>:x, :y=>:y), :a)
  @test isvar(Dict(:x=>:x, :y=>:y), :x)
  @test isvar(Dict(:x=>:x, :y=>:y), :y)
  @test !isvar(Dict(:x=>:x, :y=>:y), :(f(x,y)))
  @test !isconst(Dict(:x=>:x, :y=>:y), :(f(x,y)))
  

end


@testset "unify" begin
  @test_throws Fail(:a,:b,:unifySS)  unify(Dict(:x=>:x,:y=>:y),:a, :b)
#  @test_throws Fail  unify(Dict(:x=>:x,:y=>:y),:a, :b)

  @test unify(Dict(:x=>:x, :y=>:y), :x, :x) == Dict(:x=>:x, :y=>:y)
  @test unify(Dict(:x=>:x, :y=>:y), :x, :y) == Dict(:x=>:y, :y=>:y)
  @test unify(Dict(:x=>:x, :y=>:y), :a, :y) == Dict(:x=>:x, :y=>:a)
  @test unify(Dict(:x=>:x, :y=>:y), :x, :a) == Dict(:x=>:a, :y=>:y)

#  @test unify(Dict(:x=>:x, :y=>:y), :(f(x,b)), :y) == Dict(:x=>:x, :y=>:(f(x,b)))
#  @test unify(Dict(:x=>:x, :y=>:y), :x, :(f(x,b))) == Dict(:x=>:(f(x,b)),:y=>:y)
#  @test unify(Dict(:x=>:x, :y=>:y), :(f(x,y)), :(f(x,y))) == Dict(:x=>:x, :y=>:y)
#  @test unify(Dict(:x=>:x, :y=>:y), :(f(a,y)), :(f(x,b))) == Dict(:x=>:a, :y=>:b)
#  @test unify(Dict(:x=>:x, :y=>:y), :(f(g(a)),y)), :(f(x,b))) == Dict(:x=>:(g(a)), :y=>:b)
#  @test unify(Dict(:x=>:x, :y=>:y), :(f(g(y)),y)), :(f(x,b))) == Dict(:x=>:a, :y=>:b)

end

