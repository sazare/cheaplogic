# primitives.jl

#==
 Key concept is GOAL
 but not define it as type.

 GOAL is a literal Array.
 And a Set of GOAL should be maintained.
==#

## Type declare

FTerm=Expr
Term=Union{Symbol, Number, String, Char, Expr}
Var = Symbol
Const = Union{Symbol, Number, String}

Vlist = Array
Tlist = Array

## primitives
isvar(sym::Symbol, vars::Vlist)=sym in vars
isvar(term, vars::Vlist)=false

iscap(x) = isuppercase(String(x)[1])
isinvar(x) = '!' == String(x)[end]

function isevar(sym::Symbol, vars::Vlist)
 isvar(sym, vars) && iscap(sym)
end
isevar(sym, vars::Vlist)=false

isconst(sym::Symbol, vars::Vlist)=!(sym in vars)
isconst(sym::Number, vars::Vlist)=true
isconst(sym::String, vars::Vlist)=true
isconst(sym::Char, vars::Vlist)=true

# function 
macro isdefined(x)
  try
    eval(x)
  catch 
    return false
  end
  return true
end

function isground(vars::Vlist, tm::Number)
 return true
end

function isground(vars::Vlist, tm::String)
 return true
end

function isground(vars::Vlist, tm::Char)
 return true
end

function isground(vars::Vlist, tm::Symbol)
 return !isvar(tm, vars)
end

function isground(vars::Vlist, tm::Expr)
 all(atm->isground(vars,atm), tm.args[2:end])
end

function isground(vars::Vlist, tms::Array{Expr,1})
 all(atm->isground(vars,atm), tms)
end


########## Expr op(these should be good features)
function signof(e::Expr)
 e.args[1]
end
function psymof(e::Expr)
 e.args[2].args[1]
end # signof

function lsymof(e::Expr)
 lsym(e.args[1], e.args[2].args[1])
end #lsymof

function argsof(e::Expr)
 e.args[2:end]
end # argsof

"""
complsign(pn::Symbol) + to -, - to +
"""
function compsign(pn::Symbol)
 if pn == :+ ; return(:-)
 elseif pn == :- ; return(:+)
 else throw(ArgumentError("compsign: notsign $(string(pn))"))
 end #if
end # compsign

"""
complsym(lsym) makes complement lsymbol
"""
function complsym(lsym)
 pn = Symbol(string(lsym)[1])
 npn = compsign(pn)
 Symbol(npn,string(lsym)[2:end])
end

