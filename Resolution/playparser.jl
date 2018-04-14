
include("parser.jl")

## accidentally tokenizer works on it
t1=tokenizer("any.x,z.P(x) or not Q(x) and ( R(x) or Q(z))")

## This is my intension
t2= tokenizer("∀.x.∃.z.P(x) | ¬Q(x) & ( R(x) | Q(z))")

