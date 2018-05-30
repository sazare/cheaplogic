#test for simpleprover(now in dvcreso.jl)

using Base.Test

include("loadall.jl")

@testset "basic prover" begin
 r001,c001=simpleprover(IOBuffer(
"[x].[-P(x)]
[x].[+P(x),-Q(x)]
[x].[+Q(x)]",
), 5,1)

 @test length(contradictionsof(c001))==1

 r002,c002=simpleprover(IOBuffer(
"[X].[-P(X)]
[x].[+P(x),-Q(x)]
[x].[+Q(a)]",
), 5,1)

 @test length(contradictionsof(c002))==1


end

