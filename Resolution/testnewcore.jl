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


end

