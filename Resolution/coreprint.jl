#print

function printliteral(lit)
 print(lit)
end

function printlid(lid, core)
  print(" $lid.")
  printliteral(literalof(lid, core).body)
end

function printlids(lids, core)
 if isempty(lids)
  print("□")
 else
  for i in 1:length(lids)
    i!=1 && print(",")
#   println()
   printlid(lids[i], core)
  end
 end
end

function printbody(cls)
 if !isempty(cls)
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
 print("$cid:")
 printvars(varsof(cid, core))

# if isempty(lidsof(cid,core)); print(".");
# else println(".") end
print(".")

 printlids(lidsof(cid,core), core)
 #printbody(cls.body)
end

printclauseof(lid, core) = printclause(cidof(lid, core),core)

function printclauses(core)
  for cid in sort(collect(keys(core.cdb)))
    printclause(cid, core)
println()
  end
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

function printstep(step)
  print("$(step.rid):<$(step.leftp):$(step.rightp)>=")
  printvars(step.sigma)
end

function printproof(proof)
 for rid in sort(collect(keys(proof)))
   step = proof[rid]
   printstep(step)
   println()
 end
end

function printaproof0(rid, core)
 !(rid in keys(core.proof)) && return
 step=core.proof[rid]
 printaproof0(cidof(step.leftp,core), core)
 printaproof0(cidof(step.rightp,core), core)
 println("$rid=<$(cidof(step.leftp, core)):$(cidof(step.rightp, core))>")
end

function printns(shift)
  map(x->print(" "), 1:2shift)
end

function printaproof1(rid, core, shift=0)
  if rid in sort(collect(keys(core.proof)))
    step = core.proof[rid]
    printaproof1(cidof(step.leftp,core), core, shift+1)
    printaproof1(cidof(step.rightp,core), core, shift+1)

    println()
#    printns(shift)
    print("  ")
    print("<$(step.leftp):")
    print("$(step.rightp)>=")
    print_list(ovarsof(step.leftp, step.rightp, core))
    print("←")
    print_list(step.sigma)
    println()
#    printns(shift)
    printclause(rid, core)
  else
    println()
#    printns(shift)
    printclause(rid, core)
  end
end

function printproofs0(core)
 for rid in sort(contradictionsof(core))
  printaproof0(rid, core)
  println("\n---")
 end
end

function printproofs1(core)
 for rid in sort(contradictionsof(core))
  printaproof1(rid, core)
  println("\n---")
 end
end

function printmgu0(ovars, sigma, orig)
  for i in 1:length(ovars)
    if orig 
      if ovars[i] != sigma[i]
        print("$(ovars[i])/$(sigma[i]); ")
      end
    else
      if origof(ovars[i]) != origof(sigma[i])
        print("$(origof(ovars[i]))/$(origof(sigma[i])); ")
      end
    end
  end
end

function printmgu(rid, core, orig)
  if rid in keys(core.proof)
    step = core.proof[rid]
    printmgu(cidof(step.leftp,core), core, orig)
    printmgu(cidof(step.rightp,core), core, orig)

    println()
    print("  ")
    print("<$(step.leftp):")
    print("$(step.rightp)>=")
    printmgu0(ovarsof(step.leftp, step.rightp, core), step.sigma, orig)
  end
end

function printmgus(core, orig=false)
 for rid in contradictionsof(core)
  printmgu(rid, core, orig)
  println("\n---")
 end
end

function printproc(proc)
 for p in proc
  println("!$p")
 end
end

function printcore(core)
println("name = $(core.name)")
println("max cid = $(core.maxcid)")
println("max rid = $(core.maxrid)")
println("Psyms = $(core.allpsym)")
println("Proc")
printproc(core.proc)
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
println()
println("TEMPLATE(level0)")
 printtemplates0(core.level0,core)
println()
println("PROOFS")
 printproof(core.proof)
 println("\n-- end of core --")
end

#### resolvent
function printliteral(lid, core)
 println("  $lid:$(literalof(lid,core).body)")
end

#### template

function printlid0(lid, core)
  print("$(lsymof(lid, core))")
end

function printlids0(lids, core)
  for lid in lids
   printlid0(lid, core)
  end
end

function printtemplate0(key, eq, core)
  print("$key= ")
  body=eq
  for i in 1:length(body)
    i!=1 && print("*")
    printlid0(body[i][3], core)
    print("[")
    printlids0(body[i][4],core)
    print("]($(body[i][1]))")
  end
end

function printtemplates0(eqs, core)
  for key in keys(eqs)
    eq = eqs[key]
    printtemplate0(key, eq, core)
    println()
  end
end

function printtemplate1(key, eq, core)
  print("$key= ")
  body=eq
  for i in 1:length(body)
    i!=1 && println("*")
    ll=body[i]
    printlid(ll[3], core)
    print("[")
    printlids(ll[4],core)
    print("]")
    print(" ($(ll[1]))")
  end
end

function printtemplates1(eqs,core)
  for key in keys(eqs)
    eq = eqs[key]
    printtemplate1(key, eq, core)
    println()
  end
end

##  print goal
function printgoal(goal, core)
  for lid in goal
    printliteral(lid, core)
  end   
end

function printgoals(goals, core)
  for g in goals
    printgoal(g, core)
    println()
  end   
end

function print_list(set)
 print("[")
 for ei in 1:length(set)
  e = set[ei]
  if ei != 1; print(",") end
  print("$e")
 end
 print("]")
end

function print_coreinfo(core)
println("core info...")

(v,c,f,p) = analyze_sym(core)
print("vars     = #$(length(collect(v))):"); print_list(collect(v));println()
print("consts   = #$(length(collect(c))):"); print_list(collect(c));println()
print("funcs    = #$(length(collect(f))):"); print_list(collect(f));println()
print("preds    = #$(length(collect(p))):"); print_list(collect(p));println()  
print("clauses  = #$(length(keys(core.cdb))):"); print_list(collect(keys(core.cdb)));println()
print("literals = #$(length(keys(core.ldb))):"); print_list(collect(keys(core.ldb)));println()

end

