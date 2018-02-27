#print

function printliteral(lit)
 print(lit)
end

function printclause(cls)
 if isempty(cls)
  print("□")
 else
  for lit in cls
   printliteral(lit)
  end
 end
end

function printclause(cid, core)
 vars,cls = getcls(cdb, cid)
 print("$cid:")
 printvars(vars)
 print(".")
 printclause(cls)
end



function printcdb(cdb) 
 if isempty(cdb)
  println("empty")
 else
  map(cid->println("$(cid): $(cdb[cid])"), keys(cdb))
 end
end

function printldb(ldb)
 if isempty(ldb)
  println("empty")
 else
  map(lid->println("$(lid): $(ldb[lid].body)"),keys(ldb))
 end
end

function printamap(amap)
 if isempty(keys(amap))
  println("empty")
 else
  map(key->println("$key=>$(amap[key])"), keys(amap))
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
 printamap(core.lcmap)
println()
println("CLMAP")
 printamap(core.clmap)
 println("\n-- end of core --")
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
 rrd = rdb[rid]
 println("$rid $(rrd.vars).")
 println("  {$(literalof(rrd.left, core)):$(literalof(rrd.right, core))}")

 for lid in rrd.body
  println("  $(literalof(lid, core))")
 end
 println("σ:$(rrd.sigma)")
end



