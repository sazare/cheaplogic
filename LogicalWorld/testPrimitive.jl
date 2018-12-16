using Test

global flog = open("log.testPrimitive", "a+")

#@testset "Primitive Variations Tests" begin
# modelからfalseを除外するのは適切なのかどうか?
 
 @testset "1 var Test" begin
  @test solveQ([],[[:a]], [[:a]]) == [[]]
  @test solveQ([],[[:a]], [[:b]]) == []
  @test solveQ([:x],[[:a]], [[:a]]) == [[:x]]
  @test solveQ([:x],[[:b]], [[:a]]) == []
  @test solveQ([:x],[[:x]], [[:a]]) == [[:a]]

  @test solveQ([:x],[[:a],[:b]], [[:a]]) == []
  @test solveQ([:x],[[:a],[:b]], [[:a],[:b]]) == [[:x]]

  @test solveQ([:x],[[:x]], [[:a],[:b]]) == [[:a],[:b]]
  @test solveQ([:x],[[:a],[:b]], [[:b],[:a]]) == [[:x]]

  @test solveQ([:x],[[:a :x],[:x :b]], [[:a :b],[:a :b]]) == []

 end

 @testset "2 vars Test" begin
  @test solveQ([:x,:y],[[:x :y]],[[:a :b]]) == [[:a,:b]]
  @test solveQ([:x,:y],[[:x :b],[:a :y]],[[:a :b]]) == [[:a,:b]]
  @test solveQ([:x,:y],[[:x :b],[:y :a]],[[:a :b]]) == []
  @test solveQ([:x,:y],[[:a :b]],[[:a :b]]) == [[:x,:y]]

# 変数をいれかえても結果は同じになる。
  @test solveQ([:x,:y],[[:x :b]],[[:a :b]]) == [[:a,:y]]
  @test solveQ([:x,:y],[[:y :b]],[[:a :b]]) == [[:x,:a]]

# 2 facts
  @test solveQ([:x,:y],[[:x :b],[:y :a]],[[:a :b],[:b :a]]) == [[:a,:b]]
  @test solveQ([:x,:y],[[:x :b],[:y :b]],[[:a :b]]) == [[:a,:a]]
# [:x :x]の強制力はないのか?
# xとyは独立にそれぞれ別のfactとunifyされるので、このような答えになる。
  @test solveQ([:x,:y],[[:x :x],[:y :y]],[[:a :a],[:b :b]]) == [[:a,:a],[:a,:b],[:b,:a],[:b,:b]]
# これが同一性を示しているように見えるのはたまたまのようだ
  @test solveQ([:x,:y],[[:x :x],[:y :y]],[[:a :a]]) == [[:a,:a]]
#これなら同一性になる
  @test solveQ([:x],[[:x :x]],[[:a :a],[:b :b]]) == [[:a],[:b]]
# ↑は、この世界での同一性を示すインスタンスの集合ということ

# Queryの間のandを考えたいときは、個別のsolveQ()を実行した結果を見るしかなさそう
 
 end

 @testset "2 gramatical const Test" begin
#これは確かに同一性だが、一般的な「同一性」は表現できていない
  @test solveQ([:x],[[:P :x :x]], [[:P :a :a]]) == [[:a]]
  @test solveQ([:x],[[:P :x :x]], [[:P :a :a],[:P :b :b]]) == [[:a],[:b]]

 end

 @testset "2 grammatical Test" begin
  @test solveQ([:x,:y],[[:x :is :kudamono],[:x :is :red]],[[:ringo :is :kudamono],[:ringo :is :aka],[:mikan :is :yellow]]) == []
  @test solveQ([:x,:y],[[:x :known :kudamono],[:x :is :red]],[[:mikan :known :kudamono],[:ringo :known :kudamono],[:ringo :is :aka],[:mikan :is :yellow]]) == []

 end

 @testset "3 3 vars Test" begin
  @test solveQ([:x,:y,:z],[[:x :y],[:y :z],[:z :x]], [[:a :b],[:b :c],[:c :a]]) == [[:a,:b,:c],[:b,:c,:a],[:c,:a,:b]] 
 end

kb = [[:H :は :魔法少女],[:M :は :魔法少女],[:H :持つ :盾],[:M :持つ :弓],[:弓 :は :武器],[:盾 :は :防具]]
 @testset "outof range" begin
  @test solveQ([:x,:y,:z,:w],[[:x :は :y],[:x :持つ :z],[:z :は :w]],kb) == [[:H,:魔法少女,:盾,:防具],[:M,:魔法少女,:弓,:武器]]

 end

 @testset "END OF testPrimitive" begin end

#end
close(flog)

