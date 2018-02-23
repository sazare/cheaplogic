# primitives.jl

## Type declare

FTerm=Expr
Term=Union{Symbol, Number, Expr}
Var = Symbol
Const = Union{Symbol, Number}

Vlist = Array
Tlist = Array

## primitives
isvar(sym::Symbol, vars::Vlist)=sym in vars
isvar(term, vars::Vlist)=false

isconst(sym::Symbol, vars::Vlist)=!(sym in vars)
isconst(sym::Number, vars::Vlist)=true

