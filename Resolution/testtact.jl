include("tact.jl")

using Base.Test

@testset "proof step construction" begin
 @test makeastep(:resolution, [:x], parse("[+P(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], EmptyClause, [:a]) == [:resolution, Symbol[:x], (:([+(P(x, a))]), 1, Symbol[:x]), (:([-(P(x, x))]), 1, Symbol[:v]), (:([]), Symbol[:a])]

 @test makeastep(:reduction, [:x], parse("[+P(x,a),+P(x,x)]"), 1, 2, parse("[+P(a,a)]"), [:a]) == [:reduction, [:x],(:([+(P(x, a)), +(P(x, x))]), 1, 2), (:([+(P(a, a))]), Symbol[:a])]

end

##== for test only. not correct proofs

pr1=[makeastep(:resolution, [:x], parse("[+P(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], EmptyClause, [:a]), 
 makeastep(:reduction, [:x], parse("[+P(x,a),+P(x,x)]"), 1, 2, parse("[+P(a,a)]"), [:a])
]

pr2=[
makeastep(:resolution, [:x], parse("[+P(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], EmptyClause, [:a]), 
makeastep(:resolution, [:x], parse("[+P(x,a),+Q(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], parse("[+Q(a,a)]"), [:a]), 
makeastep(:reduction, [:x], parse("[+P(x,a),+P(x,x)]"), 1, 2, parse("[+P(a,a)]"), [:a])
]


