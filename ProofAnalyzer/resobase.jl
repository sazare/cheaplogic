# basics for resolution

# make_binding2#
function make_binding2(vl1, vl2)
  if length(vl1) != length(vl2); return end
  b = Dict()
  for ix in 1:length(vl1)
    v1 = vl1[ix] 
    v2 = vl2[ix]
    b[v1] = v2
  end
  return b
end

# mapexpr
function mapexpr(fn, term::Symbol) 
  fn(term)
end

function mapexpr(fn, expr::Expr)
  rexpr = expr
  for ix in 1:length(expr.args)
    rexpr.args[ix] = mapexpr(fn, expr.args[ix])
  end
  return rexpr
end

# represent_*
function represent_term(b, tm)
  fn(x) = get(b, x, x)
  mapexpr(fn, tm)
end


function represent_as(b, exp)
  nexp = []
  for tm in exp
    push!(nexp, represent_term(b, tm))
  end
  return nexp
end

### subst
function subst(b, exp)
  fn(x) = get(b, x, x)
  mapexpr(fn, exp)
end

### unify
function fp_subst(sigma::Dict)
  sig = sigma
  for k in keys(sigma)
    sig[k] = subst(sig, sig[k])
  end
  return sig
end

function unify(sigma::Dict, exp1::Symbol, exp2::Symbol)
  if exp1 == exp2
    return sigma
  else
    if exp1 in keys(sigma)
      if sigma[exp1] == exp2; return sigma end
    end      
    return Dict(exp1 => exp2)
  end
  return Dict()
end


