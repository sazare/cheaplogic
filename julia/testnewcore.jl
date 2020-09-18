# test new core
using Test

#include("newcore.jl")
#include("utils.jl")

@testset "stringtoclause" begin
 sc = stringtoclause(:C10, Meta.parse("[x].[-P(x),+Q(x,f(x))]")) 
 @test sc.cid  == :C10
 @test sc.vars ==  [:x_C10]
 @test sc.body ==  [Meta.parse("-P(x_C10)"), Meta.parse("+Q(x_C10,f(x_C10))")]

end

@testset "id and etc" begin
 @test cidof(123) == :C123
 @test lidof(3339) == :L3339
 @test ridof(233) == :R233

 @test origof(:xy_C12) == :xy
 @test origof(:xy_C12_JJ) == :xy
 @test origof(:xy) == :xy

 @test origtermof(Meta.parse("xy_C12")) == :xy
 @test origtermof(Meta.parse("xy")) == :xy
 @test origtermof(Meta.parse("f(xy_C12,x)")) == Meta.parse("f(xy, x)")
 @test origtermof(Meta.parse("f(g(xy_C12,y),h(u_C12R22),g(x))")) == Meta.parse("f(g(xy,y),h(u),g(x))")

 @test numof(:C123) == 123
 @test numof(:L22) == 22
 @test numof(:R2333) == 2333

 ctest = CORE("test", 0,[0],0,0,0,0,0,0,0,[],[0],[0],[])
 @test ctest.name == "test"
 @test newrid(ctest) == :R1
 @test newrid(ctest) == :R2
 @test newrid(ctest) == :R3

 @test isrid(:R23_C22)
 @test !isrid(:C23_C22)
 @test !isrid(:L23_C22)
 @test iscid(:C23_C22)
 @test !iscid(:R23_C22)
 @test !iscid(:L23_C22)
 @test !islid(:R23_C22)
 @test !islid(:C23_C22)
 @test islid(:L23_C22)
end

@testset "analyze core" begin
 @test analyze_term([], Meta.parse("a")) == ([], [:a], [])
 @test analyze_term([:a], Meta.parse("a")) == ([:a], [], [])
 @test analyze_term([], Meta.parse("a()")) == ([], [], [:a])
 @test analyze_term([], Meta.parse("a(b)")) == ([], [:b], [:a])
 @test analyze_term([], Meta.parse("a(b,c)")) == ([], [:b,:c], [:a])
 @test analyze_term([:c], Meta.parse("a(b,c)")) == ([:c], [:b], [:a])
 @test analyze_term([], Meta.parse("a(b())")) == ([], [], [:a,:b])
 @test analyze_term([], Meta.parse("a(b(c))")) == ([], [:c], [:a,:b])
 @test analyze_term([:d,:g], Meta.parse("a(b(c),d,e(f,g))")) == ([:d,:g], [:c,:f], [:a,:b,:e])

 @test analyze_term([:x,:y,:z], Meta.parse("+P(x,c,f(x,c))").args[2]) == ([:x,:x], [:c,:c], [:P,:f])

 @test analyze_lit([:x,:y,:z], Meta.parse("+P(x,c,f(x,c))").args[2]) == ([:x,:x], [:c,:c], [:f],:P)

 cnf = "[x].[+P(x,f(x))]
[x].[-P(x,f(h(x)))]
[x,y,z].[+P(h(y),pi, f(k(x))),-Q(e,g(x,y))]"
 ccnf = readcore(IOBuffer(cnf))

asm = analyze_sym(ccnf) 

 @test asm.vsyms == Set(Any[:y_C3, :x_C3, :x_C1, :x_C2])
 @test asm.csyms == Set(Any[:e, :pi])
 @test asm.fsyms == Set(Any[:f,:k,:h,:g])
 @test asm.psyms == Set(Any[:P,:Q])
end

@testset "core proc" begin
 evalproc(["x=12"])
 @test x==12

end


@testset "varsof" begin
 cnf = "[].[+P(x,f(x))]
[x].[-P(x,f(h(x)))]
[x,y,z].[+P(h(y),pi, f(k(x))),-Q(e,g(x,y))]"
 cc = readcore(IOBuffer(cnf))

 @test varsof(:C1, cc) == []
 @test varsof(:C2, cc) == [:x_C2]
 @test varsof(:C3, cc) == [:x_C3, :y_C3, :z_C3]
end

@testset "lvarsof" begin
 cnf = "[].[+P(x,f(x))]
[x].[-P(x,f(h(x)))]
[x,y,z].[+P(h(y),pi, f(k(x))),-Q(e,g(x,y))]"
 cc = readcore(IOBuffer(cnf))

 @test lvarsof(:L1, cc) == [:x_C2]
 @test lvarsof(:L2, cc) == []
 @test lvarsof(:L3, cc) == [:x_C3, :y_C3, :z_C3]
 @test lvarsof(:L4, cc) == [:x_C3, :y_C3, :z_C3]
end

@testset "atomof" begin
 cnf = "[].[+P(x,f(x))]
[x].[-P(x,f(h(x)))]
[x,y,z].[+P(h(y),pi, f(k(x))),-Q(e,g(x,y))]"
 cc = readcore(IOBuffer(cnf))

 @test atomof(:L1, cc) == :(P(x_C2, f(h(x_C2))))
 @test atomof(:L2, cc) == :(P(x, f(x)))
 @test atomof(:L3, cc) == :(P(h(y_C3), pi, f(k(x_C3))))
 @test atomof(:L4, cc) == :(Q(e, g(x_C3, y_C3)))
end


