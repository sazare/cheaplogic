# test for reso.jl
using Test
#include("unify.jl")
#include("reso.jl")

#==
idea:
unify([:x,:y], "P(x,y)", "P(x,f(x))")
unify([:x,:y], :(P(x,y)), :(P(x,f(x))))

:(P(x,y)) == Meta.Meta.parse("P(x,y)")
youcan readline(from console) and Meta.parse it to get the Expr
==#

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

