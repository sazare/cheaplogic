# Core

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

struct CORE
 ldb
 cdb
 rdb
 clmap
 lcmap
end

function stringtoclause(cid, cls)
 vars = cls.args[1]
 body = cls.args[2].args[1]
 return CForm2(cid, vars, body)
end

function cform2ofclause(clss, initn=1)
 nclss=[]
 for cno in 1:length(clss)
  cid = cidof(cno+initn-1)
  push!(nclss, stringtoclause(cid, clss[cno]))
 end
 nclss
end

function numberingliterals(ncls, lno0, ldb, lcmap, clmap)
 cid = ncls.cid
 lids = []
 nlno0=0
 for lno in 1:length(ncls.body.args)
  cls=ncls.body.args[lno]
  lit = ncls.body.args[lno]
  lno = lno+lno0-1 
  nlno0 = lno+1
  lid = lidof(lno)
  lcmap[lid] = cid
  push!(lids, lid) 
  push!(ldb, LForm2(lid, lit))
 end
 clmap[cid] = lids

 return nlno0, ldb, lcmap, clmap
end

function createLDB(clss)
 ldb = []
 lno = 1
 ltoc = Dict()
 ctol = Dict()
 for ncls in clss
  lno, ldb, ltoc, ctol = numberingliterals(ncls, lno, ldb, ltoc, ctol)
 end 
 return ldb, ltoc, ctol
end

function vform2ofclause(cdb)
 map(ncl->VForm2(ncl.cid, ncl.vars) ,cdb)
end

function createcore(clss)
 cdb = cform2ofclause(clss)
 ldb, lcmap, clmap =createLDB(cdb)
 rdb = []
 cvdb = vform2ofclause(cdb)
 rvdb = vform2ofclause(rdb)
 
 CORE(ldb,cvdb,rvdb,clmap,lcmap)
end

#core operation

getno(id) = parse(string(id)[2:end])
cidof(num) = Symbol(:C, num)
lidof(num) = Symbol(:L, num)
ridof(num) = Symbol(:R, num)

function varsof(cid, core)
 cno = getno(cid)
 core.cdb[cno].vars
end

function bodyof(cid, core)
 clmap=core.clmap[cid]
 body = []
 for lid in core.clmap[cid]
  push!(body, core.ldb[getno(lid)].body)
 end
 body
end


function clauseof(cid, core)
 CForm2(cid, varsof(cid, core), bodyof(cid, core))
end


#print
function printcdb(cdb) 
 if isempty(cdb)
  println("empty")
 else
  map(ncl->println("$(ncl.cid): $(ncl.vars)"), cdb)
 end
end

function printldb(ldb)
 if isempty(ldb)
  println("empty")
 else
  map(nli->println("$(nli.lid): $(nli.body)"),ldb)
 end
end

function printmap(symmap)
 if isempty(keys(symmap))
  println("empty")
 else
  for key in keys(symmap)
   println("$key=>$(symmap[key])")
  end
 end
end

function printcore(core)
println("CDB")
 printcdb(core.cdb)
println()
println("LDB")
 printldb(core.ldb)
println()
println("RDB")
 printcdb(core.rdb)
println()
println("LCMAP")
 printmap(core.lcmap)
println()
println("CLMAP")
 printmap(core.clmap)
end


