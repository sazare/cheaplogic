using Test

global flog=open("log.testFacto","a+")

#@testset "Logico Tests" begin
 @testset "subst Tests" begin
  @test subst([:v1,:v2,:v3],:like,[:v1,:Akira,:v3]) == :like
  @test subst([:v1,:v2,:v3],:v1,[:v1,:Akira,:v3]) == :v1
  @test subst([:v1,:v2,:v3],:v2,[:v1,:Akira,:v3]) == :Akira
  @test subst([:v1,:v2,:v3],:v2,[:v2,:v3,:v3]) == :v3
 
 # this should not be happen
#@test_skipsubst([:v1,:v2,:v3],:v2,[:v2,:Qbey,:v3])==:Qbey
 
 end
 
 @testset "substitution Tests" begin
  @test substitution([:v1,:v2,:v3],[:v2],[:v1,:Akira,:v3]) == [:Akira]
  @test substitution([:v1,:v2,:v3],[:v1 :v2 :v3 :v2],[:v1,:Akira,:v3]) == [:v1 :Akira :v3 :Akira]
  @test substitution([:v1,:v2,:v3],[:v1 :v2 :Taeko :v2],[:Akira,:Akira,:v2]) == [:Akira :Akira :Taeko :Akira]
  @test substitution([:v1,:v2,:v3],[:v1 :v2 :v3],[:Akira,:v2,:v2]) == [:Akira :v2 :v2]
 
 ## belows are should not happen
 # right side's var should be same in left
 # @test_skip substitution([:v1, :v2, :v3], [:v1 :v2 :v3], [:v2, :Akira, :v2]) == [:Akira :Akira :Akira]
 # @test_skip substitution([:v1, :v2, :v3], [:v1 :v2 :v3], [:v2, :Akira, :v3]) == [:Akira :Akira :v3]
 # @test_skip substitution([:v1, :v2, :v3], [:v1 :v2 :v3], [:Akira, :v1, :v3]) == [:Akira :Akira :Akira]
 end
 
 @testset "substitutionQ Tests" begin
  @test substitutionQ([:v1, :v2, :v3], [[:v1],[:v2],[:v3]], [:A, :v2, :B]) == [[:A],[:v2],[:B]]
  @test substitutionQ([:v1, :v2, :v3], [[:v1 :v1 :v2],[:v1 :v2 :v1],[:v3 :v3 :v3]], [:v1, :A, :v3]) == [[:v1 :v1 :A],[:v1 :A :v1],[:v3 :v3 :v3]]
 end
 
 @testset "unifytt Tests" begin
  @test unifytt([:x,:y],:a,:b) == false

  @test unifytt([:x,:y],:x,:x) == :x
  @test unifytt([:x,:y],:x,:a) == :a
  @test unifytt([:x,:y],:a,:x) == :a
  @test unifytt([:x,:y],:x,:y) == :y
  @test unifytt([:x,:y],:a,:a) == :a
 end

 @testset "unify Tests" begin
  @test unifyqf([:x,:y],[:a :y],[:b,:b]) == false

  @test unifyqf([:x,:y],[:x :y],[:x,:y]) == [:x,:y]
  @test unifyqf([:x,:y],[:x :y],[:a,:y]) == [:a,:y]
  @test unifyqf([:x,:y],[:x :y],[:a,:b]) == [:a,:b]
  @test unifyqf([:x,:y],[:x :y],[:a,:b]) == [:a,:b]
 
  @test unifyqf([:x,:y],[:a :y],[:a,:b]) == [:x,:b]
  @test unifyqf([:x,:y],[:x :b :y],[:a,:b,:a]) == [:a,:a]
  @test unifyqf([:x,:y],[:x :b :y],[:a,:b,:c]) == [:a,:c]
 
  @test  unifyqf([:x,:y],[:a :c],[:a,:b]) == false
 
 end
 
 @testset "unifymm Tests" begin
  @test unifymm([:x,:y], [:x, :y], [:x,:b]) == [:x,:b]
  @test unifymm([:x,:y], [:a, :b], [:a,:b]) == [:a,:b]
  @test unifymm([:x,:y], [:a, :b], [:x,:y]) == [:a,:b]
  @test unifymm([:x,:y], [:a, :y], [:b,:y]) == false
  @test unifymm([:x,:y], [:x, :b], [:b,:c]) == false
 
 end

 @testset "unifyMM Tests" begin
  @test unifyMM([:x,:y], [[:x, :y]], [[:x,:b]]) == [[:x,:b]]
  @test unifyMM([:x,:y], [[:a, :y]], [[:x,:b],[:x,:c]]) == [[:a,:b],[:a,:c]]
  @test unifyMM([:x,:y,:z,:w], [[:a,:y,:b,:w]],[[:x,:b,:b,:d],[:x,:a,:b,:a]]) == [[:a,:b,:b,:d],[:a,:a,:b,:a]]
  @test unifyMM([:x,:y,:z,:w], [[:a,:y,:b,:w],[:d,:y,:z,:w]],[[:x,:b,:b,:d]]) == [[:a,:b,:b,:d],[:d,:b,:b,:d]]
  @test unifyMM([:x,:y,:z,:w], [[:a,:y,:z,:w],[:d,:y,:b,:w]],[[:x,:b,:b,:d]]) == [[:a,:b,:b,:d],[:d,:b,:b,:d]]
  @test unifyMM([:x,:y,:z,:w], [[:a,:y,:b,:w],[:d,:y,:e,:w]],[[:x,:b,:b,:d],[:d,:y,:e,:f]]) == [[:a,:b,:b,:d],[:d,:y,:e,:f]]

 end

#==
 @testset "makemodels Tests" begin
  mm = makemodels([:x,:y],[[:P :x],[:P :b],[:Q :x :y]],[[:P :a],[:P :b],[:Q :a :b],[:Q :b :a]]) == 
# these are irregal array..
  @test mm[1,:]= [[:a,:y] false false]
  @test mm[2,:]= [[:b,:y][:x,:y]false]
  @test mm[3,:]= [false false [:a,:b]]
  @test mm[4,:]= [false false [:b,:a]]]
 end
==#

 @testset "reduction Tests" begin
  mm=makemodels([:x,:y],[[:P :x :x]],[[:P :a :b], [:P :a :b], [:P :b :b], [:P :c :d]]) 
  @test reduction([:x,:y],[:x,:y],mm,1) == [[:b,:y]]

  mm=makemodels([:x,:y],[[:P :x],[:P :b],[:Q :x :y]],[[:P :a],[:P :b],[:Q :a :b],[:Q :b :a]])
  @test reduction([:x,:y],[:x :y],mm,1) == [[:a,:b],[:b,:a]]
 end

 
 @testset "solveq Tests" begin
  @test solveq([:x, :y],[:have :x :orange], [[:have :Hanako :ringko]]) == false
  @test solveq([:x, :y],[:have :x :ringo], [[:have :Hanako :ringo]])==[[:Hanako, :y]]
  @test solveq([:x, :y],[:have :x :y], [[:have :Hanako :ringo],[:have :Kiro :jiro]])==[[:Hanako, :ringo],[:Kiro, :jiro]]
  @test solveq([:x, :y],[:love :x :Hanako],[[:love :Taro :Hanako],[:love :Kenji :Michiko],[:love :Jiro :Hanako],[:kill :Moji :Do],[:love :Hanako :Hanako]]) == [[:Taro, :y],[:Jiro,:y],[:Hanako,:y]]
 end

 @testset "solveQ Tests" begin
  @test solveQ([:x,:y],[[:P :x :x]],[[:P :a :b],[:P :a :b],[:P :b :b],[:P :c :d]]) == [[:b,:y]]
  @test solveQ([:x,:y],[[:P :x :y]],[[:P :a :b],[:P :c :d]]) == [[:a,:b],[:c,:d]]
  @test solveQ([:x,:z],[[:P :x],[:Q :x :z],[:R :z :u]],[[:P :r],[:Q :r :o],[:R :o :u]]) == [[:r,:o]]

## ↓[R :n :*]はどこにもないが、否定できないので[[:r,:n]]が答えになる。いいのか? 否定の扱いの問題
## K's elements are all true. isn't is?
  @test solveQ([:x,:z],[[:P :x],[:Q :x :z],[:R :z :u]],[[:P :r],[:Q :r :n],[:R :o :u]]) == []
  @test solveQ([:x,:z],[[:P :x],[:Q :x :z],[:R :z :u]],[[:P :r],[:Q :r :n],[:R :n :u]]) == [[:r,:n]]

  @test solveQ([:x,:z,:w],[[:P :x],[:Q :x :z],[:R :z :w]],[[:P :r],[:P :s],[:Q :r :o],[:Q :s :u],[:R :u :v],[:R :o :u]]) == [[:r,:o,:u],[:s,:u,:v]]
  @test solveQ([:x,:y,:z], [[:P :a :x], [:Q :x :b :z], [:R :z :u]], [[:P :a :r], [:Q :r :b :o], [:R :o :u]]) == [[:r,:y,:o]]
  @test solveQ([:x,:y,:z],[[:P :a :x],[:Q :x :b :z],[:R :z :w]],[[:P :a :r],[:P :a :s],[:Q :r :b :o],[:Q :r :c :w],[:Q :s :b :h],[:R :o :u],[:R :w :v]] ) == []
  @test solveQ([:x,:y,:z],[[:P :a :x],[:Q :x :b :z],[:R :z :w]],[[:P :a :r],[:P :a :s],[:Q :r :b :o],[:Q :r :c :w],[:Q :s :b :h],[:R :o :w],[:R :w :v]] ) == [[:r,:y,:o]]

# case no contradiction but no model. what is this?
  @test solveQ([:x,:y,:z],[[:P :a :x],[:Q :x :b :z],[:R :z :w]],[[:P :a :r],[:P :a :s],[:Q :r :b :o],[:Q :r :c :w],[:Q :s :b :h],[:R :o :u],[:R :w :v]] ) == []
  @test solveQ([:x,:y],[[:P :x],[:R :y :v],[:Q :x :y]],[[:P :r],[:R :o :u],[:R :w :v],[:Q :r :o],[:Q :r :w],[:Q :s :h]] ) == [[:r,:w]]
  @test solveQ([:x,:y],[[:P :x],[:R :y :v],[:Q :x :y]],[[:P :r],[:P :s],[:R :o :u],[:R :w :v],[:Q :r :o],[:Q :r :w],[:Q :s :w]] ) == [[:r,:w],[:s,:w]]
  @test solveQ([:x,:y],[[:P :x],[:Q :x :y],[:R :y :v]],[[:P :r],[:P :s],[:R :o :u],[:R :w :v],[:Q :r :o],[:Q :r :w],[:Q :s :h]] ) == [[:r,:w]]
  @test solveQ([:x,:y],[[:P :x],[:Q :x :y],[:R :y :u]],[[:P :r],[:P :s],[:Q :r :o],[:Q :r :w],[:Q :s :h],[:R :o :u],[:R :w :v]] ) == [[:r,:o]]

 end
 
 kb=[[:H :know :K],[:H :know :T],[:K :has :ringo],[:T :wear :jacket],[:ringo :is :aka],[:jacket :is :aka]]
 @testset "Final answer Tests" begin
  @test solveQ([:who,:what],[[:H :love :who],[:who :has :what],[:what :is :aka]], [[:H :love :M],[:M :has :ringo],[:ringo :is :aka]]) ==[[:M, :ringo]]

  @test solveQ([:who,:act,:what],[[:H :act :who],[:who :has :what],[:what :is :aka]], [[:H :love :M],[:M :has :ringo],[:ringo :is :aka],[:H :kill :Majo],[:Majo :has :cake],[:cake :is :sweet]]) ==[[:M,:love,:ringo]]

 end

#end

@testset "END OF testFacto" begin end

close(flog)

