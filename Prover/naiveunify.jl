# naiveunify.jl

## original algorithm

"""
find disagreement pair
"""
function disagreement(t1::Any, t2::Any)
 if t1==t2; return () end
 if !isa(t1,Expr) || !isa(t2,Expr)
   return (t1,t2)
 end
 if t1.args[1] != t2.args[1]; return (t1,t2) end

 for ix = 2:length(t1.args)
  a1 = t1.args[ix]
  a2 = t2.args[ix]
  Δ=disagreement(a1, a2) 
  if Δ != (); return Δ end
 end
 return ()
end
 
### unify0(vars, t1, t2, 
function unify0(vars, t1, t2, sigma)

end

### t1==t2 is resolved in unify
## t1!=t2 is assumed

function direction(vars::Vlist, t1::Any, t2::Any)
  if isvar(t1, vars)
    isa(t2, Expr) && loopcheck(t1, t2)
    return (t1, t2)
  end
  if isvar(t2, vars);
    isa(t1, Expr) && loopcheck(t2, t1)
    return (t2, t1)
  end
  throw(ICMP(t1,t2,:unify1en))
end

function unify1(vars::Vlist, t1::Expr, t2::Expr, σ::Tlist)::Tlist
  if t1.args[1] != t2.args[1]; throw(ICMP(t1,t2,:unify1ee)) end
  while true
    Δ=disagreement(t1, t2)
# one of Δ should be a Symbol(var)
    if Δ==(); break end
    Δa=direction(vars, Δ[1],Δ[2])
    σa = putasubst(vars,Δa[1],Δa[2],σ)
    t1 = apply(vars, t1, σa)
    t2 = apply(vars, t2, σa)
    σ = apply2(vars, σ, σa)
  end
  return σ
end

"""
unify 2 terms
"""
function unify(vars::Vlist, t1::Any, t2::Any)::Tlist
  σ = deepcopy(vars)
  if t1==t2; return σ end
  unify1(vars, t1, t2, σ)
end

