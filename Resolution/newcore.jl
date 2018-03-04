# new Core

include("dvcreso.jl") # for eename_clause() means a cycle dependency happend

# clause format
# parse("[x,y].[+P(x,f(x),-Q(x,y)]")
# as readclausesfromfile()

struct CForm2
 cid
 vars
 body
end

struct VForm2
 cid
 vars
end

struct LForm2
 lid
 body
end

struct STEPC
 rid
 leftp
 rightp
end

struct STEP
 rid
 leftp
 rightp
 sigma
end

struct CORE
 maxcid
 maxrid
 ldb
 cdb
 clmap
 lcmap
 allpsym
 level0
 proof
end

function stringtoclause(cid, cls)
 vars = cls.args[1].args
 body = cls.args[2].args[1].args
 rcls = rename_clause(cid, vars, body)
 return CForm2(cid, rcls.vars, rcls.body)
end

function cform2ofclause(clss, initn=1)
 nclss=Dict()
 maxcid = cidof(1+initn-1)
 for cno in 1:length(clss)
  cid = cidof(cno+initn-1)
  maxcid = cid
  nclss[cid] = stringtoclause(cid, clss[cno])
 end
 (maxcid, nclss)
end

function numberingliterals(ncls, lno0, ldb, lcmap, clmap, allpsym)
 cid = ncls.cid
 lids = []
 nlno0=0
 for lno in 1:length(ncls.body)
  cls=ncls.body[lno]
  lit = ncls.body[lno]
  lno = lno+lno0-1 
  nlno0 = lno+1
  lid = lidof(lno)
  lcmap[lid] = cid
  push!(allpsym, lit.args[2].args[1])
  push!(lids, lid) 
  ldb[lid] = LForm2(lid, lit)
 end
 clmap[cid] = lids

 return nlno0, ldb, lcmap, clmap, allpsym
end

function createLDB(clss)
 ldb = Dict()
 lno = 1
 ltoc = Dict()
 ctol = Dict()
 allpsym = Set()
 for ncid in keys(clss)
  ncls=clss[ncid]
  lno, ldb, ltoc, ctol, allpsym = numberingliterals(ncls, lno, ldb, ltoc, ctol, allpsym)
 end 
 return ldb, ltoc, ctol, allpsym
end

function vform2ofclause(cdb)
 vcl=Dict()
 for cid in keys(cdb)
   vcl[cid] = VForm2(cid, cdb[cid].vars)
 end
 vcl
end

function createcore(clss)
 (maxcid, cdb) = cform2ofclause(clss)
 ldb, lcmap, clmap, allpsym =createLDB(cdb)
 cvdb = vform2ofclause(cdb)
 graph= Dict()
 CORE([numof(maxcid)], [0], ldb, cvdb, clmap, lcmap, sort(collect(allpsym)), graph, Dict())
end

# proof operation
stepof(rid, core) = core.proof[rid]

function proofcof(rid, core)
 proof = []
 rids  = [rid]

 while !isempty(rids)
  rid = pop!(rids)

  if isrid(rid)
    astep=stepof(rid, core)
    push!(rids, cidof(astep.leftp, core))
    push!(rids, cidof(astep.rightp, core))
    push!(proof, STEPC(rid, cidof(astep.leftp, core), cidof(astep.rightp, core)))
  else
    continue
  end
 end
 proof
end

#core operation

cidof(num::Int) = Symbol(:C, num)
lidof(num::Int) = Symbol(:L, num)
ridof(num::Int) = Symbol(:R, num)

function newlid(xid, lid)
  Symbol(lid,xid)
end


function newrid(core) 
 core.maxrid[1] += 1 
 ridof(core.maxrid[1])
end

function origof(xid)
 pix = search(string(xid), SEPSYM)

 pix == 0 && return xid
 return Symbol(string(xid)[1:(search(string(xid),'_')-1)])
end

numof(xid) = parse(string(xid)[2:end])

function varsof(cid, core)
 core.cdb[cid].vars
end

function bodyof(cid, core)
 clmap=core.clmap[cid]
 body = []
 for lid in core.clmap[cid]
  push!(body, core.ldb[lid].body)
 end
 body
end


function clause2of(cid, core)
 CForm2(cid, varsof(cid, core), bodyof(cid, core))
end

function lidsof(cid, core)
 core.clmap[cid]
end

function cidof(lid, core)
 core.lcmap[lid]
end

function literalof(lid, core)
 core.ldb[lid]
end

function literalsof(lids, core)
 map(lid->literalof(lid, core).body, lids)
end

#### resolvent
## proof information in resolvent 

struct RForm2
 rid
 vars
 left
 right
 sigma
 body
end


### new resolution
function resolution(lid1, lid2, core)
@show "insufficient yet"
# clause c1,c2 is an array.

# is it ok? no
 vars = vcat(varsof(cidof(lid1, core), core), varsof(cidof(lid2, core), core))
 lit1 = literalof(lid1,core)
 lit2 = literalof(lid2,core)

 if lit1.args[1] == lit2.args[1]; return :NAP end 
 lit1.args[1] = lit2.args[1]  # temporarily let signs same

 try 
  sigma = unify(vars, lit1.args[2], lit2.args[2])
  r1 = vcat(setdiff(lidsof(cidof(lid1, core),core), [lid1]),
            setdiff(lidsof(cidof(lid2, core),core),[lid2]))
## ? apply vars sigma??
  return r1,vars,sigma
 catch e
  if isa(e, Loop)
   return :FAIL
  end 
 end 
 return :NAP
end

