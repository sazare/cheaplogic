# testparser.jl
using Test
#include("parser.jl")

#==
@testset "tokenizer" begin

 @test tokenizer("P(x)") == [:P, :lpar, :x, :rpar]
 @test tokenizer("all.x.P(x)") == [:all, :dot, :x, :dot,:P, :lpar, :x, :rpar]
 @test tokenizer("exist.x.P(x)") == [:exist, :dot, :x, :dot,:P, :lpar, :x, :rpar]
 @test tokenizer("not P(x)") == [:not, :P, :lpar, :x, :rpar ]
 @test tokenizer("(P(x))") == [:lpar, :P, :lpar, :x, :rpar, :rpar ]
 @test tokenizer("P(x) then Q(x)") == [:P, :lpar, :x, :rpar, :then, :Q, :lpar, :x, :rpar]
 @test tokenizer("P(x) iff  Q(x)") == [:P, :lpar, :x, :rpar, :iff, :Q, :lpar, :x, :rpar]
 @test tokenizer("P(x) then (not Q(x) or R(x,x))") == [:P, :lpar, :x, :rpar, :then, :lpar, :not, :Q, :lpar, :x, :rpar, :or, :R, :lpar, :x, :x, :rpar, :rpar]
end
==#

@testset "tokenizer prop" begin

 @test tokenizer("P") == [:P]
 @test tokenizer("¬P") == [:not, :P]
 @test tokenizer("(P)") == [:lpar, :P, :rpar]
 @test tokenizer("P⇒ Q") == [:P, :imply, :Q]
 @test tokenizer("P≡Q") == [:P,:eqv, :Q]
 @test tokenizer("P⇒(¬Q∨R)") == [:P, :imply, :lpar, :not, :Q, :or, :R, :rpar]
end

@testset "tokenizer pred" begin

 @test tokenizer("P(x)") == [:P, :lpar, :x, :rpar]
 @test tokenizer("∀.x.P(x)") == [:all, :dot, :x, :dot,:P, :lpar, :x, :rpar]
 @test tokenizer("∃.x.P(x)") == [:some, :dot, :x, :dot,:P, :lpar, :x, :rpar]
 @test tokenizer("¬ P(x)") == [:not, :P, :lpar, :x, :rpar ]
 @test tokenizer("(P(x))") == [:lpar, :P, :lpar, :x, :rpar, :rpar ]
 @test tokenizer("P(x) ⇒ Q(x)") == [:P, :lpar, :x, :rpar, :imply, :Q, :lpar, :x, :rpar]
 @test tokenizer("P(x) ≡  Q(x)") == [:P, :lpar, :x, :rpar, :eqv, :Q, :lpar, :x, :rpar]
 @test tokenizer("P(x) ⇒ (¬ Q(x) ∨ R(x,x))") == [:P, :lpar, :x, :rpar, :imply, :lpar, :not, :Q, :lpar, :x, :rpar, :or, :R, :lpar, :x, :x, :rpar, :rpar]
end

#==
@testset "atomic" begin
 @test parser("P(x)")[1] == [:P :x]

 @test parser("P(x) ∨ Q(x)")[1] == [:or [:P :x] [:Q :x]]
 @test parser("P(x) ∨ Q(x) or R(x)")[1] == [:or [:P :x] [:Q :x] [:R :x]]
 @test parser("P(x) ∧ Q(x)")[1] == [:and [:P :x] [:Q :x]]
 @test parser("P(x) ∧ Q(x) ∧ R(x)")[1] == [:and [:P :x] [:Q :x][:R :x]]
 @test parser("P(x) ⇒ Q(x)")[1] == [:imply [:P :x] [:Q :x]]
 @test parser("P(x) ≡ Q(x)")[1] == [:eqv [:P :x] [:Q :x]]

 @test parser("∀.x.P(x)")[1] == [:all [:x] [:P :x]]
 @test parser("∃.x.P(x)")[1] == [:some [:x] [:P :x]]

end
==#

