include("utils.jl")
#include("setdata.jl")

using Test

@testset "compare literals" begin
 @test gelit([],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test gelit([:x],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == true
 @test gelit([:x],Meta.parse("-P(x)"),[:y],Meta.parse("-P(y)")) == true
 @test gelit([:x],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test gelit([],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == false

 @test gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,z)")) == true
 @test gelit( [:z,:w],Meta.parse("-P(w,f(z))"), [:x,:y],Meta.parse("-P(x,y)")) == false
 @test gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,f(z))")) == true
end

@testset "sort clause" begin
 @test sortcls([:y, :x], Meta.parse("[+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a)]").args)
 @test sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a),-R(b)]").args)
 @test sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),+R(a)]").args) == ([:y,:x],Meta.parse("[+P(a), +R(a), -Q(x,y), -R(b)]").args)

end

@testset  "iscap" begin
 @test iscap("abc") == false
 @test iscap("aBC") == false
 @test iscap("Abc")
 @test iscap("ABC")
end

