# testEmadoka.jl
using Base.Test

include("Facto.jl")
include("playEmadoka.jl")

@testset "Madoka test" begin
 @testset "basic test" begin
  @test solveQ([who],[[who is mahosyojo]],MagicalWorld) == [[:Madoka],[:Homura],[:Kyoko],[:Mami],[:Sayaka]]
  @test solveQ([who],[[who have soulgem]],MagicalWorld) == [[:Homura],[:Sayaka],[:Kyoko],[:Mami]]
  @test solveQ([who],[[who have soulgem],[who love Kamijo]],MagicalWorld) == [[:Sayaka]]
  @test solveQ([who,what],[[what become witch]],MagicalWorld) == [[:who,:mahosyojo]]
 end
 
 ##
 @testset "reflection rule" begin
  @test solveQ([:who1,:who2],[[:who1 love :who2],[:who2 love :who1]], MagicalWorld)==[[:Hitomi,:Kamijo],[:Kamijo,:Hitomi]]
 
 # [] means no model valid
  @test solveQ([:who1,:who2],[[:who1 love :who2],[:who2 love :who1]], MagicalWorld2)==[]
 
 end
end 
