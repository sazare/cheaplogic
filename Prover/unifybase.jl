# unifbase.jl
# common functions for unify on dvc or naive

#include("misc.jl")
#include("primitives.jl")
#include("types.jl")

## unification
"""
putasubst puts a pair of v,t to a substituion
"""
function putasubst(vars::Vlist, vt::Symbol, tm::Term, subst::Tlist)
 rs = map(x->if x==vt;tm else x end, subst)
end

function loopcheck(vt::Symbol, et::Number; istop=false)::Bool
  return false
end

function loopcheck(vt::Symbol, et::Symbol; istop=false)::Bool
  return false
end

function loopcheck(vt::Symbol, et::Expr; istop=true)::Bool
  for arg in et.args
   if typeof(arg) == Symbol
    (vt == arg) && throw(Loop(vt,et,:loopcheckse))
   else
    loopcheck(vt, arg, istop=false)&& return throw(Loop(vt,et,:loopcheckse))
   end
  end
  return false
end

function maketlist(vars::Vlist, t1::Symbol, t2::Symbol)::Tlist
  map(x->if x==t1;t2 else t1 end, vars)
end

"""
replace the ix'th element of tlist with t
without typechecking
"""
function putarray(tlist::Array, ix::Number, t::Any)
  map(i->if i==ix; t else tlist[i] end, 1:length(tlist))
end

function vindex(vars::Vlist, v::Symbol)
 ix = findfirst(x->x==v,vars)
 if ix == nothing; return 0 end
 return ix
end

