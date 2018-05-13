# reso.jl

include("misc.jl")
include("primitives.jl")

# input form
# "[x,y].[+P(x,f(x),-Q(x)]"

# internal form
# CForm = ([:x,:y], [:(+(P(x,f(x)))), :(-(Q(x)))])
# CForm2 = (:C12, [:x,:y], [:(+(P(x,f(x)))), :(-(Q(x)))])


## result
# :NAP is Not APplicable 

Clause = Array
Literal = Expr

EmptyClause = []

CForm = Tuple{Array,Array}
EmptyCForm = ([],EmptyClause)

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

"""
apply substitution to a term, substitution
"""
function apply(vars::Vlist, sym::Number, subst::Tlist)
 return sym
end

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

function unify0(vars::Vlist, t1::Number, t2::Number)
 if t1==t2; return () end
 throw(ICMP(t1,t2,:unify0nn))
end

function unify0(vars::Vlist, t1::Number, t2::Symbol)
 if isvar(t1,vars); return (t1,t2) end
 if isvar(t2,vars); return (t2,t1) end
 throw(ICMP(t1,t2,:unify0ns))
end

function unify0(vars::Vlist, t1::Number, t2::Expr)
 throw(ICMP(t1,t2,:unify0ne))
end

function unify0(vars::Vlist, t1::Expr, t2::Number)
 throw(ICMP(t1,t2,:unify0en))
end

function unify0(vars::Vlist, t1::Symbol, t2::Number)
 if isvar(t1,vars); return (t1,t2) end
 if isvar(t2,vars); return (t2,t1) end
 throw(ICMP(t1,t2,:unify0sn))
end

function unify0(vars::Vlist, t1::Symbol, t2::Symbol)
 if t1==t2; return () end
 if isvar(t1,vars); return (t1,t2) end
 if isvar(t2,vars); return (t2,t1) end
 if t1!=t2; throw(ICMP(t1,t2,:unify0ss)) end
end

function inside(vt::Symbol, et::Expr)::Bool
  for arg in et.args
   if typeof(arg) == Symbol
    if vt == arg; throw(Loop(vt,et,:insidese)) end
   else
    if inside(vt, arg);return throw(Loop(vt,et,:insidese)) end
   end
  end
  return false
end

function unify0(vars::Vlist, t1::Symbol, t2::Expr)
 isvar(t1,vars) && !inside(t1,t2) && return (t1,t2) 
 if t1!=t2; throw(ICMP(t1,t2,:unify0se)) end
end

function unify0(vars::Vlist, t1::Expr, t2::Symbol)
 isvar(t2,vars)&&!inside(t2,t1)&&return(t2,t1)
 if t1!=t2; throw(ICMP(t1,t2,:unify0es)) end
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
    if t2!=subst[ix];throw(ICMPIn(t1,t2,subst,:unify1ss1))end 
    subst[ix] = t2
  end
  return subst
 end
 if isvar(t2,vars)
  ix = find(x->x==t2,vars)[1]
  if isvar(subst[ix],vars)
    if t1!=subst[ix];throw(ICMPIn(t1,t2,subst,:unify1ss2))end 
    subst[ix] = t1
  end
  return subst
 end
 throw(ICMP(t1,t2,:unify1ss3))
end

function unify1(vars::Vlist, t1::Symbol, t2::Expr, subst::Tlist)
 if isvar(t1,vars);return t2 end
 throw(ICMP(t1,t2,:unify1se))
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
 if t1==t2; 
  return vars
 end
 if t1.args[1] != t2.args[1];
  return vars 
 end 
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

function rename(vars, C::Clause, nvar)::Clause
 if isempty(vars); return C end
 apply(vars, C, nvar)
end

"""
resolution clash the i1'th of c1 with i2'th of c2
"""
function resolution(vars::Vlist, c1::Clause, c2::Clause, i1::Int, i2::Int)
# clause c1,c2 is an array.

 if length(c1) < i1; println("i1 over the c1's length");return :NAP end
 if length(c2) < i2; println("i2 over the c2's length");return :NAP end
 if i1 <= 0; println("i1 should be >=0");return :NAP end
 if i2 <= 0; println("i2 should be >=0");return :NAP end

 lit1 = c1[i1]
 lit2 = c2[i2]

 if lit1.args[1] == lit2.args[1]; return :NAP end
 lit1.args[1] = lit2.args[1]  # temporarily let signs same

 try 
  sigma = unify(vars, lit1, lit2)
  c1=vcat(c1[1:(i1-1)],c1[(i1+1):end],c2[1:(i2-1)],c2[(i2+1):end])
  r1,s1 = apply(vars,c1,sigma), sigma
  return r1,s1
 catch e
  if isa(e, Loop)
   return :FAIL
  end
 end
 return :NAP
end

function resolution(var1::Vlist, c1::Clause, i1::Int, var2::Vlist, c2::Clause, i2::Int)
 vs1 = genvars(var1)
 vs2 = genvars(var2)
 var = vcat(vs1,vs2)  
 rc1=rename(var1, c1, vs1)
 rc2=rename(var2, c2, vs2)
 rv = resolution(var, rc1, rc2, i1, i2)
 if typeof(rv) == Symbol;return rv end
 r1,sigma = rv
 return (var, r1), sigma
end

function resolution(c1::CForm, i1::Int, c2::CForm,i2::Int)
 cc1=deepcopy(c1)
 cc2=deepcopy(c2)
 rv =resolution(cc1[1],cc1[2],i1, cc2[1],cc2[2],i2)
 if typeof(rv) == Symbol; return rv end 
 cf,sigma=rv
 return renamereadable(cf,sigma)
end


"""
reduction
"""
function reduction(vars::Vlist, c1::Clause, i1::Int)
 if length(c1) < i1; println("i1 over the c1's length");return :NAP end
 if i1 <= 0; println("i1 should be >=0");return :NAP end
 lit1 = c1[i1]
 atm1 = lit1.args[2]

 for i2 in 1:length(c1)
  if i2==i1; continue end
   lit2 = c1[i2]
   atm2 = lit2.args[2]
   if atm1.args[1] != atm2.args[1]; continue end
   if lit1.args[1] != lit2.args[1]; continue end

   try 
    sigma = unify(vars, lit1, lit2)
    c1=vcat(c1[1:(i1-1)],c1[(i1+1):end])
    r1=apply(vars,c1,sigma)
    return renamereadable((vars, r1), sigma)
   catch e
    continue
   end
 end
 return ((vars,c1),[])
end

function reduction(c1::CForm, i1::Int)
 reduction(c1[1], c1[2], i1)
end

"""
satisfiable check
"""
function satisfiable(vars::Vlist, c1::Clause)
 for i1 in 1:length(c1) 
  lit1 = c1[i1]
  atm1 = lit1.args[2]

  for i2 in i1+1:length(c1)
   lit2 = c1[i2]
   atm2 = lit2.args[2]
   if atm1.args[1] != atm2.args[1]; continue end
   if lit1.args[1] == lit2.args[1]; continue end
   lit2.args[1] = lit1.args[1] # temporaly let it same

   try 
    sigma = unify(vars, lit1, lit2)
    return true
   catch e
    continue
   end
  end
 end
 return false

end

function satisfiable(c1::CForm)
 satisfiable(c1[1], c1[2])
end

### variable lists

numberingvar(vs::Array{Symbol},i::Int) = map(v->Symbol(v,i),vs)

function readablevars(n::Int)
 rv = [:u,:v,:w,:x,:y,:z]
 vars=[]
 for i in 1:ceil(Int, n/length(rv))
   append!(vars, numberingvar(rv, i))
 end
 vars[1:n]::Vlist
end

function containvar(vars::Vlist, form::Expr)
  cvars=[]::Vlist
  for arg in form.args
   if typeof(arg) == Symbol
    if arg in vars
      push!(cvars, arg)
    end
   else
    pvars =  containvar(vars, arg)
    append!(cvars, pvars)
   end
  end
  return union(cvars,cvars)
end

function containvar(vars::Vlist, cls::Clause)
  cvars=[]::Vlist
  for lit in cls
   pvars =  containvar(vars, lit)
   append!(cvars, pvars)
  end
  return union(cvars,cvars)
end

function reducesub(vars::Vlist, fvars::Vlist, sub::Tlist)
 fsub  = []
 if isempty(sub); return [] end
 for i in 1:length(vars)
  if vars[i] in fvars
    push!(fsub, sub[i])
  end
 end
 return fsub
end

function fitvars(vars::Vlist, cls::Clause, sub::Tlist)
 fvars = containvar(vars, cls)
 fsub = reducesub(vars, fvars, sub)
 return((fvars, cls), fsub)
end

function renamereadable(clause::CForm, sub::Tlist)
 vars = clause[1]
 cls  = clause[2]
 rvars = readablevars(length(vars))
 rcls = apply(vars, cls, rvars)
 rsub = apply(vars, sub, rvars)
 fcls, fsub = fitvars(rvars, rcls, rsub)
 return fcls,fsub
end

function equalclause(clause1::CForm, clause2::CForm)
 rcls1,rsub1=renamereadable(clause1, [])
 rcls2,rsub2=renamereadable(clause2, [])

 var1=rcls1[1]
 cls1=rcls1[2]
 var2=rcls2[1]
 cls2=rcls2[2]

 if length(var1)!=length(var2);return false end
 if length(cls1)!=length(cls2);return false end

 scls2 = apply(var2, cls2, var1)
 if cls1 == scls2; return true end
 return false
end

