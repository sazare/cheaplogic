# chase goal with view

function evalation(glid, core)
# glidがfalseになったらそのglidをgoalから消したい・・・そうはなっていない
 glit  = literalof(glid, core)
 val = leval(glit)
 if val == true
  println("Valid")
  return :VALID
 else # val == false
  return true
 end 
 return false
end

function go_resolution(glid, core)
 nlid = applytemp(glid, core) ## ???なに??
end

function askyou(glid, core)
 (sign, psym) = psymof(glid, core)

 (λc, clit) = core.cano[psym]
  λg, glit = lvarsof(glid, core), literalof(glid, core)

 σi = unify(λc, clit, glit)
 viewi = makeView(clit, σi0)
### your input s

# => λc, carray
 σo = unify(λc, clit, vargs)
 iσ = inverse(σi)
 λσ = fitting_vars(λg, iσ)
 σ = apply(λσ, iσ, σo)
  
 newgoal = apply(λgc, goal-glit, σ)
 core = putgoal(newgoal, core) 
 core
end



function refute_goal(gid,core)
 gclause = clause2of(gid,core)

 ovars = vars = goal.vars
# is same as  ovars = vars = varsof(glid, core)

 glits = goal.body
 glids = lidsof(gid, core)
# the order of glits and glids should be correspond
# i.e. glids[ix] = glits[ix].lid  for all ix
# This properties may be distructed in the following course...??
# if the evaluation failed, the tempolally generated rid is abandoned???

 glix  = 1
 glid  = glids[glix]
 glit  = glits[glix]
 remids1 = glid

 try
   core.trycnt[1] += 1
   remids = remids1 = setdiff(remids1, [glid])

# rename rlid
# 6/8 this action make the resolvent seems too hurry?
   rid =  newrid(core)
   nrem = rename_lids(rid, rem, core)
   nbody = literalsof(rem, core)
   nbody1 = apply(ovars, nbody, σo)

   if evalon
     rb = evaluate_literals(nrem, nbody1)
     if rb[1] == true
       println("Valid")
       return :FAIL
     end
     nrem, nbody1 = rb
   end

   vars = fitting_vars(ovars, nbody1, core)
   body = rename_clause(rid, vars, nbody1)

 rename_subst = [vars, body.vars]

## settlement

 core.succnt[1] += 1

# cdb[rid] to vars
  core.cdb[rid] = VForm2(rid, body.vars)

# clmap[rid] to rlid* = nrem
  core.clmap[rid] = nrem

# ldb[rlid] to full

  for i in 1:length(nrem)
    core.ldb[nrem[i]] = LForm2(nrem[i], body.body[i])
  end

# lcmap[rlid] to rid
  for rlid in nrem
    core.lcmap[rlid] = rid
  end
#  core.proof[rid] = STEP(rid, glid, :view, σo, rename_subst)
  rcf2=CForm2(rid, body.vars, body.body)
#  return rcf2
  return rid, core

  catch e
    println("FAIL = $e")
    return :FAIL
  end
end

