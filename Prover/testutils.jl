include("utils.jl")
#include("setdata.jl")

using Test

@testset "compare literals" begin
# dont used gelit. gelit is not completed
 @test_skip gelit([],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[:y],Meta.parse("-P(y)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test_skip gelit([],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == false

 @test_skip gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,z)")) == true
 @test_skip gelit( [:z,:w],Meta.parse("-P(w,f(z))"), [:x,:y],Meta.parse("-P(x,y)")) == false
 @test_skip gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,f(z))")) == true
end

@testset "sort clause" begin
# dont used sortcls
 @test_skip sortcls([:y, :x], Meta.parse("[+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a)]").args)
 @test_skip sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a),-R(b)]").args)
 @test_skip sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),+R(a)]").args) == ([:y,:x],Meta.parse("[+P(a), +R(a), -Q(x,y), -R(b)]").args)
end

@testset  "iscap" begin
 @test iscap("abc") == false
 @test iscap("aBC") == false
 @test iscap("Abc") == true
 @test iscap("ABC") == true
end

