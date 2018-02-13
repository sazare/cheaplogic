#print
function printcdb(cdb) 
 if isempty(cdb)
  println("empty")
 else
  map(ncl->println("$(ncl.cid): $(ncl.vars)"), cdb)
 end
end

function printldb(ldb)
 if isempty(ldb)
  println("empty")
 else
  map(nli->println("$(nli.lid): $(nli.body)"),ldb)
 end
end

function printmap(symmap)
 if isempty(keys(symmap))
  println("empty")
 else
  for key in keys(symmap)
   println("$key=>$(symmap[key])")
  end
 end
end

function printcore(core)
println("Psyms")
 println(core.allpsym)
 println()
println("CDB")
 printcdb(core.cdb)
println()
println("LDB")
 printldb(core.ldb)
println()
println("LCMAP")
 printmap(core.lcmap)
println()
println("CLMAP")
 printmap(core.clmap)
end

#### resolvent
function printliteral(lid, core)
 println("  $lid.$(literalof(lid,core))")
end

function printclause(cid, core)
 println("$cid $(varsof(cid, core)).")
 for lid in lidsof(cid, core)
  printliteral(lid, core)
 end
end

function printresolvent(rid, rdb, core)
 rrd = rdb[getno(rid)]
 println("$rid $(rrd.vars).")
 println("  {$(literalof(rrd.left, core)):$(literalof(rrd.right, core))}")

 for lid in rrd.body
  println("  $(literalof(lid, core))")
 end
 println("σ:$(rrd.sigma)")
end



