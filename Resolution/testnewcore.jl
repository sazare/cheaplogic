# test new core
1
using Base.Test

include("newcore.jl")

@testset "stringtoclause" begin
 @test_skip stringtoclause(:C10, parse("[x].[-P(x),+Q(x,f(x))]")) == CForm2(:C10, [:x], [parse("-P(x)"), parse("+Q(x,f(x))")])
end

# RForm2 == [rid, vars, [lcid, lσ], [rcid, rσ1], 
@testset "resolvent" begin
 
end

@testset "proof" begin
 
 
end

