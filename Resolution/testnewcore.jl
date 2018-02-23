# test new core
1
using Base.Test

include("newcore.jl")

@testset "stringtoclause" begin
 @test stringtoclause(:C10, parse("[x].[-P(x),+Q(x,f(x))]")) == (:C10, [:x], [parse("-P(x)"), parse("+Q(x,f(x))")])

end


