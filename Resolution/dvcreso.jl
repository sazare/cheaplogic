# post-rename DVC version

include("primitives.jl")

# variable manipulation

const SEPSYM='_'

issym(x) = typeof(x)==Symbol
iscid(x) = issym(x) && string(x)[1] == 'C'
isrid(x) = issym(x) && string(x)[1] == 'R'
hasid(x) = search(string(x), SEPSYM) != 0

function newvar(xid, var) 
 if hasid(var)
   return Symbol(var, xid)
 else
   return Symbol(var, SEPSYM, xid)
 end
end

function newvarlist(xid, varlist)
 map(var->newvar(xid, var), varlist)
end

# Resolvent
function rename_term(xid, vars, term::Term)
  if issym(term)
    if isvar(term, vars)
      return newvar(xid, term)
    else
      return term 
    end
  else
    params = term.args
    term.args = map(param->rename_term(xid, vars, param),params)
    return term
  end
end


function rename_clause(xid, vars, clause)
  (newvarlist(xid, vars), rename_term(xid, vars, clause))
end

## Equation
function psymof(lid, core)
 lit = literalof(lid, core).body
 (lit.args[1], lit.args[2].args[1])
end

inverseof(sign) = if sign == :- ; :+ else :- end

function litis(sign, psym, lid, core)
 (osign, opsym) = psymof(lid, core)
 return osign == inverseof(sign) && opsym == psym
end

function oppositof(sign, psym, core)
 rems = []

 for olid in keys(core.ldb)
  lfm2 = core.ldb[olid]
  if litis(sign, psym, olid, core) 
    push!(rems, olid)
  end
 end
 rems
 
end

struct EQTerm
 vars
 head
 body
end

function equationof(sign, psym, core)
 eqs = Dict()
 oppos = oppositof(sign, psym, core)
 body = []
 for lid in oppos
  cid = cidof(lid, core)
  lids = lidsof(cid, core)
  rem = setdiff(lids, [lid])
@show rem
  push!(body, [cid, varsof(cid, core), lid, rem])
 end
 [(sign, psym), body]
end

