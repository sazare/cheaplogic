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

