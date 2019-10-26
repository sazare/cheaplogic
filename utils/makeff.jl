# intension
# for performance test, I want to have a big formula
# genform(dep, wid, syms::Array{Symbol}) makes such thing.
# wid is width size, dep is depth size.
# It may be a rectangle.
# the symbols are choosed from syms
# rand(syms) may be ok.
#


function baseff(var, fun, n)
  exp = :(f())
  exp.args = fill(var, n+1)
  exp.args[1] = fun
  exp
end

function replace1(var, base, arg)
  rexp = deepcopy(base)
  for ix in 1:length(base.args)
    if var == rexp.args[ix]
      rexp.args[ix] = arg
    end
  end
  return rexp
end

function makedd(var, exp, sexp, ndep, nwid)
  rexp = exp
  if ndep <= 0 
    return replace1(var, exp, sexp)
  else
    sexp = makedd(var, exp, sexp, ndep-1, nwid)
    rep = replace1(var, exp, sexp)
    return rep
  end
end

function makeff(var, fsym, ssym, ndep, nwid)
  bexp =  baseff(var, fsym, nwid)
  if ndep <= 0; return bexp end
  base = baseff(var, ssym, nwid)
  narg = deepcopy(base)
  narg = makedd(var, base, narg, ndep-2, nwid)
  rexp = replace1(var, bexp, narg)
  return rexp

end

