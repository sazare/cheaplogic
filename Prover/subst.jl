# apply is operations over substitution

include("primitives.jl")

"""
apply substitution to a term, substitution
"""
function apply(vars::Vlist, sym::Number, subst::Tlist)
#@show :applynt, sym, subst
 return sym
end

function apply(vars::Vlist, sym::Symbol, subst::Tlist)
#@show :applyst, sym, subst
 for i in 1:length(vars)
  if sym == vars[i]; return subst[i] end
 end
 return sym
end

"""
apply: ΣxΣ → Σ
"""
function apply(vars::Vlist, subst1::Tlist, subst2::Tlist)
#@show :applytt, subst1, subst2
 nterm = []
 for arg in subst1
  narg = apply(vars, arg, subst2)
  if isempty(nterm)
   nterm = [narg]
  elseif ndims(subst1) == 1
     nterm = vcat(nterm, [narg])
  else
     nterm = hcat(nterm, [narg])
  end
 end
 nterm
end

function apply(vars::Vlist, term::Expr, subst::Tlist)
#@show :applyet, term, subst
 nterm = deepcopy(term)
 for i in 1:length(term.args)
  arg = term.args[i]
  narg = apply(vars, arg, subst)
  nterm.args[i] = narg
 end
 nterm
end

