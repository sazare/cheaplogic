#test_factorgame.jl
# test for factorgame.jl

using Base.Test

push!(LOAD_PATH, ".")

import FactorGame: shiftnum, samenum, factornum, factorgame

@testset "for shiftnum" begin
 @test shiftnum(0,0) == 0
 @test shiftnum(0,1) == 1
 @test shiftnum(10,1) == 101
 @test shiftnum(10,21) == 1021
end

@testset "for samenum" begin
 @test samenum(1,1, 0) == 1
 @test samenum(2,1, 0) == 2
 @test samenum(2,3, 0) == 222
 @test samenum(11,3, 0) == 111111

 @test samenum(1,1, 123) == 1231
 @test samenum(2,1, 123) == 1232
 @test samenum(2,3, 123) == 123222
 @test samenum(11,3, 123) == 123111111
end

@testset "for factornum" begin
 @test factornum(1) == 1
 @test factornum(2) == 2
 @test factornum(3) == 3
 @test factornum(12) == 223
 @test factornum(18) == 233
 @test factornum(8) == 222
 @test factornum(9) == 33
end

@testset "for factorgame" begin
 @test factorgame(2) == 2
 @test factorgame(3) == 3
 @test factorgame(4) == 211
 @test factorgame(6) == 23
 @test factorgame(9) == 311
 @test factorgame(12) == 223
 @test factorgame(8) == 3331113965338635107
end

