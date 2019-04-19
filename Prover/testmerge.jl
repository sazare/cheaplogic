#include("merge.jl")

using Test

@testset "merge 2 subst" begin
# @test_throws Comparative merge([],:x,:a) 
 @test merge([],:x,:x) == :x
 @test merge([:x],:x,:x) == :x
 @test merge([:x],:x,:a) == :a
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
