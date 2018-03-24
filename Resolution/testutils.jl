using Base.Test

include("utils.jl")
#include("setdata.jl")

@testset "compare literals" begin
 @test gelit([],parse("-P(x)"),[],parse("-P(x)")) == true
 @test gelit([:x],parse("-P(x)"),[:x],parse("-P(x)")) == true
 @test gelit([:x],parse("-P(x)"),[:y],parse("-P(y)")) == true
 @test gelit([:x],parse("-P(x)"),[],parse("-P(x)")) == true
 @test gelit([],parse("-P(x)"),[:x],parse("-P(x)")) == false

 @test gelit([:x,:y],parse("-P(x,y)"),[:z,:w],parse("-P(w,z)")) == true
 @test gelit( [:z,:w],parse("-P(w,f(z))"), [:x,:y],parse("-P(x,y)")) == false
 @test gelit([:x,:y],parse("-P(x,y)"),[:z,:w],parse("-P(w,f(z))")) == true
end

@testset "sort clause" begin
 @test sortcls([:y, :x], parse("[+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],parse("[+P(a),-Q(x,y),-R(a)]").args)
 @test sortcls([:y, :x], parse("[-R(b),+P(a),-Q(x,y),-R(a)]").args) == ([:y,:x],parse("[+P(a),-Q(x,y),-R(a),-R(b)]").args)
 @test sortcls([:y, :x], parse("[-R(b),+P(a),-Q(x,y),+R(a)]").args) == ([:y,:x],parse("[+P(a), +R(a), -Q(x,y), -R(b)]").args)

end

@testset  "iscap" begin
 @test iscap("abc") == false
 @test iscap("aBC") == false
 @test iscap("Abc")
 @test iscap("ABC")
end

