
include("kptype.jl")

## 
# a. all args to be Dict
# b. use args as parsed array
# Which do you like?

# for a, I make a perser to make a predicate something like
#  kpred = struct op::Symbol, args::Dict{Symbol, All} end
# and print() for it.

# when I make a predicate, it keep Dict for args.

# it is not an Expr.

function krprint(args::Dict{Symbol,Any})
  ks = collect(keys(args))
  for i in 1:length(ks)
    k = ks[i]
    print("$(args[k]) $k ")
  end
end

function krprint(expr::KPExpr)
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

function kprint(expr::KPExpr)
 print("$(expr.op)(")
 kprint(expr.args)
 print(")")
end

function kpconv(arr::Array{Any,1})::Dict{Symbol,Any}
 na = Dict{Symbol, Any}()
 for a in arr
   na[a.args[1]] = a.args[2]
 end
 na
end

function kpconv(expr::Expr)::BigExpr
 if length(expr.args) >= 2 && all(x->isa(x,Expr), expr.args[2:end])
  args = kpconv(expr.args[2:end])
  kexp = KPExpr(expr.args[1], args)
  return kexp
 else
  return expr
 end
end


# ksubst
function kpapply(vars::Vlist, args::Dict{Symbol,Any}, sigma::Tlist)
 for k in keys(args)
  args[k] = apply(vars, args[k], sigma)
 end 
 return args
end

function kpapply(vars::Vlist, form::KPExpr, sigma::Tlist)
  form.args=kpapply(vars, form.args, sigma)
  form
end

### kpunify
function apply(terms::Tlist, sym::Symbol, t::Any)
 tms = terms
 for t in terms
   if sym == t; append!(tms, [sym]) end
 end
 tms
end

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


function kpunify(vars::Vlist, exp1::KPExpr, exp2::KPExpr)
 if kpequal(exp1, exp2); return vars end
 if exp1.op != exp2.op; throw(ICMP(exp1.op, exp2.op, :kpunify)) end
 fp_subst(vars, kpunify(vars, exp1.args, exp2.args))
end

function kpunify(vars::Vlist, exp1::Expr, exp2::Expr)
 unify(vars, exp1, exp2)
end


