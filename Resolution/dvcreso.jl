# post-rename DVC version

include("misc.jl")
include("primitives.jl")

# variable manipulation

const SEPSYM='_'

issym(x) = typeof(x)==Symbol
iscid(x) = issym(x) && string(x)[1] == 'C'
isrid(x) = issym(x) && string(x)[1] == 'R'
hasid(x) = search(string(x), SEPSYM) != 0

function newvar(xid, var) 
 if hasid(var)
   return Symbol(var, xid)
 else
   return Symbol(var, SEPSYM, xid)
 end
end

function newvarlist(xid, varlist)
 map(var->newvar(xid, var), varlist)
end

# Resolvent
function rename_term(xid, vars, term::Term)
  if issym(term)
    if isvar(term, vars)
      return newvar(xid, term)
    else
      return term 
    end
  else
    params = term.args
    nterm = deepcopy(term)
    nterm.args = map(param->rename_term(xid, vars, param),params)
    return nterm
  end
end

function rename_clause(xid, vars, body)
 CForm2(xid, newvarlist(xid, vars), map(lit->rename_term(xid, vars, lit), body))
end

function entrylit(rid, nlid, lid, core)
  olit = literalof(lid, core).body
  ovars = varsof(cidof(lid,core),core)
  nlit=LForm2(nlid, rename_term(rid, ovars, olit))
  core.ldb[nlid] = nlit
end

function rename_lid(rid, lid, core)
  Symbol(origof(lid), SEPSYM, rid)
end

function rename_lids(rid, lids, core)
 nlids=[]
 for lid in lids
  nlid=rename_lid(rid, lid, core)
  entrylit(rid, nlid, lid, core)
  push!(nlids, nlid)
 end
 return nlids
end

#fitting vars in literal
function fitting_vars_term(vars, term)
  if typeof(term) == Symbol
    if term in vars
      return [term]
    else
      return []
    end
  else
    return fitting_vars_args(vars, term.args[2:end])
  end
end

function fitting_vars_args(vars, args)
  nvars=[]
  for term in args
    append!(nvars, fitting_vars_term(vars, term))
  end
  union(nvars, nvars)
end

function fitting_vars_lit(vars, lit)
  fitting_vars_term(vars, lit.args[2])
end

function fitting_vars(vars, lids, core)
 evars = []
 for lid in lids
   append!(evars, fitting_vars_lit(vars, literalof(lid, core).body))
 end
 union(evars, evars)
end

## resolution
ovarsof(l1,l2,core)=vcat(varsof(cidof(l1, core), core), varsof(cidof(l2, core), core))

function dvc_resolution(l1,l2,core)
 vars1 = varsof(cidof(l1, core), core)
 vars2 = varsof(cidof(l2, core), core)
 lit1  = literalof(l1, core).body
 lit2  = literalof(l2, core).body
 ovars = vcat(vars1,vars2)
 (sign1, psym1) = psymof(l1, core)
 (sign2, psym2) = psymof(l2, core)

 if sign1 == sign2; return :FAIL end
 if psym1 != psym2; return :FAIL end
 try 
   sigmai = unify(ovars, lit1.args[2], lit2.args[2])

   rid =  newrid(core)

   rem1 = lidsof(cidof(l1, core),core)
   rem1 = setdiff(rem1, [l1])
   rem2 = lidsof(cidof(l2, core),core)
   rem2 = setdiff(rem2, [l2])

   rem = vcat(rem1, rem2)

   vars = fitting_vars(ovars, rem, core)
 
# rename rlid
   nrem = rename_lids(rid, rem, core)
   nbody = literalsof(rem, core)
   nbody1 = apply(ovars, nbody, sigmai)
   body = rename_clause(rid, vars, nbody1)
 ## settlement

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
  core.proof[rid] = STEP(rid, l1, l2, sigmai)
  return CForm2(rid, body.vars, body.body)
  catch e 
    println("FAIL = $e")
    return :FAIL
  end
end



## Template
function psymof(lid, core)
 lit = literalof(lid, core).body
 (lit.args[1], lit.args[2].args[1])
end

lsym(sign, psym) = Symbol(sign, psym)

function lsymof(lid, core)
 psym = psymof(lid, core)
 string(psym[1],psym[2])
end

inverseof(sign) = if sign == :- ; :+ else :- end

function litis(sign, psym, lid, core)
 (osign, opsym) = psymof(lid, core)
 return osign == inverseof(sign) && opsym == psym
end

function oppositof(sign, psym, core)
 rems = []

 for olid in keys(core.ldb)
  lfm2 = core.ldb[olid]
  if litis(sign, psym, olid, core) 
    push!(rems, olid)
  end
 end
 rems
 
end

function templateof(sign, psym, core)
 eqs = Dict()
 oppos = oppositof(sign, psym, core)
 body = []
 for lid in oppos
  cid = cidof(lid, core)
  lids = lidsof(cid, core)
  rem = setdiff(lids, [lid])
  push!(body, [cid, varsof(cid, core), lid, rem])
 end
 core.level0[lsym(sign, psym)]= body
end

function alltemplateof(core)
 allpsym = core.allpsym 
 alltemp = []
 for psym in allpsym
   push!(alltemp, templateof(:+, psym, core))
   push!(alltemp, templateof(:-, psym, core))
 end
 core.level0
end

## apply template to lid
function applytemp(lid, core)
 (sign, psym) = psymof(lid, core)
 templs = templateof(sign, psym, core)
 rids = []
 for templ in templs
   reso = dvc_resolution(lid, templ[3], core)  
   if typeof(reso) == CForm2
     if isrepeatproof(reso.cid,core)
println(":isrepeatproof $(reso.cid)")
        continue
      end
     push!(rids, reso.cid)
 #    println(reso)
   else
     continue
   end
 end
 map(rid->lidsof(rid, core),rids)
end

### step forward on template

function prod(tmpl1, tmpl2)
  newtmpl = []
  for t1 in tmpl1
  for t2 in tmpl2
    push!(newtmpl, vcat(t1, t2))
  end
  end
  newtmpl
end

function prodm(tmpls)
 mtempl=tmpls[1]
 for rtmpl in tmpls[2:end]
  mtempl=prod(mtempl, rtmpl)
 end
 return mtempl
end

function rotate(lids, i=0)
 i >= length(lids) && error("required: 0<=$i<length($lids)")
 if i == 0 
   lids
 else
   vcat(lids[i+1:end], lids[1:i])
 end
end

"""
 goal = [L1,L2,...]
"""
function dostepagoal(goal, core)
 newlids = []
 for lid in goal
   nlids = applytemp(lid, core)
   append!(newlids, nlids)
 end
 newlids
end

"""
 goals = [[L1,L2,...],...]
"""
function dostep1goals(goals, core)
 nextg = []
 for g in goals
  ngs = dostepagoal(g, core)
  append!(nextg, ngs)
 end
println("$goals => $nextg")
 nextg
end

"""
 goal = [L1,L2,...]
"""
function dostepagoal1(goal, core)
 nlids = []
 if isempty(goal); return [] end
 for shift in 0:length(goal)-1
  wgoal = rotate(goal,shift)
  lid = wgoal[1]
  nlids = applytemp(lid, core)
  if !isempty(nlids); break end
 end
 if isempty(nlids); return :FAIL end
 return nlids
end

"""
 goals = [[L1,L2,...],...]
"""
function dostepgoals1(goals, core)
 nextg = []
 for g in goals
  ngs = dostepagoal1(g, core)
  if ngs == :FAIL; continue end
  append!(nextg, ngs)
 end
println("$goals => $nextg")
 nextg
end

"""
 find the resolvents of body empty
"""
function contradictionsof(core)
 conds=[]
 for cid in keys(core.cdb)
   if length(lidsof(cid, core)) == 0
     push!(conds, cid)
   end
 end
 conds
end

function pairwiseeq(d1,d2)
 all(map((x,y)->origof(x)==origof(y),d1,d2))
end

# proof should be an array of pair(Lid)
function findrepeat(proof)
 for i in 1:(length(proof)-1)
  for j in (i+1):length(proof)
   if pairwiseeq(proof[i], proof[j])
     println("$(proof[i]) is upon is repeated")
     return true
   end
  end
 end
 return false
end

isresolvent(cid) = isrid(cid)

function proofstep(cid, core)
  step = core.proof[cid]
  return [step.leftp, step.rightp]
end

function prooftree(cid, core)
  if !isresolvent(cid);return [] end

  step = core.proof[cid]
  lefttree  = prooftree(cidof(step.leftp,core), core)
  righttree = prooftree(cidof(step.rightp,core), core)

  parenttree = []
  !isempty(lefttree) && append!(parenttree, lefttree)
  !isempty(righttree) && append!(parenttree, righttree)
  append!(parenttree, [proofstep(cid, core)])
  return parenttree
end

function isrepeatproof(cid, core)
  aproof = prooftree(cid, core)
  findrepeat(aproof) 
end


### prover
"""
simple prover find some contracictions, but not all
"""
function simpleprover(wff, steplimit, contralimit)
 cdx=readcore(wff)
 tdx=alltemplateof(cdx)
 gb=[lidsof(:C1, cdx)]
 conds = []
 nstep = 0;
 
 while true 
  ga=dostepgoals1(gb, cdx)
  nstep += 1
  conds = contradictionsof(cdx)
 # if !isempty(conds); break end
  if length(conds) >= contralimit;break end
  if nstep >= steplimit;break end
  gb = ga
 end
 return conds,cdx
end

