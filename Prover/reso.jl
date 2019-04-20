# reso.jl

#include("misc.jl")
#include("primitives.jl")
#include("types.jl")
#include("unify.jl")

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

