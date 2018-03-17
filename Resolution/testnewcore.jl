# test new core

using Base.Test

include("newcore.jl")

@testset "stringtoclause" begin
 sc = stringtoclause(:C10, parse("[x].[-P(x),+Q(x,f(x))]")) 
 @test sc.cid  == :C10
 @test sc.vars ==  [:x_C10]
 @test sc.body ==  [parse("-P(x_C10)"), parse("+Q(x_C10,f(x_C10))")]

end

@testset "id and etc" begin
 @test cidof(123) == :C123
 @test lidof(3339) == :L3339
 @test ridof(233) == :R233

 @test origof(:xy_C12) == :xy
 @test origof(:xy_C12_JJ) == :xy
 @test origof(:xy) == :xy

 @test numof(:C123) == 123
 @test numof(:L22) == 22
 @test numof(:R2333) == 2333

 ctest = CORE(0,[0],0,0,0,0,0,0,0)
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

@testset "analyze" begin
 @test analyze_term([], parse("a")) == ([], [:a], [])
 @test analyze_term([:a], parse("a")) == ([:a], [], [])
 @test analyze_term([], parse("a()")) == ([], [], [:a])
 @test analyze_term([], parse("a(b)")) == ([], [:b], [:a])
 @test analyze_term([], parse("a(b,c)")) == ([], [:b,:c], [:a])
 @test analyze_term([:c], parse("a(b,c)")) == ([:c], [:b], [:a])
 @test analyze_term([], parse("a(b())")) == ([], [], [:a,:b])
 @test analyze_term([], parse("a(b(c))")) == ([], [:c], [:a,:b])
 @test analyze_term([:d,:g], parse("a(b(c),d,e(f,g))")) == ([:d,:g], [:c,:f], [:a,:b,:e])

 @test analyze_term([:x,:y,:z], parse("+P(x,c,f(x,c))").args[2]) == ([:x,:x], [:c,:c], [:P,:f])

 @test analyze_lit([:x,:y,:z], parse("+P(x,c,f(x,c))").args[2]) == ([:x,:x], [:c,:c], [:f],:P)

 wff = "[x].[+P(x,f(x))]
[x].[-P(x,f(h(x)))]
[x,y,z].[+P(h(y),pi, f(k(x))),-Q(e,g(x,y))]"
 cwff = readcore(IOBuffer(wff))

 @test analyze_sym(cwff) == (Set([:y_C3, :x_C3, :x_C1, :x_C2]), Set([:e, :pi]), Set([:f,:h,:k,:g]), Set([:P,:Q]))



end

