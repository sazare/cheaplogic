#kpbase.jl 

include("kptype.jl")

## 
# Literal with keywords to KPLiteral

## krprint show a litral like japanese with joshi. toy
function krprint(args::Dict{Symbol,Any})
  ks = collect(keys(args))
  for i in 1:length(ks)
    k = ks[i]
    print("$(args[k]) $k ")
  end
end

function krprint(expr::KPLiteral)
 krprint(expr.args)
 print("$(expr.op).")
end

function kprint(args::Dict{Symbol,Any})
  ks = collect(keys(args))
  for i in 1:length(ks)
    k = ks[i]
    print("$k=$(args[k])")
    if i != length(ks); print(",") end
  end
end

function kprint(expr::KPLiteral)
 print("$(expr.op)(")
 kprint(expr.args)
 print(")")
end

### kpconv:Expr => KPAtom or Expr in case of term
function kpconv(arr::Array{Any,1})::Dict{Symbol,Any}
 na = Dict{Symbol, Any}()
 for a in arr
   na[a.args[1]] = a.args[2]
 end
 na
end

function kpconv(expr::Expr)
 if length(expr.args) >= 2 && all(x->isa(x,Expr), expr.args[2:end])
  args = kpconv(expr.args[2:end])
  katom = KPAtom(expr.args[1], args)
  return katom
 else
  return KPAtom(expr.args[1], KParam())
 end
end

### convert a lit::Expr to a KPLiteral
function lit2kplit(lits::Array)
 rlits = []
 for lit in lits
  push!(rlits, lit2kplit(lit))
 end
 return rlits
end

function lit2kplit(lit::Expr)::KPLiteral
 if lit.args[1] == :+ || lit.args[1] == :-
   return KPLiteral(lit.args[1], kpconv(lit.args[2]))
 end
end

## literal compare
kplitequal(x::KPLiteral, y::KPLiteral) = x.sign == y.sign && kpatomequal(x.atom, y.atom)

kpatomequal(x::KPAtom, y::KPAtom) = x.Psym == y.Psym && x.args == y.args

### kpparse
function kpparselit(sexpr::Expr)
#  sign = sexpr.args[1]
  atom = kpconv(sexpr.args[2])
  sexpr.args[2] = atom
  sexpr
end

function kpparsebody(body::Expr)
  lits = body.args[1].args
  for lix in 1:length(lits)
    lits[lix] = kpparselit(lits[lix])
  end
  return body
end

function kpparse(line::String)::BigExpr
 expr = Meta.parse(line)
# vars = expr.args[1]
 body = kpparsebody(expr.args[2])
 expr.args[2] = body
 expr
end

# ksubst
function kpapply(vars::Vlist, lits::Array, sigma::Tlist)
  rlits = []
  for lit in lits
    push!(rlits, kpapply(vars, lit, sigma))
  end
  rlits
end

function kpapply(vars::Vlist, args::Dict{Symbol,Any}, sigma::Tlist)
 for k in keys(args)
  args[k] = apply(vars, args[k], sigma)
 end 
 return args
end

function kpapply(vars::Vlist, form::KPLiteral, sigma::Tlist)
  form.atom=kpapply(vars, form.atom, sigma)
  form
end

function kpapply(vars::Vlist, form::KPAtom, sigma::Tlist)
  form.args=kpapply(vars, form.args, sigma)
  form
end

function apply(terms::Tlist, sym::Symbol, t::Any)
 tms = terms
 for t in terms
   if sym == t; append!(tms, [sym]) end
 end
 tms
end

### kpunify
function kpunify(vars::Vlist, exp1::Symbol, exp2::Number)
 unify1(vars, exp1, exp2, vars)
end

function kpunify(vars::Vlist, exp1::Number, exp2::Symbol)
 unify1(vars, exp1, exp2, vars)
end

function kpunify(vars::Vlist, exp1::Symbol, exp2::Symbol)
 if exp1 == exp2; return [] end

# left is a var

 if isvar(exp1, vars)
  unify1(vars, exp1, exp2, vars)
 else 
  unify1(vars, exp2, exp1, vars)
 end
end

function applysubst(vars::Vlist, sig::Tlist, sv::Var, ss::Term)
 rsig = []
 for ix in 1:length(vars)
  v  = vars[ix]
  t1 = sig[ix]
  if v != sv
   append!(rsig, [t1])
   continue 
  else
   sig=unify(vars, t1, ss)
   if !isa(sig, Array)
     ss2 = apply(vars, t1, [sig])
   else
     ss2 = apply(vars, t1, sig)
   end
   append!(rsig, [ss2])
  end
 end
 rsig
end

function kpunify(vars::Vlist, args1::Dict{Symbol, Any}, args2::Dict{Symbol, Any})
 ks = intersect(keys(args1), keys(args2))
 sigma = vars
 for k in ks
  t1 = args1[k]
  t2 = args2[k]
  if t1==t2; continue end
  ws = unify1(vars, t1, t2, sigma)
  sigma = apply(vars, sigma, ws)
 end
 sigma 
end


function kpunify(vars::Vlist, exp1::KPAtom, exp2::KPAtom)
 if kpatomequal(exp1, exp2); return vars end
 if exp1.Psym != exp2.Psym; throw(ICMP(exp1.Psym, exp2.Psym, :kpunify)) end
 fp_subst(vars, kpunify(vars, exp1.args, exp2.args))
end

function kpunify(vars::Vlist, exp1::Expr, exp2::Expr)
 unify(vars, exp1, exp2)
end


