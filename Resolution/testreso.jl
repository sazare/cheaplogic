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

@testset "resolution" begin
 @test resolution([:x,:y],parse("[+P(a)]"), parse("[+P(a)]"),1,1) == :NAP
 @test resolution([:x,:y],parse("[+P(a)]"), parse("[-P(a)]"),1,1) == EmptyClause
 @test resolution([:x,:y],parse("[-P(a)]"), parse("[+P(a)]"),1,1) == EmptyClause
 @test resolution([:x,:y],parse("[+P(a)]"), parse("[-P(x)]"),1,1) == EmptyClause
 @test resolution([:x,:y],parse("[+P(x)]"), parse("[-P(x)]"),1,1) == EmptyClause

 @test resolution([:x,:y],parse("[+P(a)]"), parse("[-P(b)]"),1,1) == :NAP
 @test resolution([:x,:y],parse("[+P(a)]"), parse("[-P(b),+Q(x,y),+R(y)]"),1,1) == :NAP

 @test resolution([:x,:y],parse("[+(P(x))]"), parse("[-P(x),+Q(x, y),+R(y)]"),1,1) == parse("[+Q(x,y),+R(y)]")
 @test resolution([:x,:y],parse("[+(P(a))]"), parse("[-P(x),+Q(x, y),+R(y)]"),1,1) == parse("[+Q(a,y),+R(y)]")

 @test resolution([:x,:y],parse("[-Q(a,b),+P(a)]"), parse("[-P(x),+Q(x, y),+R(y)]"),1,2) == parse("[+P(a),-P(a),+R(b)]")
 @test resolution([:x,:y],parse("[-Q(a,b),+P(a)]"), parse("[+Q(x, y),+R(y),-P(x)]"),2,3) == parse("[-Q(a,b),+Q(a,y),+R(y)]")
end

