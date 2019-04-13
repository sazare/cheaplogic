# test for reso.jl
using Test
include("reso.jl")

#==
idea:
unify([:x,:y], "P(x,y)", "P(x,f(x))")
unify([:x,:y], :(P(x,y)), :(P(x,f(x))))

:(P(x,y)) == Meta.Meta.parse("P(x,y)")
youcan readline(from console) and Meta.parse it to get the Expr
==#

@testset "vars and const" begin
 @test isvar(:x, [:y,:x]) == true
 @test isvar(:y, [:y,:x]) == true
 @test isvar(:z, [:y,:x]) == false
 @test isvar(12, [:y,:x]) == false
 @test isvar(23.1, [:y,:x]) == false
 @test isvar(0, [:y,:x]) == false
 @test isvar([:a :b], [:y,:x]) == false
 @test isvar([], [:y,:x]) == false

 @test isevar(:Abc, [:Abc, :x]) == true
 @test isevar(:Abc, [:abc, :x]) == false
 @test isevar(:dbc, [:abc, :x]) == false

 @test isconst(:x, [:y,:x]) == false
 @test isconst(:a, [:y,:x]) == true
 @test isconst(12, [:y,:x]) == true
 @test isconst(23.1, [:y,:x]) == true
 @test isconst(0, [:y,:x]) == true
 @test isvar([:a :b], [:y,:x]) == false
 @test isvar([], [:y,:x]) == false

end

@testset "apply subst" begin
 @test apply([],:(P(x)),[]) == :(P(x))
 @test apply([:x],:x,[:a]) == :a
 @test apply([:x],:(x),[:a]) == :(a)
 @test apply([:x],:(P(x)),[:a]) == :(P(a))
 @test apply([:x,:y],:(P(x,f(y))),[:a,:b]) == :(P(a,f(b)))

 @test apply([:x,:y],:(P(x,y)),[:y,:x]) == :(P(y,x))
 @test apply([:x,:y],:(P(x,y)),[:a,:x]) == :(P(a,x))
 @test apply([:x,:y],:(P(x,y)),[:a,:b]) == :(P(a,b))
 @test apply([:x,:y,:z],:(P(x,y,z)),[:y,:z,:x]) == :(P(y,z,x))
 @test apply([:x,:y,:z],:(P(x,y,z)),[:(f(y,z)),:(f(y,x)),:(f(g(x),h(y)))]) == :(P(f(y,z), f(y,x), f(g(x),h(y))))


end

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

@testset "genvars" begin
 @test genvars([]) == []
 gv = genvars([:x,:y])
 @test length(gv) == 2
 @test gv != [:x,:y]

end

@testset "equalclause" begin
 @test equalclause(([:x], [Meta.parse("+Q(x,b)")]), ([:x],[Meta.parse("+Q(x,b)")])) == true
 @test equalclause(([:x], [Meta.parse("+Q(x,c)")]), ([:x],[Meta.parse("+Q(x,b)")])) == false
 @test equalclause(([:y], [Meta.parse("+Q(y,b)")]), ([:x],[Meta.parse("+Q(x,b)")])) == true
 @test equalclause(([:y], [Meta.parse("+Q(y,b)"),Meta.parse("+P(c)")]), ([:x],[Meta.parse("+Q(x,b)"),Meta.parse("-P(a)")])) == false
 @test equalclause(([:x,:y], [Meta.parse("+Q(x,y)"),Meta.parse("+P(a)")]), ([:w,:y],[Meta.parse("+Q(x,y)"),Meta.parse("-P(b)")])) == false
 @test equalclause(([:x,:y], [Meta.parse("+Q(x,y)"),Meta.parse("+P(x)")]), ([:w,:y],[Meta.parse("+Q(x,y)"),Meta.parse("-P(w)")])) == false
 @test equalclause(([:y], [Meta.parse("+Q(y,b)")]), ([:y],[Meta.parse("+Q(x,b)")])) == false
 @test equalclause(([:x], [Meta.parse("+Q(y,x,b)")]), ([:y],[Meta.parse("+Q(y,x,b)")])) == false
end

@testset "pure resolution" begin
 @test resolution(([],Meta.parse("[+P(a)]").args),1, ([],Meta.parse("[+P(a)]").args),1) == :NAP
 @test resolution(([],Meta.parse("[+P(a)]").args),1, ([],Meta.parse("[-P(a)]").args),1) == (EmptyCForm,[])
 @test resolution(([],Meta.parse("[-P(a)]").args),1, ([],Meta.parse("[+P(a)]").args),1) == (EmptyCForm,[])
 @test resolution(([],Meta.parse("[+P(a)]").args),1, ([:x],Meta.parse("[-P(x)]").args),1) == (EmptyCForm,[])
 @test resolution(([:x],Meta.parse("[+P(x)]").args),1, ([:x],Meta.parse("[-P(x)]").args),1) == (EmptyCForm,[])

 @test resolution(([],Meta.parse("[+P(a)]").args),1, ([],Meta.parse("[-P(b)]").args),1) == :NAP
 @test resolution(([],Meta.parse("[+P(a)]").args),1, ([:x,:y],Meta.parse("[-P(b),+Q(x,y),+R(y)]").args),1) == :NAP

 r1 = resolution(([:x],Meta.parse("[+(P(x))]").args),1, ([:x,:y],Meta.parse("[-P(x),+Q(x, y),+R(y)]").args),1) 
 @test equalclause(r1[1],([:x,:y],Meta.parse("[+Q(x,y),+R(y)]").args)) == true

 r2 = resolution(([],Meta.parse("[+(P(a))]").args), 1, ([:x,:y],Meta.parse("[-P(x),+Q(x, y),+R(y)]").args),1) 
 @test equalclause(r2[1], ([:y],Meta.parse("[+Q(a,y),+R(y)]").args))

 r3 = resolution(([],Meta.parse("[-Q(a,b),+P(a)]").args),1, ([:x,:y],Meta.parse("[-P(x),+Q(x, y),+R(y)]").args),2) 
 @test equalclause(r3[1], ([],Meta.parse("[+P(a),-P(a),+R(b)]").args))

 r4 = resolution(([],Meta.parse("[-Q(a,b),+P(a)]").args),2, ([:x,:y],Meta.parse("[+Q(x, y),+R(y),-P(x)]").args),3) 
 @test equalclause(r4[1], ([:y],Meta.parse("[-Q(a,b),+Q(a,y),+R(y)]").args))
end

@testset "real resolution" begin
 v,r = resolution([:y], Meta.parse("[-Q(a,y),+P(a)]").args, 2, [:x,:y], Meta.parse("[+Q(x, y),+R(y),-P(x)]").args,3) 
 @test rename(v[1],v[2],[:x,:y,:z]) == Meta.parse("[-Q(a,x),+Q(a,z),+R(z)]").args
 v,r = resolution([], Meta.parse("[-Q(a,b),+P(a)]").args, 2, [:x,:y], Meta.parse("[+Q(x, y),+R(y),-P(x)]").args,3) 
 @test rename(v[1],v[2],[:x,:y]) ==  Meta.parse("[-Q(a,b),+Q(a,y),+R(y)]").args
end

@testset "reduction" begin
 r = reduction(([:y], Meta.parse("[-Q(a,y),+P(a)]").args), 1)
 @test equalclause(r[1], ([:y],Meta.parse("[-Q(a,y),+P(a)]").args)) == true

 r = reduction(([:y], Meta.parse("[-Q(a,y),+P(a),+P(a)]").args), 2)
 @test equalclause(r[1], ([:y],Meta.parse("[-Q(a,y),+P(a)]").args)) == true

 r = reduction(([:x,:y],Meta.parse("[-Q(a,y),+P(x),+P(a)]").args), 2)
 @test equalclause(r[1], ([:y], Meta.parse("[-Q(a,y),+P(a)]").args)) == true

 r = reduction(([:y], Meta.parse("[-Q(a,y),+P(b),+P(a)]").args), 2)
 @test equalclause(r[1], ([:y],Meta.parse("[-Q(a,y),+P(b),+P(a)]").args)) == true

 r = reduction(([:x], Meta.parse("[-Q(a,x),+P(x),+P(a)]").args), 2)
 @test equalclause(r[1], ([],Meta.parse("[-Q(a,a),+P(a)]").args)) == true

 r = reduction(([:x], Meta.parse("[-Q(a,x),+P(x),+P(a),+R(x)]").args), 2)
 @test equalclause(r[1],([],Meta.parse("[-Q(a,a),+P(a),+R(a)]").args))== true

 r = reduction(([:x], Meta.parse("[-Q(a,x),+P(x),+P(a),+R(x)]").args), 2)
 @test equalclause(r[1],([], Meta.parse("[-Q(a,a),+P(a),+R(a)]").args)) == true

 r = reduction(([:x], Meta.parse("[-Q(a,x),+P(x),+P(f(x)),+R(x)]").args), 2)
 @test equalclause(r[1], ([:x],Meta.parse("[-Q(a,x),+P(x),+P(f(x)),+R(x)]").args)) == true
end

@testset "satisfiable" begin
 @test satisfiable([:x], Meta.parse("[-Q(a,x),+P(x),-P(y),+R(x)]").args) == true
 @test satisfiable([], Meta.parse("[-Q(a,x),+P(x),-P(y),+R(x)]").args) == false

 @test satisfiable([:x,:y], Meta.parse("[-Q(a,x),+P(x),-P(y),+R(x)]").args) == true
 @test satisfiable([:x,:y], Meta.parse("[-Q(a,x),+P(x,a),-P(y,a),+R(x)]").args) == true
 @test satisfiable([:x,:y], Meta.parse("[-Q(a,x),-P(x,a),-P(y,a),+R(x)]").args) == false
end

@testset "readablevars" begin
 @test length(readablevars(1))==1
 @test length(readablevars(10))==10
 newv = readablevars(30)
 @test length(intersect(newv,newv)) == 30
end

@testset "reducesub" begin
 @test reducesub([:x,:y], [:x], [:a,:b]) == [:a]
 @test reducesub([:x,:y,:z,:w], [:x,:w], [:a,:b,:c,[:f :x]]) == [:a, [:f :x]]
end

@testset "fitvars" begin
 @test fitvars([:x,:y], Meta.parse("[+Q(x,b)]").args, [:a,:b]) == (([:x],Meta.parse("[+Q(x,b)]").args), [:a])
 @test fitvars([:x,:y], Meta.parse("[+Q(a,b)]").args, [:a,:b]) == (([],Meta.parse("[+Q(a,b)]").args), [])
end

