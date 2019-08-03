# test for primitives.jl
using Test
#include("primitives.jl")

@testset "vars and const" begin
 @test isvar(:x, [:y,:x]) == true
 @test isvar(:y, [:y,:x]) == true
 @test isvar(:z, [:y,:x]) == false
 @test isvar(12, [:y,:x]) == false
 @test isvar(23.1, [:y,:x]) == false
 @test isvar(0, [:y,:x]) == false
 @test isvar([:a :b], [:y,:x]) == false
 @test isvar([], [:y,:x]) == false

 @test isevar(:Abc, [:Abc, :x]) == true
 @test isevar(:Abc, [:abc, :x]) == false
 @test isevar(:dbc, [:abc, :x]) == false

 @test isconst(:x, [:y,:x]) == false
 @test isconst(:a, [:y,:x]) == true
 @test isconst(12, [:y,:x]) == true
 @test isconst(23.1, [:y,:x]) == true
 @test isconst(0, [:y,:x]) == true
 @test isvar([:a :b], [:y,:x]) == false
 @test isvar([], [:y,:x]) == false

end

@testset "isground" begin
 @test isground([], 123)
 @test isground([], "abcd")
 @test isground([], 'x')

 @test isground([:x,:y], 123)
 @test isground([:x,:y], "abcd")
 @test isground([:x,:y], 'x')

 @test isground([:x,:y], :x) == false
 @test isground([:x,:y], :(f(x))) == false
 @test isground([:x,:y], :(f(2,x))) == false
 @test isground([:x,:y], :(f(2,4)))

 @test isground([:x,:y], :(f(a,4)))   # is this useful?
 @test isground([:x,:y], :(+(P(a,x)))) == false

 @test isground([:x,:y], [:(+(P(2,3))),:(-(R(5,"abc"))),:(+(Q('c',"aaa")))])
 @test isground([:x,:y], [:(+(P(2,3))),:(-(R(5,"abc"))),:(+(Q(x,"aaa")))]) == false

end

