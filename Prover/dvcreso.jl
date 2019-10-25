# post-rename DVC version

#include("misc.jl")
#include("primitives.jl")

# variable manipulation

issym(x) = isa(x, Symbol) || isa(x, Number) || isa(x, String) || isa(x, Char)

include("common.jl")

function rename_clause(xid, vars, body)
 CForm2(xid, newvarlist(xid, vars), map(lit->rename_term(xid, vars, lit), body))
end

function entrylit(rid, nlid, lid, core)
  olit = literalof(lid, core).body
  ovars = varsof(cidof(lid,core),core)
# may this be not right? where I should deepcopy??
#  olit2 = deepcopy(olit)
#  nlit=LForm2(nlid, rename_term(rid, ovars, olit2))
#
  nlit=LForm2(nlid, rename_term(rid, ovars, olit))
  core.ldb[nlid] = nlit
end

function rename_clause(xid, vars, body)
 CForm2(xid, newvarlist(xid, vars), map(lit->rename_term(xid, vars, lit), body))
end

function entrylit(rid, nlid, lid, core)
  olit = literalof(lid, core).body
  ovars = varsof(cidof(lid,core),core)
# may this be not right? where I should deepcopy??
#  olit2 = deepcopy(olit)
#  nlit=LForm2(nlid, rename_term(rid, ovars, olit2))
#
  nlit=LForm2(nlid, rename_term(rid, ovars, olit))
  core.ldb[nlid] = nlit
end

function fitting_vars(vars, lits, core)
 evars = []
 for lit in lits
   append!(evars, fitting_vars_lit(vars, lit))
 end
 nvars=union(evars, evars)
 return nvars
end

ovarsof(l1,core)=vcat(varsof(cidof(l1, core), core))

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
 if length(lit1.args[2].args) != length(lit2.args[2].args); return :FAIL end

 try 
   core.trycnt[1] += 1
   sigmai = unify(ovars, lit1.args[2], lit2.args[2])
   rem1 = lidsof(cidof(l1, core),core)
   rem1 = setdiff(rem1, [l1])
   rem2 = lidsof(cidof(l2, core),core)
   rem2 = setdiff(rem2, [l2])

   rem = vcat(rem1, rem2)
   vars = ovars

# rename rlid
   rid =  newrid(core)
   nrem = rename_lids(rid, rem, core)
   nbody = literalsof(rem, core)
   nbody1 = apply(ovars, nbody, sigmai)
   if evalon
     rb = evaluate_literals(nrem, nbody1) 
     if rb[1] == true
       println("Valid:") # I want to show what is valid.
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
  core.proof[rid] = STEP(rid, l1, l2, sigmai, rename_subst, :reso)
  rcf2=CForm2(rid, body.vars, body.body)
  return rcf2

  catch e 
    println("FAIL = $e")
    return :FAIL
  end
end

function psymof(lid, core)
 lit = literalof(lid, core).body
 (lit.args[1], lit.args[2].args[1])
end

function atomof(lid, core)
 lit = literalof(lid, core).body
 lit.args[2]
end

## apply template to lid
function applytemp(lid, core)
 (sign, psym) = psymof(lid, core)
 templs = templateof(sign, psym, core)
 rids = []
 for templ in templs
   reso = dvc_resolution(lid, templ[3], core)
   if isa(reso, CForm2)
     push!(rids, reso.cid)
   else
     continue
   end
 end
# devlog20190606 Q
 map(rid->lidsof(rid, core),rids)
end

### prover
"""
simple prover find some contracictions, but not all
"""
function simpleprovercore(cdx, steplimit, contralimit, reslimit)
 tdx=alltemplateof(cdx)
 gb=[lidsof(:C1, cdx)]
 conds = []
 nstep = 0;

 evalon && evalproc(cdx.proc)

 while true
  ga=dostepgoals1(gb, cdx)
  nstep += 1
  conds = contradictionsof(cdx)
 # if !isempty(conds); break end
  if length(cdx.proof) >= reslimit; break end
  if length(conds) >= contralimit;break end
  if nstep >= steplimit;break end
  gb = ga
 end
 return conds,cdx
end

function simpleprover(cnf, steplimit, contralimit, reslimit=100)
 cdx=readcore(cnf)
 simpleprovercore(cdx, steplimit, contralimit, reslimit)
end

