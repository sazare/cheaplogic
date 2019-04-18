# test for unify.jl
using Test
#include("utils.jl") # for isinvar()
#include("unify.jl")

#==
idea:
unify([:x,:y], "P(x,y)", "P(x,f(x))")
unify([:x,:y], :(P(x,y)), :(P(x,f(x))))

:(P(x,y)) == Meta.Meta.parse("P(x,y)")
youcan readline(from console) and Meta.parse it to get the Expr
==#
@testset "loop check" begin
 @test loopcheck(:x,:(g(y)))==false
## not happen case: @test loopcheck(:x,:x)==false
 @test_throws Loop loopcheck(:x,:(g(x)))
 @test_throws Loop loopcheck(:x,:(f(a,g(x))))
 @test loopcheck(:x,:(f(g(y),g(h(y)))))==false
 @test_throws Loop loopcheck(:x,:(f(g(a),g(x))))
 @test_throws Loop loopcheck(:x,:(f(g(x),g(x))))
end

@testset "vindex" begin
 @test 0 == vindex([], :a)
 @test 0 == vindex([:x,:y], :a)
 @test 1 == vindex([:x,:y], :x)
 @test 2 == vindex([:x,:y], :y)
end

@testset "unify0 find a pair unifiable" begin
 @test unify0([], :P, :P) ==()
 @test unify0([:x], :x, :x) ==()
 @test unify0([:x], :x, :a) ==(:x, :a)
 @test unify0([:x], :a, :x) ==(:x, :a)

 @test_throws ICMP unify0([:x], :P, :Q)
 @test_throws ICMP unify0([], :P, :Q)

 @test unify0([:x], :(P(x)), :(P(a))) == (:x, :a)
 @test unify0([:x], :(P(x)), :(P(f(a)))) == (:x,:(f(a)))
 @test unify0([:x], :(P(f(a))), :(P(f(x)))) == (:x,:a)
 @test unify0([:x], :(P(f(a))), :(P(x))) == (:x,:(f(a)))

 @test_throws ICMP unify0([:x],:(P(g(a))),:(P(f(x))))
 @test_throws ICMP unify0([:x],:(P(f(a))),:(P(f(b))))
 @test_throws ICMP unify0([:x],:(P(a)), :(P(f(b)))) 
end

@testset "unify1" begin
 @test unify1([], :(f()), :(f()), []) == []
 @test unify1([:x], :x, :x, [:x]) == [:x]
 @test unify1([:x], :x, :a, [:x]) == [:a]
 @test unify1([:x], :x, :x, [:x]) == [:x]

 @test unify1([:x], :(f(x)), :(f(x)), [:x]) == [:x]
 @test unify1([:x], :(f(x)), :(f(a)), [:x]) == [:a]
 @test unify1([:x], :(f(x)), :(f(x)), [:b]) == [:b]

 @test_throws ICMP unify1([:x], :(f(x)), :(f(a)), [:b])

 @test unify1([:x,:y], :x , :(f(a)), [:x,:y]) == [:(f(a)), :y]
 @test unify1([:x,:y], :x , :(f(a)), [:x,:a]) == [:(f(a)), :a]

 @test unify1([:x,:y,:z], :a , :z, [:y,:z,:z]) == [:a,:a,:a]
 @test unify1([:x,:y,:z], :z , :a, [:y,:z,:z]) == [:a,:a,:a]

 @test unify1([:x,:y,:z], :z , :(f(a)), [:y,:z,:z]) == [:(f(a)),:(f(a)),:(f(a))]

 @test unify1([:x,:y], :x , :(f(a)), [:x,:x]) == [:(f(a)), :(f(a))]

 @test unify1([:x,:y,:z],:x,:(f(a)),[:y,:z,:z]) == [:(f(a)),:(f(a)),:(f(a))]
 @test unify1([:x,:y,:z],:z,:(f(a)),[:y,:z,:z]) == [:(f(a)),:(f(a)),:(f(a))]
 @test unify1([:x,:y,:z,:w,:u],:z,:(f(a)),[:y,:z,:w,:u,:u]) == [:(f(a)),:(f(a)),:(f(a)),:(f(a)),:(f(a))]

 @test unify1([:x,:y], :x , :(f(a)), [:y,:y]) == [:(f(a)), :(f(a))]

 @test unify1([:x,:y], :(f(x)), :(f(x)), [:x,:a]) == [:x,:a]
 @test unify1([:x,:y], :(f(x)), :(f(b)), [:x,:a]) == [:b,:a]

 @test unify1([:x,:y], :(f(b)), :(f(x)), [:x,:a]) == [:b,:a]
 @test unify1([:x,:y], :(f(g(b))), :(f(x)), [:x,:a]) == [:(g(b)),:a]

 @test unify1([:x,:y], :(f(x)), :(f(y)), [:b,:y]) == [:b,:b]

 @test unify1([:x,:y], :(f(g(b,y))), :(f(x)), [:x,:(h(a))]) == [:(g(b,y)),:(h(a))]
 @test unify1([:x,:y], :x, :p, [:y,:y]) == [:p,:p]

 @test unify1([:x,:y], :x, :y, [:p,:y]) == [:p,:p]

end

@testset "unify" begin
 @test_throws ICMP unify([],:(P()),:(Q()))

 @test unify([:x],:(),:())== [:x]
 @test unify([:x],:(P()),:(P())) == [:x]
 @test_throws ICMP unify([:x],:(P()),:(Q()))


 @test unify([:x],:(P(x)), :(P(x))) == [:x]
 @test unify([:y],:(P(x)), :(P(x))) == [:y]

 @test unify([:x],:(P(x)), :(P(y))) == [:y]
 @test unify([:y],:(P(x)), :(P(y))) == [:x]

# in this case, x and y are constants
 @test_throws ICMP unify([:z],:(P(x)), :(P(y)))

 @test unify([],:(P(a)), :(P(a))) == []
 @test_throws ICMP unify([],:(P(a)), :(P(b)))

 (σ=unify([:x,:y],:(P(x)),:(P(y))); @test σ==[:x,:x] || σ==[:y,:y])

 @test unify([:x,:y],:(P(x)),:(P(a))) == [:a,:y]
 @test unify([:x,:y],:(P(f(x))),:(P(f(a)))) == [:a,:y]

 @test unify([:x,:y],:(P(x)),:(P(f(a)))) == [:(f(a)),:y]
 (σ = unify([:x,:y],:(P(x,f(a,x))),:(P(y,f(a,y)))); @test σ == [:y,:y] || σ == [:y,:y])

 @test unify([:x,:y],:(P(x,f(x))),:(P(a,f(y)))) == [:a,:a]
 @test unify([:x,:y],:(P(x,y)),:(P(y,f(a)))) == [:(f(a)),:(f(a))]

 @test unify([:x,:y], :(f(g(b,y),h(a))), :(f(x,y))) == [:(g(b,h(a))),:(h(a))]

 @testset "fixed point of subst" begin
   @test fp_subst([:x,:y],[:x,:y]) == [:x,:y]
   @test fp_subst([:x,:y],[:a,:x]) == [:a,:a]

   @test fp_subst([:x,:y],[:x,:x]) == [:x,:x]

   @test fp_subst([:x,:y,:z],[:a,:(f(x,z)),:b]) == [:a,:(f(a,b)),:b]
   @test fp_subst([:x,:y,:z,:w],[:x,:(f(g(z,w),h(w))),:(k(w)),:(m(a))]) == [:x,:(f(g(k(m(a)),m(a)),h(m(a)))),:(k(m(a))),:(m(a))]

   @test fp_subst([:x,:y,:z,:u],[:(f(y)),:(g(z)),:(h(u)),:(k(a))]) == [:(f(g(h(k(a))))),:(g(h(k(a)))),:(h(k(a))),:(k(a))]

   @test unify([:x,:y,:z,:u],:(P(x,y,z,u)),:(P(f(y),g(z),h(u),k(a)))) == [:(f(g(h(k(a))))),:(g(h(k(a)))),:(h(k(a))),:(k(a))]


   @testset "loop check for fixed point of subst" begin
     @test_throws Loop fp_subst([:x,:y],[:(f(y)),:x])
     @test_throws Loop fp_subst([:x,:y,:z],[:a,:(f(x,z)),:(g(y))]) == [:a,:(f(a,b)),:b]
     @test_throws Loop fp_subst([:x,:y,:z,:w],[:a,:(f(x,z)),:(g(w)),:(h(z))]) == [:a,:(f(a,b)),:b]
   end
 end

 @testset "unify intervention" begin
  @test unify([:x,:y],:(P(f(x),x)),:(P(y,a))) == [:a,:(f(a))]

  @test unify([:x,:y,:w],:(P(f(w,x),w,x)),:(P(y,h(b),g(a)))) == [:(g(a)),:(f(h(b),g(a))),:(h(b))]

  @test unify([:x,:y,:w,:u,:z,:n],:(P(f(w,z),w,g(n),z)),:(P(y,h(b),u,h(u)))) == [:x,:(f(h(b),h(g(n)))),:(h(b)),:(g(n)),:(h(g(n))),:n]

  @test unify([:x,:y,:z,:w,:u,:n,:v],:((P(f(x),y,h(y,z),z,k(n)))),:((P(w,g(w),u,q(v),v)))) == [:x,:(g(f(x))),:(q(k(n))),:(f(x)),:(h(g(f(x)),q(k(n)))),:n,:(k(n))]

  @test unify([:x,:y,:z,:w,:u,:n,:v],:((P(f(y,z),y,h(z),z,k(n)))),:((P(w,g(u,v),u,q(v),v)))) == [:x,:(g(h(q(k(n))),k(n))),:(q(k(n))),:(f(g(h(q(k(n))),k(n)),q(k(n)))),:(h(q(k(n)))),:n,:(k(n))]

 end

 @test unify([:x,:y], :(f(a=x,b=x)), :(f(a=p,b=y))) == [:p, :p]

 @testset "unify loop test fail" begin
  @test_throws Loop unify([:x,:y],:(P(x)),:(P(f(x))))
  @test_throws Loop unify([:x,:y],:(P(x,y)),:(P(y,f(y))))
 end

end

