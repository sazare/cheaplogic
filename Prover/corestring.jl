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

function stringvars(vars)::String
 rstr = "[" 
 for i in 1:length(vars)
  rstr *= string(vars[i])
  if i != length(vars) ; rstr *= "," end
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
   rstr *= String(lit)
 else
   rstr = String(lit.args[1]) * "("
   for ix in 2:length(lit.args)
    arg = lit.args[ix]
    rstr *= stringliteral(arg)
    if ix < length(lit.args); rstr *= "," end
   end
   rstr *= ")"
 end
 rstr
end


