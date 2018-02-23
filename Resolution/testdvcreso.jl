using Base.Test

include("dvcreso.jl")

@testset "isid" begin
  @test iscid(:C12)
  @test !iscid(:R12)
  @test isrid(:R11111)
  @test !isrid(:C222)
  @test !iscid("abc")
  @test !isrid("abc")
end
@testset "newvar" begin
  @test newvar(:C4, :x)   == :x_C4
  @test newvar(:C4, :x5)  == :x5_C4
  @test newvar(:C14, :x)  == :x_C14
  @test newvar(:C4, :xC4) == :xC4_C4
  @test newvar(:C4, :xyz) == :xyz_C4

  @test newvar(:R3, :x_C2)               == :x_C2R3
  @test newvar(:R3, :x_C122)             == :x_C122R3
  @test newvar(:R453, :x_C122)           == :x_C122R453
  @test newvar(:R15, :x_C1R9)           == :x_C1R9R15
  @test newvar(:R15, :x_C12R97)         == :x_C12R97R15
end

@testset "newvarlist" begin
  @test newvarlist(:R19, [:z1_C12,:w11_C123R10]) == [:z1_C12R19,:w11_C123R10R19]
  @test newvarlist(:R19, [:x,:y10]) == [:x_R19, :y10_R19]
end

@testset "input rename_term" begin
 @test rename_term(:C3, [], parse("+P(a,b)")) == parse("+P(a,b)")
 @test rename_term(:C3, [], parse("+P(f(a),g(b,a))")) == parse("+P(f(a),g(b,a))")

 @test rename_term(:C3, [:x], parse("+P(x)")) == parse("+P(x_C3)")
 @test rename_term(:C3, [:x], parse("+P(x,x)")) ==  parse("+P(x_C3,x_C3)")
 @test rename_term(:C3, [:x,:y], parse("+P(x,y)")) ==  parse("+P(x_C3, y_C3)")

 @test rename_term(:C3, [:x], parse("+P(fun(x))")) == parse("+P(fun(x_C3))")
 @test rename_term(:C3, [:x], parse("+P(f(x,x))")) == parse("+P(f(x_C3,x_C3))")
 @test rename_term(:C3, [:x,:y], parse("+P(f(x),h(x,y))")) == parse("+P(f(x_C3),h(x_C3,y_C3))")

 @test rename_term(:C3, [:x3,:y2], parse("+P(x3,f(y2))")) == parse("+P(x3_C3, f(y2_C3))")
 @test rename_term(:C3, [:x45,:yz], parse("+P(f(x45),g(yz,x45))")) == parse("+P(f(x45_C3), g(yz_C3, x45_C3))")

end

@testset "resolvent rename_term" begin
 @test rename_term(:R19, [], parse("+P(a,b)")) == parse("+P(a,b)")
 @test rename_term(:R19, [], parse("+P(f(a),g(b,a))")) == parse("+P(f(a),g(b,a))")

 @test rename_term(:R19, [:x_C22], parse("+P(x_C22)")) == parse("+P(x_C22R19)")
 @test rename_term(:R19, [:x_C22], parse("+P(x_C22,x_C22)")) ==  parse("+P(x_C22R19,x_C22R19)")
 @test rename_term(:R19, [:x_C22,:y_C22], parse("+P(x_C22,y_C22)")) ==  parse("+P(x_C22R19, y_C22R19)")

 @test rename_term(:R19, [:x_C22], parse("+P(fun(x_C22))")) == parse("+P(fun(x_C22R19))")
 @test rename_term(:R19, [:x_C22], parse("+P(f(x_C22,x_C22))")) == parse("+P(f(x_C22R19,x_C22R19))")
 @test rename_term(:R19, [:x_C22,:y_C22], parse("+P(f(x_C22),h(x_C22,y_C22))")) == parse("+P(f(x_C22R19),h(x_C22R19,y_C22R19))")

 @test rename_term(:R19, [:x3_C22,:y2_C22], parse("+P(x3_C22,f(y2_C22))")) == parse("+P(x3_C22R19, f(y2_C22R19))")
 @test rename_term(:R19, [:x45_C22,:yz_C22], parse("+P(f(x45_C22),g(yz_C22,x45_C22))")) == parse("+P(f(x45_C22R19), g(yz_C22R19, x45_C22R19))")

end

@testset "rename_clause" begin
 @test rename_clause(:R19, [:x3_C22,:y2_C22,:x3_C11R2], parse("[+P(x3_C22,f(y2_C22)),-Q(h(x3_C11R2,y2_C22),y2_C22)]")) == ([:x3_C22R19,:y2_C22R19,:x3_C11R2R19], parse("[+P(x3_C22R19, f(y2_C22R19)),-Q(h(x3_C11R2R19,y2_C22R19),y2_C22R19)]"))

end

