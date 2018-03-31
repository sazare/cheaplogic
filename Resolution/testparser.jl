# testparser.jl
using Base.Test
include("parser.jl")

@testset "atomic" begin
 @test parser("P(x)")[1] == [:P :x]

 @test parser("P(x) or Q(x)")[1] == [:or [:P :x] [:Q :x]]
 @test parser("P(x) or Q(x) or R(x)")[1] == [:or [:P :x] [:Q :x] [:R :x]]
 @test parser("P(x) and Q(x)")[1] == [:and [:P :x] [:Q :x]]
 @test parser("P(x) and Q(x) and R(x)")[1] == [:and [:P :x] [:Q :x][:R :x]]
 @test parser("P(x) then Q(x)")[1] == [:then [:P :x] [:Q :x]]
 @test parser("P(x) iff Q(x)")[1] == [:iff [:P :x] [:Q :x]]

 @test parser("forall x P(x)")[1] == [:forall [:x] [:P :x]]
 @test parser("exist x P(x)")[1] == [:exist [:x] [:P :x]]

end

