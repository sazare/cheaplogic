# test new core

using Base.Test

include("newcore.jl")

@testset "stringtoclause" begin
 sc = stringtoclause(:C10, parse("[x].[-P(x),+Q(x,f(x))]")) 
 @test sc.cid  == :C10
 @test sc.vars ==  [:x]
 @test sc.body ==  [parse("-P(x)"), parse("+Q(x,f(x))")]

end

@testset "xid" begin
 @test cidof(123) == :C123
 @test lidof(3339) == :L3339
 @test ridof(233) == :R233

end

