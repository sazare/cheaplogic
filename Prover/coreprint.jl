#print
#

function printterm(tm)
 if isa(tm, Symbol)
   print(tm)
 elseif isa(tm, Number)
   print(tm)
 else # term
   print(tm.args[1])
   print_termlist(tm.args[2:end])
 end
end

function print_termlist(tl)
 if length(tl)==0; print("()")
 elseif length(tl)==1; print("(");printterm(tl[1]); print(")")
 else
  print("(")
  printterm(tl[1])
  for tm in tl[2:end]
   print(",")
   printterm(tm)
  end
  print(")")
 end
end

#

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
  for cid in sort(collect(keys(cdb)))
    println("$(cid): $(cdb[cid])")
  end
 end
end

function printldb(ldb)
 if isempty(ldb)
  println("empty")
 else
   for lid in sort(collect(keys(ldb)))
     println("$(lid): $(ldb[lid].body)")
   end
 end
end

function printamap(amap)
 if isempty(keys(amap))
  println("empty")
 else
  for key in collect(keys(amap))
    println("$key=>$(amap[key])")
  end
 end
end

function printstep(step)

  print("$(step.rid):<$(step.leftp):$(step.rightp)>=")
  printvars(step.sigma)
  if length(step.rename) > 1
   print(":")
   length(step.rename)>1 && printvars(step.rename[1])
  end
  if length(step.rename)>2
   print("<-")
   length(step.rename)>2 && printvars(step.rename[2])
  end
  println(" by $(step.rule)")
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
    if :eval != step.leftp && :eval != step.rightp
     print_list(ovarsof(step.leftp, step.rightp, core))
    end
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
      osig = deepcopy(sigma[i])
      if origof(ovars[i]) != origtermof(osig)
        print("$(origof(ovars[i]))/$(origtermof(osig));")
      end
    end
  end
end

function printmgu(rid, core, orig)
  if rid in sort(collect(keys(core.proof)))
    step = core.proof[rid]
    printmgu(cidof(step.leftp,core), core, orig)
    printmgu(cidof(step.rightp,core), core, orig)

    println()
    print("$rid:")
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

function printcano(cano)
 for psym in sort(collect(keys(cano)))
  printvars(cano[psym][1])
  print(".")
  printterm(cano[psym][2])
  println()
 end
end

function printcore(core, showinfo=false)
println("name = $(core.name)")
println("max cid = $(core.maxcid)")
println("max rid = $(core.maxrid)")
showinfo && print_coreinfo(core)
#println("Psyms = $(core.allpsym)")
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
println("CANONICAL")
 printcano(core.cano)
println()
println("TEMPLATE(level0)")
 printtemplates0(core.level0,core)
println()
println("PROOFS")
 printproof(core.proof)
 println("\n-- end of core --")
println()
println("MEASURE")
 println("#trial   = $(core.trycnt[1])")
 println("#success = $(core.succnt[1])")
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
  for key in sort(collect(keys(eqs)))
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
  for key in sort(collect(keys(eqs)))
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

## Analyzer
function print_list(set)
 print("[")
 for ei in 1:length(set)
  e = set[ei]
  if ei != 1; print(",") end
  print("$e")
 end
 print("]")
end

function print_set(set)
 print("[")
 for e in set
  print("$e ")
 end
 print("]")
end

function print_coreinfo(core)
 println("core info...")
 
 ci = analyze_sym(core)
 print("vars     = #$(length(ci.vsyms)):"); print_set(ci.vsyms);println()
 print("consts   = #$(length(ci.csyms)):"); print_set(ci.csyms);println()
 print("funcs    = #$(length(ci.fsyms)):"); print_set(ci.fsyms);println()
 print("preds    = #$(length(ci.psyms)):"); print_set(ci.psyms);println()  
 print("clauses  = #$(length(keys(core.cdb))):"); print_list(collect(keys(core.cdb)));println()
 print("literals = #$(length(keys(core.ldb))):"); print_list(collect(keys(core.ldb)));println()
 
end

#### DYNAMIC Analysis

function printtracestep(vars, step)
  print("$(step.rid):<$(step.leftp):$(step.rightp)>=")
  printvars(step.sigma)
  print(" : ")
  printvars(step.rename[1])

  print("<-")
  printvars(step.rename[2])
end

function printprooftrace(rid, vars, proof)

 for rid in sort(collect(keys(proof)))
   step = proof[rid]
   printtracestep(vars, step)
   println()
 end
end


function printtrace(rid, vars, core)
 println("trace...$rid with $vars")
 step = core.proof[rid]
 printprooftrace(vars, core.proof)
end

function printatrace1(rid, vars, core)
  if rid in keys(core.proof)
    step = core.proof[rid]
    vars = printatrace1(cidof(step.leftp,core), vars, core)
    vars = printatrace1(cidof(step.rightp,core), vars, core)
    println();println("----")
    print("<$(step.leftp):")
    println("$(step.rightp)>")
    print("   unify:")
    print_termlist(ovarsof(step.leftp, step.rightp, core))
    print("←")
    print_termlist(step.sigma)
    println()
    vars = apply(ovarsof(step.leftp, step.rightp, core), vars, step.sigma)
    print("    VARS: "); print_termlist(vars); println()
    print("   rename:")
    print_termlist(step.rename[1])
    print("⇦")
    print_termlist(step.rename[2])
    println()
    vars = apply(step.rename[1], vars, step.rename[2])
    print("    VARS: "); print_termlist(vars);println()
    printclause(rid, core)
    println();println("----")
  else
    println()
    printclause(rid, core)
  end
  println()
  print("    VARS: ");print_termlist(vars)
  return vars
end

function traceofaproof(rid, vars, core)
  if rid in keys(core.proof)
    step = core.proof[rid]
    vars = traceofaproof(cidof(step.leftp,core), vars, core)
    vars = traceofaproof(cidof(step.rightp,core), vars, core)
    # print("<$(step.leftp):")
    # println("$(step.rightp)>")
    vars = apply(ovarsof(step.leftp, step.rightp, core), vars, step.sigma)
    vars = apply(step.rename[1], vars, step.rename[2])
  end
  return vars
end

function getBigvars(ci)
 bvars = []
 for x in ci.vsyms
  iscap(x) && push!(bvars, x)
 end 
 bvars
end

function getVARS(core)
 ci = analyze_sym(core)
 getBigvars(ci)
end

function traceof(core)
  #vars = varsof(:C1, core)
  vars = getVARS(core)
  infos = []
  for rid in contradictionsof(core)
    inf = traceofaproof(rid, vars, core)
#    println("$vars = $inf")
    push!(infos, [rid, inf])
  end
  [vars, infos]
end

