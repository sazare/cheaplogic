
function factify_clause(glid,σg,core)
@info :factify_clause glid σg
@info cidof(glid, core)
 ovars = vars = varsof(cidof(glid, core), core)
@info ovars
 glit  = literalof(glid, core).body

@info glit
 try
   core.trycnt[1] += 1
   rem1 = lidsof(cidof(glid, core),core)
@info rem1
   rem = rem1 = setdiff(rem1, [glid])
@info rem
# rename rlid rem

   rid =  newrid(core)
   nrem = rename_lids(rid, rem, core)
@info nrem
   nbody = literalsof(rem, core)
@info nbody
   σs = apply(varg, ovars, σg)
   nbody1 = apply(ovars, nbody, σs)
@info nbody1
   if evalon
@info :evalon
     rb = evaluate_literals(nrem, nbody1)
     if rb[1] == true
       println("Valid")
       return :FAIL
     end
     nrem, nbody1 = rb
@info nrem nbody1
   end
@info ovars nbody1
   vars = fitting_vars(ovars, nbody1, core)
@info vars
   body = rename_clause(rid, vars, nbody1)
@info body

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
#  core.proof[rid] = STEP(rid, glid, :view, σg||σo?, rename_subst, :factify)
  rcf2=CForm2(rid, body.vars, body.body)
#  return rcf2
  return rid, core

  catch e
    println("FAIL = $e")
    return :FAIL
  end
end

