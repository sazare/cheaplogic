using Base.Test

include("LogicoW.jl")

@testset "substw"
 @test substw([:x,:y],[:P :x :y],[[:x,:y]) == [:P :x :y]
 @test substw([:x,:y],[:P :x :y],[[:x],[:y]]) == [:P :x :y]
 @test substw([:x,:y],[:P :x :y],[:a,:b]) == [:P :a :b]
 @test substw([:x,:y],[:P :x :y],[[:a],[:b]]) == [:P :a :b]
 @test substw([:x,:y],[:P :x :y],[[:a :b],[:c :d]]) == [:P :a :b :c :d]
 @test substw([:x,:y],[:P :x :k :y],[[:a :b],[:c :d]]) == [:P :a :b :k :c :d]
 @test substw([:x,:y],[:P :x :y],[[],[:c :d]]) == [:P :c :d]
 @test substw([:x,:y],[:P :x :y],[[:a :b],[]]) == [:P :a :b]

end

@testset "unifyttw Tests" begin

 @test unifyttw([:x,:y],[:x :c :y], [:P :a :b :d :e :f]) == [:x,:y]
 @test unifyttw([:x,:y],[:x :c :y], [:P :a :b :c :d :e :f]) == [[:P :a :b],[:e :f]]
 @test unifyttw([:x,:y],[:x :c :y], [:P :a :b :c]) == [[:P :a :b],[]]
 @test unifyttw([:x,:y],[:x :c :y], [:P :c :d :e]) == [[:P],[:d :e]]

 @test unifyttw([:x,:y],[:x :y], [:P :a :b :c :d :e :f]) == [[:P :a :b :c :d :e :f],[]]

 @test unifyttw([:x,:y],[:x :c :y], [:a :c :d]) == [[:a],[:d]]
 @test unifyttw([:x,:y],[:x :c :y], [:c :d]) == [[],[:d]]
 @test unifyttw([:x,:y],[:x :c :y], [:a :c])== [[:a],[]]
 @test unifyttw([:x,:y],[:P :x :c :y], [:P :a :c :d]) == [[:a],[:d]] # or [:a,:d]
 @test unifyttw([:x,:y],[:P :x :c :y], [:P :a :b :c :d]) == [[:a :b],[:d]] # or [[:a :b],:d]
 @test unifyttw([:x,:y],[:P :x :c :y], [:P :a :b :c :d :e :f]) == [[:a :b],[:e :f]]


 @test unifyttw([:x,:y],[:P :x :c :y], [:P :c]) == [[],[]]
 @test unifyttw([:x,:y],[:P :x :c :y], [:P :a :c]) == [[:a],[]]
 @test unifyttw([:x,:y],[:P :x :c :y], [:P :c :b]) == [[],[:b]]
end

