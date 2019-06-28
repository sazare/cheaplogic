
function factify_clause(glid,σo,core)
@show :factify_clause glid σo
 ovars = vars = varsof(cidof(glid, core), core)

 glit  = literalof(glid, core).body

@show glit
 try
   core.trycnt[1] += 1
   rem1 = lidsof(cidof(glid, core),core)
   rem = rem1 = setdiff(rem1, [glid])

# rename rlid rem

   rid =  newrid(core)
   nrem = rename_lids(rid, rem, core)
   nbody = literalsof(rem, core)
   nbody1 = apply(ovars, nbody, σo)
@show nbody nbody1
   if evalon
@show :evalon
     rb = evaluate_literals(nrem, nbody1)
     if rb[1] == true
       println("Valid")
       return :FAIL
     end
     nrem, nbody1 = rb
@show nrem nbody1
   end

   vars = fitting_vars(ovars, nbody1, core)
@show vars
   body = rename_clause(rid, vars, nbody1)
@show body

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

