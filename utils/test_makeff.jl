using Test
include("makeff.jl")

@testset "baseff" begin
  @test :(f(x)) == baseff(:x, :f, 1)
  @test :(f(x,x)) == baseff(:x, :f, 2)
  @test :(f(x,x,x)) == baseff(:x, :f, 3)
  @test :(P(x,x,x)) == baseff(:x, :P, 3)
end

@testset "replace1" begin
  @test :(P(f(x,x,x,x), f(x,x,x,x))) == replace1(:x, :(P(x,x)), :(f(x,x,x,x)))
  @test :(P(f(x,x,x,x), g(x), f(x,x,x,x))) == replace1(:x, :(P(x,g(x),x)), :(f(x,x,x,x)))

end

@testset "makedd" begin
  @test :(f(x)) == makedd(:x, :(f(x)), :x, 0, 1)
  @test :(f(f(x))) == makedd(:x, :(f(x)), :x, 1, 1)
  @test :(f(f(f(x)))) == makedd(:x, :(f(x)), :x, 2, 1)
  @test :(f(f(f(f(x))))) == makedd(:x, :(f(x)), :x, 3, 1)
end

@testset "makeff(1,*)" begin
  @test :(P()) == makeff(:x, :P, :f, 1, 0)
  @test :(P(f(f(x)))) == makeff(:x, :P, :f, 1, 1)
  @test :(P(f(f(x,x),f(x,x)),f(f(x,x),f(x,x)))) == makeff(:x, :P, :f, 1, 2)
  @test :(P(f(f(x,x,x),f(x,x,x),f(x,x,x)),f(f(x,x,x),f(x,x,x),f(x,x,x)),f(f(x,x,x),f(x,x,x),f(x,x,x)))) == makeff(:x, :P, :f, 1, 3)
end

@testset "makeff(*,1)" begin
  @test :(P(x)) == makeff(:x, :P, :f, 0, 1)
  @test :(P(f(f(x)))) == makeff(:x, :P, :f, 1, 1)
  @test :(P(f(f(x)))) == makeff(:x, :P, :f, 2, 1)
  @test :(P(f(f(f(x))))) == makeff(:x, :P, :f, 3, 1)
  @test :(P(f(f(f(f(x)))))) == makeff(:x, :P, :f, 4, 1)
end

@testset "makeff(*,*)" begin
  @test :(P(f(f(x,x),f(x,x)),f(f(x,x),f(x,x)))) == makeff(:x, :P, :f, 2, 2)
  @test :(P(f(f(x,x,x),f(x,x,x),f(x,x,x)),f(f(x,x,x),f(x,x,x),f(x,x,x)),f(f(x,x,x),f(x,x,x),f(x,x,x)))) == makeff(:x, :P, :f, 2, 3)

  @test :(P(f(f(f(x,x),f(x,x)),f(f(x,x),f(x,x))),f(f(f(x,x),f(x,x)),f(f(x,x),f(x,x))))) == makeff(:x, :P, :f, 3, 2)
  @test :(P(f(f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x))), f(f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x))), f(f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x)), f(f(x, x, x), f(x, x, x), f(x, x, x))))) == makeff(:x, :P, :f, 3, 3)

end

