#viewreso.jl has not direct to View

# I chase goal with view

"""
isProc(lit::LForm2) : lit is a Proc literal
namely, lit is evalable.
proc is a string of form "sym(...) = def" in cnf file
"""
function isProc(lit::LForm2)
 lsym = lit.body.args[2].args[1]
 try
  return isa(eval(lsym), Function)
 catch e
  return false
 end # try
end # isProc

"""
 add literals to core as an clause
 addnewclause(vars, cid, lids, core, σo=[])
"""
function addnewclause(vars, cid, lids, core, σo=[])
@info :addnewclause, vars,cid,lids,σo
# rename rlid
  rid =  newrid(core)
  vars = varsof(cid, core)
  nrem = rename_lids(rid, lids, core)
@show rid,vars,nrem
  nbody = literalsof(lids, core)
# this apply is need for just view
  if σo != []; nbody = apply(vars, nbody, σo) end
@show vars,nbody
  vars = fitting_vars(vars, nbody, core)
@show vars
  body = rename_clause(rid, vars, nbody)
  rename_subst = [vars, body.vars]
@show rename_subst

  ## settlement
  core.succnt[1] += 1
  core.cdb[rid] = VForm2(rid, body.vars)
  core.clmap[rid] = nrem

# ldb[rlid] to full
  for i in 1:length(nrem)
    core.ldb[nrem[i]] = LForm2(nrem[i], body.body[i])
  end # i

# lcmap[rlid] to rid
  for rlid in nrem
    core.lcmap[rlid] = rid
  end # rlid

  rcf2=CForm2(rid, body.vars, body.body)

  return rid, rename_subst
end # addnewclause

"""
addstep add a proof step to core
"""
function addstep(core, rid, l1, l2, σ, ρ, rule)
@info :addstep, rid, l1, l2, σ, ρ, rule
  core.proof[rid] = STEP(rid, l1, l2, σ, ρ, rule)
  core
end # addstep

# goal is an array of literals
"""
evaluategoal eval all literals of goal(gid)
 if it is false, remove it.
 if it is true, valid and abort.
 otherwise nothing happen

 this is destructive on core
 so, can't use in parallel prover in multithreads
"""
function evaluategoal(gid, core)
@info :evaluategoal
 gids = lidsof(gid, core)
 vars = varsof(gid, core)
 rlids= []
 removedevalaute = false
 for glid in gids
  lit = literalof(glid, core)
  if isProc(lit)
   val = leval(lit.body) 
   if val == true; throw(VALID(glid, :evaluategoal)) end
   if val == false
    removedevalaute = true
    rlids = [glid]
    break
   end # if val == false
  end # if isProc
 end # for glid

@info :afterforglid, gid, rlids
 if removedevalaute && !isempty(rlids)
  rgids = setdiff(gids, rlids)
@info :removetrue,vars,gid,rgids
  rid,renameσ = addnewclause(vars, gid, rgids, core)
@info rid
  ncore = addstep(core, rid, rlids[1], rlids[1], [], renameσ, :eval)
  gid = rid
 else #if removedvalueate
  ncore = core
 end #if removedvalueate
@info gid
 return gid,ncore
end # evaluategoal

"""
isCano(LForm2,core) : lit is a Canonical literal
&[P(X,Y)] as X is caplital and no vars and no sign
after readcore, cano is a Dict, psym => (vars, atom)
vars is created by readcore
atom is a literal without sign
"""
function isCano(lit::LForm2, core)
 lit.body.args[2].args[1] in keys(core.cano)
end # isCano

"""
canoof get a canonical form of lid
"""
function canoof(lid, core)
 core.cano[psymof(lid,core)[2]]
end # canoof

"""
canovarsof get the vars of canonical lid
"""
function canovarsof(lid, core)
 canoof(lid, core)[1]
end # canovarsof

"""
canolitof make a literal of canonical of lid
"""
function canolitof(sign, lid, core)
 Expr(:call, sign, canoof(lid, core)[2])
end # canolitof

"""
inclunt() counts input vars(as :vvv!)
the vars is identical the args of canonical literal
"""
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
     end # isinvar
   end # isvar
  end # ix
  return cin
 catch e
  return Inf
 end # try
end # incount


"""
 chooseresolvelid chooses a lid for resolve
 the lid should be not Proc, not Cano
"""
function chooseresolvelid(lids, core)
@info :chooseresolvelid
 nlit = []
 for lid in lids
  lit2 = literalof(lid,core)
  if !isProc(lit2) && !isCano(lit2, core)
# this choose one of lits, but it will be more complicate.
   return lid
  end # !isProc && !isCano
 end #for lid
@info :chooseresolvelid_nothing
 return nothing
end # chooseresolvelid

"""
choosecanoid() chooses a literal in Cano.
should be called after evaluate
doesnt choose a lit not Proc and not Cano
"""
function choosecanoid(gid, core)
@info :choosecanoid gid
 lids = lidsof(gid, core)
@info lids
 ninvec = []
 for lid in lids
@info lid
   if isCano(literalof(lid,core),core)
@info :iscano
    nin = incount(lid, core)
    nin == 0 && return(lid)
    push!(ninvec, nin)
   else
@info :nocano
    push!(ninvec, Inf)
   end # isCano
 end # for
 v,ix = findmin(ninvec)
@info v, ix
 if v != Inf
  return lids[ix]
 else # 
  return nothing
 end # v!=Inf
end # choosecanoid

"""
askU make a view of first part of the view of gid
the glid is choosed by choosecanoid
"""
function askU(gid, core, op)
@info :askU
 global glid=choosecanoid(gid,core)
 if glid == nothing ; return nothing end
@info glid
 global gvar=varsof(gid,core)
 gatm=literalof(glid,core).body.args[2]
@info gvar,gatm
 varc=canovarsof(glid,core)
 vatm=canoof(glid,core)[2]
@info varc, vatm
 σi = unify(varc, vatm, gatm)
@info σi

# example
# vatm=[X,Y].P(X,Y), gatm=[y].P(a,y)
# σi=[a,y] 
# [X,Y].<[X,Y]:[a,y]> = [a,y] = [X,Y].[a,y] is an extension of gvar [y]
# make a view with ([X,Y], [y], [a,y]) [y] determins var in [a,y]

##
# in this step, a web transition exists
 return makeView2(op, glid, varc, gvar, σi)
##
end # askU

"""
factify_clause makes glid fact
"""
function factify_clause(glid,σg,core)
@info :factify_clause, glid, σg
@info cidof(glid, core)
 cid = cidof(glid, core)
 ovars = vars = varsof(cid, core)
@info ovars
 glit  = literalof(glid, core).body

@info glit
 try
   core.trycnt[1] += 1
   rem1 = lidsof(cid,core)
@info rem1
   rem = rem1 = setdiff(rem1, [glid])
@info rem
@info :addnewclause,cid,glid,σg
  rid,renameσ = addnewclause(ovars,cid,rem1,core,σg) 
@info :addstep,rid,glid,σg,[],:view
@info :should_define_addstep
  core = addstep(core,rid,glid,glid,σg,[],:view)
  ncore = core
  gid, ncore = rid,core
  return rid, core
  catch e
    @info :what_this_exception
    println("factify_clause = $e")
    throw(e)
  end # try
end # fctify_clause


"""
resolvelid resolves glid with a opposit of it
"""
function resolvelid(glid, core)
@info :resolvelid
# get a literal
 glit = literalof(glid, core)
 gid  = cidof(glid, core)
 varsg = cvarsof(glid, core)
 atomg = atomof(glid, core)
 remg  = setdiff(lidsof(cidof(glid, core), core), [glid])
@info :after_setdiff_in_resolvelid
@show glit, varsg, atomg, remg
# maching for all opposit
 sign, psym = psymof(glid, core)
@show sign, psym
 oppos = oppositof(sign, psym, core)
 for olid in oppos
@show olid
# try unify them
# if sigma made, it should return
  ovars = cvarsof(olid, core)
  oatom = atomof(olid, core)
@show ovars, oatom
  ovars=vcat(varsg, ovars) 
@show ovars
  core.trycnt[1] += 1
@info :before_unify, ovars, atomg, oatom
  σ = unify(ovars, atomg, oatom)
@show σ,olid
  orem = lidsof(cidof(olid,core), core)
@info orem,remg, olid
  grem = setdiff(vcat(orem, remg), [olid])
@info grem
@info :addnewcore,ovars,gid,grem
  gid,renameσ = addnewclause(ovars,gid,grem,core)
  core = addstep(core,gid,glid,olid,σ,renameσ[2],:reso)
  ncore = core
  return gid, core
 end # for olid

end # resolvelid

