# reso.jl

## Type declare

Term=Union{Symbol,Number,Expr}
Var = Symbol
Const = Union{Symbol,Number}

Vlist = Array
Tlist = Array

## result
# :NAP is Not APplicable 

EmptyClause = :([])

## Exceptions
"""
Exception for ununifiable terms in subst
"""
struct ICMPIn
 left
 right
 subst
 op
end

"""
Exception for ununifiable terms
"""
struct ICMP
 left
 right
 op
end

struct Loop
 left
 right
 op
end

## primitives
isvar(sym::Symbol,vars::Vlist)=sym in vars
isvar(term,vars::Vlist)=false

isconst(sym::Symbol,vars::Vlist)=!(sym in vars)
isconst(sym::Number,vars::Vlist)=true

"""
apply substitution to a term, substitution
"""
function apply(vars::Vlist, sym::Symbol, subst::Tlist)
 if !isvar(sym, vars); return sym end
 for i in 1:length(vars)
  if sym == vars[i]; return subst[i] end
 end
 return sym
end

function apply(vars::Vlist, subst1::Tlist, subst2::Tlist)
 nterm = []
 for arg in subst1
  narg = apply(vars, arg, subst2)
  if isempty(nterm)
   nterm = [narg]
  else
   if ndims(subst1) == 1
     nterm = vcat(nterm, [narg])
   else
     nterm = hcat(nterm, [narg])
   end
  end
 end
 nterm
end

function apply(vars::Vlist, term::Expr, subst::Tlist)
 nterm = deepcopy(term)
 for i in 1:length(term.args)
  arg = term.args[i]
  narg = apply(vars, arg, subst)
  nterm.args[i] = narg
 end
 nterm
end

## unification
"""
putasubst puts a pair of v,t to a substituion
"""
function putasubst(vars::Vlist, vt::Symbol, tm::Term, subst::Tlist)
 rs = map(x->if x==vt;tm else x end, subst)
end

function unify0(vars::Vlist, t1::Symbol, t2::Symbol)
 if t1==t2; return () end
 if isvar(t1,vars); return (t1,t2) end
 if isvar(t2,vars); return (t2,t1) end
 if t1!=t2; throw(ICMP(t1,t2,:unify0)) end
end

function inside(vt::Symbol, et::Expr)::Bool
  for arg in et.args
   if typeof(arg) == Symbol
    if vt == arg; throw(Loop(vt,et,:inside)) end
   else
    if inside(vt, arg);return throw(Loop(vt,et,:inside)) end
   end
  end
  return false
end

function unify0(vars::Vlist, t1::Symbol, t2::Expr)
 isvar(t1,vars) && !inside(t1,t2) && return (t1,t2) 
 if t1!=t2; throw(ICMP(t1,t2,:unify0)) end
end

function unify0(vars::Vlist, t1::Expr, t2::Symbol)
 isvar(t2,vars)&&!inside(t2,t1)&&return(t2,t1)
 if t1!=t2; throw(ICMP(t1,t2,:unify0)) end
end

function unify0(vars::Vlist, t1::Expr, t2::Expr)
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

function unify1(vars::Vlist, t1::Symbol, t2::Symbol, subst::Tlist)
  if t1!=t2; throw(ICMP(t1,t2,:unify1)) end
  σb=vars
  while(true)
   σa=unify0(vars,t1,t2)
   if σa==(); break end
   σi = merge(vars, σb, σa) 
   t1 = apply(t1,σi)
   t2 = apply(t2,σi)
   σb=σa
  end
 σb
end

function unify1(vars::Vlist, t1::Symbol, t2::Symbol, subst::Tlist)
 if t1==t2;return subst end
 if isvar(t1,vars)
  ix = find(x->x==t1,vars)[1]
  if isvar(subst[ix],vars)
    if t2!=subst[ix];throw(ICMPIn(t1,t2,subst,:unify1))end 
    subst[ix] = t2
  end
  return subst
 end
 if isvar(t2,vars)
  ix = find(x->x==t2,vars)[1]
  if isvar(subst[ix],vars)
    if t1!=subst[ix];throw(ICMPIn(t1,t2,subst,:unify1))end 
    subst[ix] = t1
  end
  return subst
 end
 throw(ICMP(t1,t2,:unify1))
end

function unify1(vars::Vlist, t1::Symbol, t2::Expr, subst::Tlist)
 if isvar(t1,vars);return t2 end
 throw(ICMP(t1,t2,:unify1))
end

function unify1(vars::Vlist, t1::Expr, t2::Symbol, subst::Tlist)
 if isvar(t2,vars);return t2 end
 throw(ICMP(t1,t2,:unify1))
end
"""
unify1 has a var subst for internal use
"""
function unify1(vars::Vlist, t1::Expr, t2::Expr, subst::Tlist)
# if isempty(subst); subst = vars end
 if t1==t2; return vars end
 if t1.args[1] != t2.args[1]; return vars end 
 if length(t1.args) != length(t2.args); return vars end
 while true  
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
function unify(vars::Vlist, t1::Expr, t2::Expr)
 unify1(vars, t1, t2, vars)
end

## resolution of 2 clauses
function genvars(vars::Vlist)::Vlist
 map(v->gensym(v),vars)
end

function rename(vars, C::Expr, nvar)::Expr
 apply(vars, C, nvar)
end

"""
resolution clash the i1'th of c1 with i2'th of c2
"""
function resolution(vars::Vlist, c1::Expr, c2::Expr, i1::Int, i2::Int)
# clause c1,c2 is an array.

 if length(c1.args) < i1; println("i1 over the c1's length");return :NAP end
 if length(c2.args) < i2; println("i2 over the c2's length");return :NAP end
 if i1 <= 0; println("i1 should be >=0");return :NAP end
 if i2 <= 0; println("i2 should be >=0");return :NAP end

 lit1 = c1.args[i1]
 lit2 = c2.args[i2]

 if lit1.args[1] == lit2.args[1]; return :NAP end
 lit1.args[1] = lit2.args[1]  # temporarily let signs same

 try 
  sigma = unify(vars, lit1, lit2)
  c1.args=vcat(c1.args[1:(i1-1)],c1.args[(i1+1):end],c2.args[1:(i2-1)],c2.args[(i2+1):end])
  return apply(vars,c1,sigma)
 catch e
  if isa(e, Loop)
   return :FAIL
  end
 end
 return :NAP
end

function resolution(var1::Vlist, c1::Expr, i1::Int, var2::Vlist, c2::Expr, i2::Int)
 vs1 = genvars(var1)
 vs2 = genvars(var2)
 var = vcat(vs1,vs2)  
 rc1=rename(var1, c1, vs1)
 rc2=rename(var2, c2, vs2)
 return var, resolution(var, rc1, rc2, i1, i2)
end

