include("tact.jl")

using Base.Test

@testset "proof step construction" begin
 @test makeproof(:resolution, [:x], parse("(+P(x,a))"), 1, [:x], parse("(-P(x,x))"),1, [:v], EmptyClause, [:a]) == [:resolution, Symbol[:x], (:(+(P(x, a))), 1, Symbol[:x]), (:(-(P(x, x))), 1, Symbol[:v]), (:([]), Symbol[:a])]

 @test makeproof(:reduction, [:x], parse("+P(x,a),+P(x,x)"), 1, 2, parse("(+P(a,a))"), [:a]) == [:reduction, [:x],(:((+(P(x, a)), +(P(x, x)))), 1, 2), (:(+(P(a, a))), Symbol[:a])]

end


pr1=[makeproof(:resolution, [:x], parse("(+P(x,a))"), 1, [:x], parse("(-P(x,x))"),1, [:v], EmptyClause, [:a]), 
 makeproof(:reduction, [:x], parse("+P(x,a),+P(x,x)"), 1, 2, parse("(+P(a,a))"), [:a])
]

pr2=[
makeproof(:resolution, [:x], parse("(+P(x,a))"), 1, [:x], parse("(-P(x,x))"),1, [:v], EmptyClause, [:a]), 
makeproof(:resolution, [:x], parse("+P(x,a),+Q(x,a)"), 1, [:x], parse("(-P(x,x))"),1, [:v], parse("(+Q(a,a))"), [:a]), 
makeproof(:reduction, [:x], parse("+P(x,a),+P(x,x)"), 1, 2, parse("(+P(a,a))"), [:a])
]


