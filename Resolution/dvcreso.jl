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
#@show rid
#@show lids
 nlids=[]
 for lid in lids
  nlid=rename_lid(rid, lid, core)
  entrylit(rid, nlid, lid, core)
  push!(nlids, nlid)
 end
#@show nlids
 return nlids
end

## resolution
function dvc_resolution(l1,l2,core)
 vars1 = varsof(cidof(l1, core), core)
 vars2 = varsof(cidof(l2, core), core)
 lit1  = literalof(l1, core).body
 lit2  = literalof(l2, core).body
 ovars = vcat(vars1,vars2)
 (sign1, psym1) = psymof(l1, core)
 (sign2, psym2) = psymof(l2, core)

#@show psym1, psym2
#@show sign1, sign2
 if sign1 == sign2; return :FAIL end
 if psym1 != psym2; return :FAIL end
 try 
   sigmai = unify(ovars, lit1, lit2)
#@show ovars
#@show sigmai

   rid =  newrid(core)

   rem1 = lidsof(cidof(l1, core),core)
   rem1 = setdiff(rem1, [l1])
   rem2 = lidsof(cidof(l2, core),core)
   rem2 = setdiff(rem2, [l2])
   vars = intersect(ovars, sigmai)

#   vars = newvarlist(rid, vars)
#@show vars
   
# rename rlid
#@show rem1
#@show rem2
   rem = vcat(rem1, rem2)
#@show rem
   nrem = rename_lids(rid, rem, core)
#@show nrem
   nbody = literalsof(rem, core)
#@show nbody
   body = rename_clause(rid, vars, nbody)
#@show body
 ## settlement

# cdb[rid] to vars
  core.cdb[rid] = VForm2(rid, body.vars)

# clmap[rid] to rlid* = nrem
 
  core.clmap[rid] = nrem

# ldb[rlid] to full
 
  for i in 1:length(nrem)
#@show nrem[i]
#@show body.body[i]
    core.ldb[nrem[i]] = LForm2(nrem[i], body.body[i])
  end

# lcmap[rlid] to rid
#@show nrem
  for rlid in nrem
    core.lcmap[rlid] = rid
  end
  core.proof[rid] = STEP(rid, l1, l2, sigmai)
  return CForm2(rid, body.vars, body.body)
  catch e 
    return e
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

function applytemp(lid, core)
 (sign, psym) = psymof(lid, core)
 templs = templateof(sign, psym, core)
 rids = []
 for templ in templs
   reso = dvc_resolution(lid, templ[3], core)  
   if typeof(reso) == CForm2
     push!(rids, reso.cid)
     println(reso)
   else
     eontinue
   end
 end
 rids
end

