# test new core
1
using Base.Test

include("newcore.jl")

@testset "stringtoclause" begin
 sc = stringtoclause(:C10, parse("[x].[-P(x),+Q(x,f(x))]")) 
 @test sc.cid  == :C10
 @test sc.vars ==  [:x]
 @test sc.body ==  [parse("-P(x)"), parse("+Q(x,f(x))")]

end


