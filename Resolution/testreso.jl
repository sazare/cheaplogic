# test for reso.jl

using Base.Test

include("reso.jl")

#==
idea:
unify([:x,:y], "P(x,y)", "P(x,f(x))")
unify([:x,:y], :(P(x,y)), :(P(x,f(x))))

:(P(x,y)) == parse("P(x,y)")
youcan readline(from console) and parse it to get the Expr
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

 @test isconst(:x, [:y,:x]) == false
 @test isconst(:a, [:y,:x]) == true
 @test isconst(12, [:y,:x]) == true
 @test isconst(23.1, [:y,:x]) == true
 @test isconst(0, [:y,:x]) == true
 @test isvar([:a :b], [:y,:x]) == false
 @test isvar([], [:y,:x]) == false

end

@testset "inside check" begin
 @test inside(:x,:(g(y)))==false
## not happen case: @test inside(:x,:x)==false
 @test_throws Loop inside(:x,:(g(x)))
 @test_throws Loop inside(:x,:(f(a,g(x))))
 @test inside(:x,:(f(g(y),g(h(y)))))==false
 @test_throws Loop inside(:x,:(f(g(a),g(x))))
 @test_throws Loop inside(:x,:(f(g(x),g(x))))
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

@testset "unify" begin
 @test unify([],:(P()),:(Q())) == []

 @test unify([:x],:(),:())== [:x]
 @test unify([:x],:(P()),:(P())) == [:x]
 @test unify([:x],:(P()),:(Q())) == [:x]

 @test unify([:x],:(P(x)), :(P(x))) == [:x]
 @test unify([:y],:(P(x)), :(P(x))) == [:y]

 @test unify([:x],:(P(x)), :(P(y))) == [:y]
 @test unify([:y],:(P(x)), :(P(y))) == [:x]

 @test_throws ICMP unify([:z],:(P(x)), :(P(y)))

 @test unify([:x,:y],:(P(x)),:(P(y))) == [:y,:y]
 @test unify([:x,:y],:(P(x)),:(P(a))) == [:a,:y]
 @test unify([:x,:y],:(P(f(x))),:(P(f(a)))) == [:a,:y]

 @test unify([:x,:y],:(P(x)),:(P(f(a)))) == [:(f(a)),:y]
 @test unify([:x,:y],:(P(x,f(a,x))),:(P(y,f(a,y)))) == [:y,:y]
 @test unify([:x,:y],:(P(x,f(x))),:(P(a,f(y)))) == [:a,:a]
 @test unify([:x,:y],:(P(x,y)),:(P(y,f(a)))) == [:(f(a)),:(f(a))]

 @testset "unify inside test fail" begin
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
 @test equalclause(([:x], parse("[+Q(x,b)]")), ([:x],parse("[+Q(x,b)]"))) == true
 @test equalclause(([:y], parse("[+Q(y,b)]")), ([:x],parse("[+Q(x,b)]"))) == true
end

@testset "pure resolution" begin
 @test resolution(([],parse("[+P(a)]")),1, ([],parse("[+P(a)]")),1) == :NAP
 @test resolution(([],parse("[+P(a)]")),1, ([],parse("[-P(a)]")),1) == (EmptyCForm,[])
 @test resolution(([],parse("[-P(a)]")),1, ([],parse("[+P(a)]")),1) == (EmptyCForm,[])
 @test resolution(([],parse("[+P(a)]")),1, ([:x],parse("[-P(x)]")),1) == (EmptyCForm,[])
 @test resolution(([:x],parse("[+P(x)]")),1, ([:x],parse("[-P(x)]")),1) == (EmptyCForm,[])

 @test resolution(([],parse("[+P(a)]")),1, ([],parse("[-P(b)]")),1) == :NAP
 @test resolution(([],parse("[+P(a)]")),1, ([:x,:y],parse("[-P(b),+Q(x,y),+R(y)]")),1) == :NAP

 r1 = resolution(([:x],parse("[+(P(x))]")),1, ([:x,:y],parse("[-P(x),+Q(x, y),+R(y)]")),1) 
 @test equalclause(r1[1],([:x,:y],parse("[+Q(x,y),+R(y)]"))) == true

 r2 = resolution(([],parse("[+(P(a))]")), 1, ([:x,:y],parse("[-P(x),+Q(x, y),+R(y)]")),1) 
 @test equalclause(r2[1], ([:y],parse("[+Q(a,y),+R(y)]")))

 r3 = resolution(([],parse("[-Q(a,b),+P(a)]")),1, ([:x,:y],parse("[-P(x),+Q(x, y),+R(y)]")),2) 
 @test equalclause(r3[1], ([],parse("[+P(a),-P(a),+R(b)]")))

 r4 = resolution(([],parse("[-Q(a,b),+P(a)]")),2, ([:x,:y],parse("[+Q(x, y),+R(y),-P(x)]")),3) 
 @test equalclause(r4[1], ([:y],parse("[-Q(a,b),+Q(a,y),+R(y)]")))

end

@testset "real resolution" begin
 v,r = resolution([:y], parse("[-Q(a,y),+P(a)]"), 2, [:x,:y], parse("[+Q(x, y),+R(y),-P(x)]"),3) 
 @test rename(v[1],v[2],[:x,:y,:z]) == parse("[-Q(a,x),+Q(a,z),+R(z)]")
 v,r = resolution([], parse("[-Q(a,b),+P(a)]"), 2, [:x,:y], parse("[+Q(x, y),+R(y),-P(x)]"),3) 
 @test rename(v[1],v[2],[:x,:y]) ==  parse("[-Q(a,b),+Q(a,y),+R(y)]")

end

@testset "reduction" begin
 r = reduction(([:y], parse("[-Q(a,y),+P(a)]")), 1)
 @test equalclause(r[1], ([:y],parse("[-Q(a,y),+P(a)]"))) == true

 r = reduction(([:y], parse("[-Q(a,y),+P(a),+P(a)]")), 2)
 @test equalclause(r[1], ([:y],parse("[-Q(a,y),+P(a)]"))) == true

 r = reduction(([:x,:y],parse("[-Q(a,y),+P(x),+P(a)]")), 2)
 @test equalclause(r[1], ([:y], parse("[-Q(a,y),+P(a)]"))) == true

 r = reduction(([:y], parse("[-Q(a,y),+P(b),+P(a)]")), 2)
 @test equalclause(r[1], ([:y],parse("[-Q(a,y),+P(b),+P(a)]"))) == true

 r = reduction(([:x], parse("[-Q(a,x),+P(x),+P(a)]")), 2)
 @test equalclause(r[1], ([],parse("[-Q(a,a),+P(a)]"))) == true

 r = reduction(([:x], parse("[-Q(a,x),+P(x),+P(a),+R(x)]")), 2)
 @test equalclause(r[1],([],parse("[-Q(a,a),+P(a),+R(a)]")))== true

 r = reduction(([:x], parse("[-Q(a,x),+P(x),+P(a),+R(x)]")), 2)
 @test equalclause(r[1],([], parse("[-Q(a,a),+P(a),+R(a)]"))) == true

 r = reduction(([:x], parse("[-Q(a,x),+P(x),+P(f(x)),+R(x)]")), 2)
 @test equalclause(r[1], ([:x],parse("[-Q(a,x),+P(x),+P(f(x)),+R(x)]"))) == true
end

@testset "reduction" begin
 @test satisfiable([:x], parse("[-Q(a,x),+P(x),-P(y),+R(x)]")) == true
 @test satisfiable([], parse("[-Q(a,x),+P(x),-P(y),+R(x)]")) == false

 @test satisfiable([:x,:y], parse("[-Q(a,x),+P(x),-P(y),+R(x)]")) == true
 @test satisfiable([:x,:y], parse("[-Q(a,x),+P(x,a),-P(y,a),+R(x)]")) == true
 @test satisfiable([:x,:y], parse("[-Q(a,x),-P(x,a),-P(y,a),+R(x)]")) == false


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
 @test fitvars([:x,:y], parse("[+Q(x,b)]"), [:a,:b]) == (([:x],parse("[+Q(x,b)]")), [:a])
 @test fitvars([:x,:y], parse("[+Q(a,b)]"), [:a,:b]) == (([],parse("[+Q(a,b)]")), [])
end


