# new Core

include("dvcreso.jl") # for eename_clause() means a cycle dependency happend

# clause format
# Meta.parse("[x,y].[+P(x,f(x),-Q(x,y)]")
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
 rename
end

struct CORE
 name
 maxcid
 maxrid
 ldb
 cdb
 clmap
 lcmap
 allpsym
 level0
 proof
 proc
 trycnt
 succnt
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
  cls = stringtoclause(cid, clss[cno])
#  -F(x,y),-F(y,z),+F(x,z) is satisfiable... but not good to remove it.
#   so, may satisfible clause be removed or not ?
#  if satisfiable(cls.vars, cls.body); continue end
  nclss[cid] = cls
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

function createcore(name, clss, proc)
 (maxcid, cdb) = cform2ofclause(clss)
 ldb, lcmap, clmap, allpsym =createLDB(cdb)
 cvdb = vform2ofclause(cdb)
 graph= Dict()
 CORE(name, [numof(maxcid)], [0], ldb, cvdb, clmap, lcmap, sort(collect(allpsym)), graph, Dict(), proc, [0], [0])
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

iscid(sym) = ('C' == string(sym)[1])
isrid(sym) = ('R' == string(sym)[1])
islid(sym) = ('L' == string(sym)[1])

function newlid(xid, lid)
  Symbol(lid,xid)
end


function newrid(core) 
 core.maxrid[1] += 1 
 ridof(core.maxrid[1])
end

function origof(xid)
 pix = findfirst(isequal(SEPSYM), string(xid))
 pix == nothing && return xid
 ix = findfirst(isequal('_'), string(xid))
 ix == nothing && return xid
 return Symbol(string(xid)[1:(ix -1 )])
end

function origtermof(term)
 if isa(term, Symbol); return origof(term) end
 if isa(term, Expr)
  for aix in 2:length(term.args)
   term.args[aix] = origtermof(term.args[aix])
  end
 end
 term
end

numof(xid) = Meta.parse(string(xid)[2:end])

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

function evalproc(proc)
  for p in proc
    eval(Meta.parse(p))
  end
end

function evalcore(core)
  evalproc(core.proc)
end



#### analyzer of cnf
struct COREINFO
 vsyms
 csyms
 fsyms
 psyms

end

function analyze_term(vars, term)
 v = []
 c = []
 f = []
 if issym(term)
  isvar(term, vars) && push!(v, term)
  isconst(term, vars) && push!(c, term)
 else
  push!(f, term.args[1])
  nv, nc, nf = analyze_args(vars, term.args[2:end])
  append!(v, nv)
  append!(c, nc)
  append!(f, nf)
 end
 return v,c,f
end

function analyze_args(vars, args)
 v = []
 c = []
 f = []
 for term in args
   nv, nc, nf = analyze_term(vars, term)
   append!(v, nv)
   append!(c, nc)
   append!(f, nf) 
 end
 return v,c,f
end

function analyze_lit(vars, atom)
 (v,c,f) = analyze_args(vars, atom.args[2:end])
 return v, c, f, atom.args[1]
end

function analyze_sym(core)
 ldb = core.ldb
 vpool = []
 cpool = []
 fpool = []
 ppool = []

 for lid in keys(ldb)
  atom = ldb[lid].body.args[2] ## remove sign of lit
  if @isdefined(atom.args[1]); continue end
  cid = cidof(lid, core)
  vars = varsof(cid, core)

  (v,c,f,p) = analyze_lit(vars, atom)
  append!(vpool, v)
  append!(cpool, c)
  append!(fpool, f)
  push!(ppool, p)
 end
 return COREINFO(Set(vpool), Set(cpool), Set(fpool), Set(ppool))
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
#==
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
==#
