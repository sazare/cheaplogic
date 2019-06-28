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

"""
 add literals to core as an clause
"""
function addnewclause(vars, cid, lids, core, σo=[])
# rename rlid
  rid =  newrid(core)
  vars = varsof(cid, core)
  nrem = rename_lids(rid, lids, core)
  nbody = literalsof(lids, core)

# this apply is need for just view, not evaluategoal
  if σo != []; nbody = apply(vars, nbody, σo) end

  vars = fitting_vars(vars, nbody, core)
  
  body = rename_clause(rid, vars, nbody)
#  rename_subst = [vars, body.vars]

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
@show :addstep, rid, l1, l2, σ, ρ
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
@show :evaluategoal
 gids = lidsof(gid, core)
 vars = varsof(gid, core)
 rgids= []
 glid0 = :no
@show glid0
 for glid in gids
  lit = literalof(glid, core)
  if isProc(lit)
   val = leval(lit.body) 
   if val == true; throw(VALID(glid, :evaluategoal)) end
   if val == false
    glid0 = glid
@show glid0
    continue 
   end
   push!(rgids, glid) #not true or false
  end 
 end 
 if glid0 == :no
# no evaluatable literal
@show glid0
   return gid, core
 end
@show :removeevaluatable gid core
 rid = addnewclause(vars, gid, rgids, core)
 ncore = addstep(core, gid, glid0, glid0, [], [], :eval)

 return rid,ncore
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

function canoof(lid, core)
 core.cano[psymof(lid,core)[2]]
end

function canovarsof(lid, core)
 canoof(lid, core)[1]
end

function canolitof(sign, lid, core)
 Expr(:call, sign, canoof(lid, core)[2])
end

function incount(glid, core)
 try
  glit  = literalof(glid, core).body
  gargs = glit.args[2].args[2:end]
  gvars = cvarsof(glid, core)
  cavars= canovarsof(glid, core)
 
  cin = 0
  for ix in 1:length(cavars)
   if isvar(gargs[ix],gvars)
     if isinvar(cavars[ix])
       cin += 1 
     end
   end
  end
  return cin
 catch e
  return Inf
 end
end

"""
chooselid() chooses a literal in Cano.
should be called after evaluate
doesnt choose a lit not Proc and not Cano
"""
function chooselid(gid, core)
@show chooselid gid
 lids = lidsof(gid, core)
@show lids
 ninvec = []
 for lid in lids
@show lid
   if isCano(literalof(lid,core),core)
@show :iscano
    nin = incount(lid, core)
    nin == 0 && return(lid)
    push!(ninvec, nin)
   else
@show :nocano
    push!(ninvec, Inf)
   end
 end
 v,ix = findmin(ninvec)
@show v ix
 if v != Inf
  return lids[ix]
 else
  return nothing
 end
end

#==
 the caller choose the lid by chooselid()
 open view and get intpus from You.
 and get σo from the view
 apply σo to goal-glid make new goal
 add it to core
==#

function askU(gid, core, op)
@show :askU
 global glid=chooselid(gid,core)
 if glid == nothing ; return nothing end
@show glid
 global gvar=varsof(gid,core)
@show gvar
 gatm=literalof(glid,core).body.args[2]
 varc=canovarsof(glid,core)
 vatm=canoof(glid,core)[2]
 σi = unify(varc, vatm, gatm)
@show σi

# example
# vatm=[X,Y].P(X,Y), gatm=[y].P(a,y)
# σi=[a,y] 
# [X,Y].<[X,Y]:[a,y]> = [a,y] = [X,Y].[a,y] is an extension of gvar [y]
# make a view with ([X,Y], [y], [a,y]) [y] determins var in [a,y]

##
# in this step, a web transition exists
 return makeView2(op, glid, varc, gvar, σi)
##
end


# after part of askU
function listenU(params)
 σo = getσo(varc, gvar, params)

# confirm makes σo like as [X,Y].[a,b]
# [y].<[a,y]:[a,b]> = [b] = the restriction to [y] of [a,b]=σo
# gvar = [y], σi = [a,y]
# [y].<[a,y]:[a,b]> = [b] namely [y].[b] this is  σo1 
# σo1 is also be written as [y].[y]:[b]
# σo1 is the mgu for goal's remain body.

 σo1 = unify(gvar, σi, σo)

 glids = lidsof(gid, core)
 remids = setdiff(glids, glid)
  
#
 newgid=addnewclause(gvar, gid, remids, core, σo1)
 return newgid
end

function go_resolution(glid, core)
 nlid = applytemp(glid, core) ## ???なに??
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

# rename_subst = [vars, body.vars]

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

