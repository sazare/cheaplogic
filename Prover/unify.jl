# unif.jl
# types for dvc unify

#include("misc.jl")
#include("primitives.jl")
#include("types.jl")
#include("unifybase.jl")
#include("subst.jl")


## unification
function unify0(vars::Vlist, t1::Number, t2::Number)
 if t1==t2; return () end
 throw(ICMP(t1,t2,:unify0nn))
end

function unify0(vars::Vlist, t1::Number, t2::Expr)
 throw(ICMP(t1,t2,:unify0ne))
end

function unify0(vars::Vlist, t1::Expr, t2::Number)
 throw(ICMP(t1,t2,:unify0en))
end

function unify0(vars::Vlist, t1::Number, t2::Symbol)
##@show :unify0ns,vars,t1,t2
 if isvar(t2,vars); return (t2,t1) end
 throw(ICMP(t1,t2,:unify0ns))
end

function unify0(vars::Vlist, t1::Symbol, t2::Number)
#@show :unify0sn,vars,t1,t2
 if isvar(t1,vars); return (t1,t2) end
 throw(ICMP(t1,t2,:unify0sn))
end

function unify0(vars::Vlist, t1::Symbol, t2::Symbol)
#@show :unify0ss,t1,t2
 if t1==t2; return () end
 if isvar(t1,vars) && isvar(t2,vars)
   if isinvar(t1); return (t2,t1) end
   if isinvar(t2); return (t1,t2) end
 end
 if isvar(t1,vars); return (t1,t2) end
 if isvar(t2,vars); return (t2,t1) end
 if t1!=t2; throw(ICMP(t1,t2,:unify0ss)) end
end


function unify0(vars::Vlist, t1::Symbol, t2::Expr)
#@show :unify0se,t1,t2
 isvar(t1,vars) && !loopcheck(t1,t2) && return (t1,t2) 
 if t1!=t2; throw(ICMP(t1,t2,:unify0se)) end
end

function unify0(vars::Vlist, t1::Expr, t2::Symbol)
#@show :unify0es,t1,t2
 isvar(t2,vars)&&!loopcheck(t2,t1)&&return(t2,t1)
 if t1!=t2; throw(ICMP(t1,t2,:unify0es)) end
end

function unify0(vars::Vlist, t1::Expr, t2::Expr)
#@show :unify0ee,t1,t2
 if t1==t2; return () end
 for i in 1:length(t1.args)
  if t1.args[i]==t2.args[i]; continue end
  σi=unify0(vars,t1.args[i],t2.args[i])
  if σi!=(); return σi end 
 end
 return ()
end

### unify do unification
# t1,t2 are literal(without sign, without or/and.

function unify1(vars::Vlist, t1::Number, t2::Number, subst::Tlist)
#@show :unify1vnn,t1,t2,subst
 if t1==t2; return subst end
 throw(ICMP(t1,t2,:unify1nn))
end

function unify1(vars::Vlist, t1::Expr, t2::Number, subst::Tlist)
#@show :unify1ven,t1,t2,subst
 throw(ICMP(t1,t2,:unify1en))
end
function unify1(vars::Vlist, t1::Number, t2::Expr, subst::Tlist)
#@show :unify1vne,t1,t2,subst
 throw(ICMP(t1,t2,:unify1ne))
end

"""
replace v with t in σ when v is var. and fixed point of σ.
if v<-s in σ, and s is var, replace v with t.
otherwise exception
"""
function putsubst(vars, v::Symbol, t::Any, subst::Tlist)
 if v == t; return subst end

 ix = vindex(vars, v)
 if ix == 0; println("unknown var $v in putsubst");return subst end

 ot = subst[ix]
 if ot == t; return subst end
 if !isvar(ot, vars)
  if ot == t; return subst
  elseif isvar(t, vars)
    v = t
    t = ot
    ix = vindex(vars, v)
    if ix == 0; throw(ICMP(ot,t,:putsubst)) end
  else
   throw(ICMP(ot,t,:putsubst)) 
  end

  subst=putarray(subst, ix, t)
  return subst
 else
  subst=putarray(subst, ix, t)

  rsubst=[]
  while subst != rsubst
   ix = vindex(vars, ot)
   if ix == 0; println("unknown var $v in putsubst")
     throw(ICMP(ot,t,:unify1ss3))
   end
#@show ix
   rsubst=putsubst(vars, ot, t, subst) # backward subst
   subst=rsubst
#@show subst,rsubst
   ot = subst[ix]
  end
  fsubst = fp_subst(vars, rsubst) # forward subst
  return fsubst
 end
#@show "$ot is not ovar"
 if t == ot; return fp_subst(vars, subst) end
 throw(ICMP(v,t,:unify1ne))
end

function unify1(vars::Vlist, t1::Symbol, t2::Number, subst::Tlist)
#@show :unify1vsn,t1,t2,subst
 putsubst(vars, t1, t2, subst)
end

function unify1(vars::Vlist, t1::Number, t2::Symbol, subst::Tlist)
#@show :unify1vns,t1,t2,subst
 putsubst(vars, t2, t1, subst)
end

function unify1(vars::Vlist, t1::Symbol, t2::Symbol, subst::Tlist)
#@show :unify1vss,t1,t2,subst
 if t1==t2;return subst end

 if isvar(t1,vars)
   return putsubst(vars, t1, t2, subst)
 end
 if isvar(t2,vars)
   return putsubst(vars, t2, t1, subst)
 end

 throw(ICMP(t1,t2,:unify1ss3))
# if isvar(t1,vars)
#  ix = findfirst(x->x==t1,vars)
#  if t1 == subst[ix] # t1 is var and havn't substituted yet. 
#    subst[ix] = t2
#  elseif isvar(subst[ix],vars)
#@show :unify1vss1, vars, t1, t2, subst[ix], vars
##    if t2!=subst[ix]; throw(ICMPIn(t1,t2,subst,:unify1ss1))end 
#    subst[ix] = t2
#  end
#  return subst
# end
#
# if isvar(t2,vars)
#  ix = findfirst(x->x==t2,vars)
#  if isvar(subst[ix], vars)
#@show :unify1vss2, vars, t1, t2, subst[ix], vars
#    subst[ix] = t1
#  end
#  return subst
# end
# throw(ICMP(t1,t2,:unify1ss3))
end

function unify1(vars::Vlist, t1::Symbol, t2::Expr, subst::Tlist)
#@show :unify1vse,t1,t2,subst
 if isvar(t1,vars);return putsubst(vars, t1, t2, subst) end
# if isvar(t1,vars);return t2 end
 throw(ICMP(t1,t2,:unify1se))
end

function unify1(vars::Vlist, t1::Expr, t2::Symbol, subst::Tlist)
#@show :unify1ves,t1,t2,subst
 if isvar(t2,vars);return putsubst(vars, t2, t1, subst) end
# if isvar(t2,vars);return t2 end
 throw(ICMP(t1,t2,:unify1))
end

"""
unify1 has a var subst for internal use
"""
function unify1(vars::Vlist, t1::Expr, t2::Expr, subst::Tlist)
#@show :unifyvee,t1,t2,subst
 if t1==t2; 
  return subst
 end

 if t1.args[1] != t2.args[1];
  throw(ICMP(t1,t2,:unify1ee_1))
 end 

 if length(t1.args) != length(t2.args); return vars end
 while true  
#@show :unify0,vars,t1,t2
  pp = unify0(vars, t1, t2)
  if isempty(pp); break end
  subst = putasubst(vars, pp[1], pp[2], subst)
  t1 = apply(vars,t1,subst)
  t2 = apply(vars,t2,subst)
 end
 subst
end

"""
unify is a main interface for unification
"""

function loopcheck_sigma(vars::Vlist, subst::Tlist)
  for ix in 1:length(vars)
    if typeof(subst[ix]) != Symbol
      loopcheck(vars[ix], subst[ix])
    end
  end
  return false
end

function fp_subst(vars::Vlist, subst::Tlist)
#@show vars, subst
## make a fixed point of sigma(ss)
 sb = subst
 sa = apply(vars, subst, subst)
 while sb != sa
   loopcheck_sigma(vars, sa)
   sb, sa = sa, apply(vars, sa, sa)
 end
 return sa
end

function fp_subst2(vars::Vlist, subst::Tlist)
## make a fixed point of sigma(ss)
 sb = subst
 sa = apply(vars, subst, subst)
 return sa
end

function unify(vars::Vlist, t1::Number, t2::Number)
#@show :unifynn,t1,t2
  if t1 != t2; throw(ICMP(t1,t2,:unify1nn))end
  vars
end

function unify(vars::Vlist, t1::Number, t2::Symbol)
#@show :unifyns,t1,t2
  if t1 == t2; return vars end
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Symbol, t2::Number)
#@show :unifysn,t1,t2
  if t1 == t2; return vars end
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Symbol, t2::Symbol)
#@show :unifyss,t1,t2
  if t1 == t2; return vars end
  unify1(vars, t1, t2, deepcopy(vars))
end

function unify(vars::Vlist, t1::Number, t2::Expr)
#@show :unifyne,t1,t2
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Symbol, t2::Expr)
#@show :unifyse,t1,t2
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Expr, t2::Number)
#@show :unifyen,t1,t2
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Expr, t2::Symbol)
#@show :unifyes,t1,t2
  unify1(vars, t1, t2, vars)
end

function unify(vars::Vlist, t1::Expr, t2::Expr)
#@show :unifyee,t1,t2
 ss = unify1(vars, t1, t2, vars)
#@show vars, ss
 fs = fp_subst(vars, ss)
 return fs 
end

