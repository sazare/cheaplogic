# test for unifybase.jl
using Test
#include("utils.jl") # for isinvar()
#include("unifybase.jl")

#unifybase.jl has common functions for naive and dvc

@testset "loop check" begin
 @test loopcheck(:x,:(g(y)))==false
## not happen case: @test loopcheck(:x,:x)==false
 @test_throws Loop loopcheck(:x,:(g(x)))
 @test_throws Loop loopcheck(:x,:(f(a,g(x))))
 @test loopcheck(:x,:(f(g(y),g(h(y)))))==false
 @test_throws Loop loopcheck(:x,:(f(g(a),g(x))))
 @test_throws Loop loopcheck(:x,:(f(g(x),g(x))))
end

@testset "vindex" begin
 @test 0 == vindex([], :a)
 @test 0 == vindex([:x,:y], :a)
 @test 1 == vindex([:x,:y], :x)
 @test 2 == vindex([:x,:y], :y)
end


