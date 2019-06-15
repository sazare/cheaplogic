# chase goal with view


"""
isProc(lit) = lit is a Proc literal
namely, lit is evalable.
proc is a string of form "sym(...) = def" in cnf file
"""
function isProc(lit::LForm2)
 lsym = lit.body.args[2].args[1]
 try
  return isa(eval(lsym), Function)
 catch e
  return false
 end
end

#
"""
 add literals to core as an clause
"""
function addnewclause(vars, cid, lids, core)
# rename rlid
  rid =  newrid(core)
  vars = varsof(cid, core)
  nrem = rename_lids(rid, lids, core)
  nbody = literalsof(lids, core)
  vars = fitting_vars(vars, nbody, core)
  
  body = rename_clause(rid, vars, nbody)
  rename_subst = [vars, body.vars]

 ## settlement
  core.succnt[1] += 1
  core.cdb[rid] = VForm2(rid, body.vars)
  core.clmap[rid] = nrem
# ldb[rlid] to full
  for i in 1:length(nrem)
    core.ldb[nrem[i]] = LForm2(nrem[i], body.body[i])
  end

# lcmap[rlid] to rid
  for rlid in nrem
    core.lcmap[rlid] = rid
  end

  rcf2=CForm2(rid, body.vars, body.body)
#  return rcf2
  return rid
#  return core
end

function addstep(core, rid, l1, l2, σ, ρ, rule)
  core.proof[rid] = STEP(rid, l1, l2, σ, ρ)
  core
end

# goal is an array of literals
"""
evaluategoal eval all literals of goal(gid)
 if it is false, remove it.
 if it is true, valid and abort.
 otherwise nothing happen

 this function is destructive on core
 so, can't use in parallel prover in multithreads
"""
function evaluategoal(gid, core)
 gids = lidsof(gid, core)
 vars = varsof(gid, core)
 rgids= []

 for glid in gids
  lit = literalof(glid, core)

  if isProc(lit)
   val = leval(lit) 
   if val == true; throw(VALID(glid, :evaluategoal)) end
   if val == false; continue end
   push!(rgids, lid) #not true or false
  end 
 end 

 rid = addnewclause(vars, gid, rgids, core)
 ncore = addstep(core, rid, :eval, :eval, [], [], :eval)

 return ncore
end

"""
isCano(lit) == lit is a Canonical literal
&[P(X,Y)] as X is caplital and no vars and no sign
after readcore, cano is a Dict, psym => (vars, atom)
vars is created by readcore
atom is a literal without sign
"""
function isCano(lit::LForm2, core)
 lit.body.args[2].args[1] in keys(core.cano)
end

function choose(vars, goal, cano, core)

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

