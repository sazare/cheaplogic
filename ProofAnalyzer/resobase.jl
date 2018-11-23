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

struct Fail
 left
 right
 op
end

function insidep(sigma::Dict, var::Symbol, term::Expr)

end

isSymbol(x) = typeof(x) == Symbol

isvar(simga::Dict, sym::Expr)::Bool = false
isconst(simga::Dict, sym::Expr)::Bool = false

function isvar(sigma::Dict, sym::Symbol)::Bool
  if !isSymbol(sym); return false end
  return sym in keys(sigma)
end

function isconst(sigma::Dict, sym::Symbol)::Bool
  if !isSymbol(sym); return false end
  return !(sym in keys(sigma))
end

function unify(sigma::Dict, exp1::Symbol, exp2::Symbol)
  if exp1 == exp2  # anyway same
    return sigma
  else
    if exp1 in keys(sigma) # exp1 is a var
      if sigma[exp1] == exp2; return sigma
      else
        sigma[exp1] = exp2 
        return sigma 
      end
    elseif exp2 in keys(sigma) # exp1 is const and exp2 is a var
      if sigma[exp2] == exp1; return sigma
      else
        sigma[exp2] = exp1
        return sigma 
      end
    else   # both const and not same
      throw(Fail(exp1, exp2, :unifySS))
    end      
@show exp1,exp2
  end
end

