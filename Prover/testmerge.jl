include("merge.jl")

using Test

@testset "merge 2 subst" begin
# @test_throws Comparative merge([],:x,:a) 
 @test merge([],:x,:x) == :x
 @test merge([:x],:x,:x) == :x
 @test merge([:x],:x,:a) == :a
end

@testset "apply subst" begin
 @test apply([],:(P(x)),[]) == :(P(x))
 @test apply([:x],:x,[:a]) == :a
 @test apply([:x],:(x),[:a]) == :(a)
 @test apply([:x],:(P(x)),[:a]) == :(P(a))
 @test apply([:x,:y],:(P(x,f(y))),[:a,:b]) == :(P(a,f(b)))

 @test_skip apply([:x,:y],:(P(x,y)),[:a,:x]) == :(P(a,a))
 @test_skip apply([:x,:y],:(P(x,y)),[:y,:a]) == :(P(a,a))

end

@testset "merge arged" begin
 @test merge([:x,:y],[:x,:y],[:x,:y]) == [:x,:y]
 @test merge([:x,:y],[:x,:y],[:a,:b]) == [:a,:b]
 @test merge([:x,:y],[:x,:a],[:x,:y]) == [:x,:a]
 @test merge([:x,:y],[:x,:a],[:b,:a]) == [:b,:a]
 @test merge([:x,:y],[:b,:y],[:x,:a]) == [:b,:a]
 @test merge([:x,:y],[:a,:y],[:x,:y]) == [:a,:y]

 @test merge([:x,:y],[:x,:x],[:a,:x]) == [:a,:a]
 @test merge([:x,:y],[:x,:y],[:a,:x]) == [:a,:a]
 @test merge([:x,:y],[:a,:y],[:y,:x]) == [:a,:a]
 @test merge([:x,:y],[:a,:y],[:a,:x]) == [:a,:a]

# @test_throws Comparative merge([:x,:y],[:a,:y],[:b,:y])
# @test_throws Comparative merge([:x,:y],[:a,:y,:z],[:b,:y])

end
