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

# function 
macro isdefined(x)
  try
    eval(x)
  catch 
    return false
  end
  return true
end
