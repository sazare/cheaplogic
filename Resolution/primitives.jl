# primitives.jl

#==
 Key concept is GOAL
 but not define it as type.

 GOAL is a literal Array.
 And a Set of GOAL should be maintained.
==#

## Type declare

FTerm=Expr
Term=Union{Symbol, Number, Expr}
Var = Symbol
Const = Union{Symbol, Number}

Vlist = Array
Tlist = Array

struct EQTerm
 sign
 psym
 body
end

Equation=Array{EQTerm}

## primitives
isvar(sym::Symbol, vars::Vlist)=sym in vars
isvar(term, vars::Vlist)=false

isconst(sym::Symbol, vars::Vlist)=!(sym in vars)
isconst(sym::Number, vars::Vlist)=true

