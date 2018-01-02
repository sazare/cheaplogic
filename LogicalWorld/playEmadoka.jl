# playLogicalWorld.jl

using Base.Test

##english grammer
include("egrammer.jl")


#Magical world
const QB=:QB
const Homura=:Homura
const Madoka=:Madoka
const Sayaka=:Sayaka
const Kamijo=:Kamijo
const Kyoko=:Kyoko
const Mami=:Mami
const Hitomi=:Hitomi
const Walpurgis=:Walpurgis
const mahosyojo=:mahosyojo
const witch=:witch
const soulgem=:soulgem


MagicalWorld=[
  [Homura love Madoka],
  [Kyoko love Sayaka],
  [Sayaka love Kamijo],
  [Hitomi love Kamijo],
  [Kamijo love Hitomi],
  [Madoka is mahosyojo],
  [Homura is mahosyojo],
  [Kyoko is mahosyojo],
  [Mami is mahosyojo],
  [Sayaka is mahosyojo],
  [Homura have soulgem],
  [Sayaka have soulgem],
  [Kyoko have soulgem],
  [Mami have soulgem],
  [QB make mahosyojo],
  [mahosyojo become witch]
]

MagicalWorld2=[
  [Homura love Madoka],
  [Kyoko love Sayaka],
  [Sayaka love Kamijo],
  [Hitomi love Kamijo],
  [Madoka is mahosyojo],
  [Homura is mahosyojo],
  [Kyoko is mahosyojo],
  [Mami is mahosyojo],
  [Sayaka is mahosyojo],
  [Homura have soulgem],
  [Sayaka have soulgem],
  [Kyoko have soulgem],
  [Mami have soulgem],
  [QB make mahosyojo],
  [mahosyojo become witch]
]

#==
## Query samples
solveQ([who],[[who is mahosyojo]],MagicalWorld)
solveQ([who],[[who have soulgem]],MagicalWorld)
solveQ([who],[[who have soulgem],[who love Kamijo]],MagicalWorld)

solveQ([who,what],[[what become witch]],MagicalWorld)
mm=solveQ([who,what],[[who have soulgem],[what become witch]],MagicalWorld)
statements([who,what],[[who have soulgem],[what become witch]],mm)

## 
@testset "reflection rule" begin
 @test solveQ([:who1,:who2],[[:who1 love :who2],[:who2 love :who1]], MagicalWorld)==[[:Hitomi,:Kamijo],[:Kamijo,:Hitomi]]

# [] means no model valid
 @test solveQ([:who1,:who2],[[:who1 love :who2],[:who2 love :who1]], MagicalWorld2)==[]

end
==#


