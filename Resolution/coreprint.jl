#print

function printliteral(lit)
 print(lit)
end

function printlids(lids, core)
 if isempty(lids)
  print("□")
 else
  for i in 1:length(lids)
   println()
   print(" $(lids[i]) = ")
   printliteral(literalof(lids[i], core).body)
  end
 end
end

function printbody(cls)
 if isempty(cls)
  print("□")
 else
  for i in 1:length(cls)
   println()
   print(" ")
   printliteral(cls[i])
  end
 end
end

function printvars(vars)
 print("[")
 for i in 1:length(vars)
  i != 1 && print(",")
  print(vars[i])
 end
 print("]")
end

function printclause(cid, core)
 print("\n$cid:")
 printvars(varsof(cid, core))
 print(".")
 printlids(lidsof(cid,core), core)
 #printbody(cls.body)
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
println("max cid = $(core.maxcid)")
println("max rid = $(core.maxrid)")
println("Psyms = $(core.allpsym)")
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
#=
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


==#
