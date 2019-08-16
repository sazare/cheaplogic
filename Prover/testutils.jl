#include("utils.jl")
#include("setdata.jl")

using Test
#==
@testset "dont used compare literals" begin
 @test_skip gelit([],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[:y],Meta.parse("-P(y)")) == true
 @test_skip gelit([:x],Meta.parse("-P(x)"),[],Meta.parse("-P(x)")) == true
 @test_skip gelit([],Meta.parse("-P(x)"),[:x],Meta.parse("-P(x)")) == false

 @test_skip gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,z)")) == true
 @test_skip gelit( [:z,:w],Meta.parse("-P(w,f(z))"), [:x,:y],Meta.parse("-P(x,y)")) == false
 @test_skip gelit([:x,:y],Meta.parse("-P(x,y)"),[:z,:w],Meta.parse("-P(w,f(z))")) == true
end

@testset "dont used sort clause" begin
 @test_skip sortcls([:y, :x], Meta.parse("[+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a)]").args)
 @test_skip sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],Meta.parse("[+P(a),-Q(x,y),-R(a),-R(b)]").args)
 @test_skip sortcls([:y, :x], Meta.parse("[-R(b),+P(a),-Q(x,y),+R(a)]").args) == ([:y,:x],Meta.parse("[+P(a), +R(a), -Q(x,y), -R(b)]").args)
end
==#

@testset  "iscap" begin
 @test iscap("abc") == false
 @test iscap("aBC") == false
 @test iscap("Abc") == true
 @test iscap("ABC") == true
end

@testset "ltid" begin
 @test ltid(:C1, :C2) == true
 @test ltid(:C1, :C12) == true
 @test ltid(:C11, :C2) == false
 @test ltid(:C11, :C12) == true
 @test ltid(:C11, :C1) == false
 @test ltid(:C113, :R1) == true
 @test ltid(:C113, :R130) == true
 @test ltid(:C1113, :R130) == true
 @test ltid(:R3, :C130) == false


end

