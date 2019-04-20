# test for naiveunify.jl
using Test

#include("naiveunify.jl")

@testset "disagreement" begin
 @test disagreement( :(x), :(x)) == ()
 @test disagreement( :(x), :(y)) == (:x,:y)
 @test disagreement( :(x), :(y)) == (:x,:y)
 @test disagreement( :(x), :(y)) == (:x,:y)
 @test disagreement( :(f(x)), :(f(x))) == ()
 @test disagreement( :(f(x)), :(g(x))) == (:(f(x)), :(g(x)))
 @test disagreement( :(f(x)), :(f(g(x)))) == (:x, :(g(x)))
 @test disagreement( :(f(x,y,z)), :(f(x,y,z))) == ()
 @test disagreement( :(f(x,y,x)), :(f(x,y,z))) == (:x,:z)
 @test disagreement( :(f(x,z,x)), :(f(x,y,z))) == (:z,:y)
 @test disagreement( :(f(x,y,y)), :(f(z,y,z))) == (:x,:z)
 @test disagreement( :(f(g(x),y,x)), :(f(x,y,z))) == (:(g(x)),:x)
 @test disagreement( :(f(g(x),y,a)), :(f(g(x),d,z))) == (:y,:d) 
 @test disagreement( :(f(g(x),y,a)), :(f(g(h(a)),z,z))) == (:x,:(h(a)))
 @test disagreement( :(f(g(x),h(y,u),x)), :(f(g(x),h(y,hen(i)),z))) == (:u,:(hen(i)))

end

@testset "naiveunify" begin
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


