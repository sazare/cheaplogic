using Test

include("playMadoka.jl")

println()
q1=[[:x は :y が 好き],[:y は 上条 が 好き],[:x は 魔法少女 です]]
println("Q:$(stringT(q1))")
a1=solveQ([:x,:y,:z],q1,魔法会議)
println("A: $a1")

println()
q2=[[:x は :y が 好き],[:y は 上条 が 好き],[:x は 魔法少女 です]]
println("Q:$(stringT(q2))")
a2=solveQ([:x,:y,:z],q2,魔法会議)
println("A: $a2")

println()
q3=[[:x は :y が 好き],[:y は :z が 好き],[:z は :x が 好き]]
println("Q:$(stringT(q3))")
a3=solveQ([:x,:y,:z],q3,魔法会議)
println("A: $a3")

println()
q4=[[:x は :y が 好き]]
println("Q:$(stringT(q4))")
a4=solveQ([:x,:y],q4,魔法会議)
println("A: $a4")

println()
q5=[[:x は :y が 好き],[:y は :x が 好き]]
println("Q:$(stringT(q5))")
a5=solveQ([:x,:y],q5,魔法会議)
println("A: $a5") #; printQM([:x,:y],q5,a5)

println()
q6=[[:y が 魔女 に なる],[:x は :y です],[:z は :y を 作る]]
#q6=[[:x は :y です],[:z は :y を 作る],[:y が 魔女 に なる]]
println("Q:$(stringT(q6))")
a6=solveQ([:x,:y,:z],q6,魔法会議)
println("A: $a6") #; printQM([:x,:y,:z],q6,a6)
