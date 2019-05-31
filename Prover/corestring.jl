function stringcore(core)::String

"""
CORE
$(core.name)
CLAUSES
$(stringclauses(core))
PSYM
$(stringvars(core.allpsym))
"""
end


function stringclauses(core)::String
 rstr = ""
 for cid in keys(core.cdb)
  rstr *= stringclause(cid, core) * "\n"
 end
 rstr
end

function stringclause(cid, core)::String
 "$cid:$(stringvars(varsof(cid, core))).[$(stringlids(lidsof(cid,core), core))]"
end

stringvars(vars)::String = stringarray(vars)

function stringarray(arr)::String
 rstr = "[" 
 for i in 1:length(arr)
  rstr *= string(arr[i])
  if i != length(arr) ; rstr *= "," end
 end
 rstr * "]"
end

function stringlids(lids, core)::String
 rstr = ""
 if isempty(lids)
  "□"
 else
  for i in 1:length(lids)
    if i!=1 ; rstr *= "," end
    rstr *= stringlid(lids[i], core)
  end
 end
 rstr
end

function stringlid(lid, core)::String
  "$lid:$(stringliteral(literalof(lid, core).body))"
end

function stringliteral(lit)::String
 rstr = ""
 if isa(lit, Number) || isa(lit, Symbol)
   rstr *= string(lit)
 else
   rstr = string(lit.args[1]) * "("
   for ix in 2:length(lit.args)
    arg = lit.args[ix]
    rstr *= stringliteral(arg)
    if ix < length(lit.args); rstr *= "," end
   end
   rstr *= ")"
 end
 rstr
end


