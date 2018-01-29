# Clause set operation

struct RESDB
  cdb
  ldb
  pgr
end

#==
 CDB(clauses) -> LDB(Literals), PGR(Graph)
==#

include("common.jl")
include("reso.jl")

#==
 primitives for CDB
==#

function getvars(cdb, cid)
 cdb[cid][1]
end

function getvars(db::RESDB, cid) 
 db.cdb[cid][1]
end

function getcls(cdb, cid)
 if cid == 0; return [[],EmptyClause] end
 cdb[cid]
end

function getcls(rdb::RESDB, cid)
 if cid == 0; return [[],EmptyClause] end
 rdb.cdb[cid]
end

function getlit(cdb, clp)
 cid,lid=clp
 return cdb[cid][2].args[lid].args[1], cdb[cid][2].args[lid].args[2]
end

function getlit(db::RESDB, clp)
 cid,lid=clp
 return db.cdb[cid][2].args[lid].args[1], db.cdb[cid][2].args[lid].args[2]
end

function litcounts(cdb)
 map(x->length(x[2].args),cdb)
end

function litcounts(db::RESDB)
 map(x->length(x[2].args),db.cdb)
end

#==
 maker for CDB,LDB,PGR
==# 
makecent(cls) = (Array{Symbol}(cls.args[1].args), cls.args[2].args[1])

function makecdb(cdb,cls)
  vars, cl = makecent(cls)
  push!(cdb, (vars, cl))
  return cdb
end

function addcdb(cdb, clss)
 for cls in clss
  makecdb(cdb,cls)
 end
 cdb
end

function makeldb(ldb, cid, cls)
 for lid in 1:length(cls.args[2].args[1].args)
  lit=cls.args[2].args[1].args[lid]
  ldb[(cid,lid)]=lit
 end 
 return ldb
end

function makepg(ldb)
 pgr=Dict()

 # ADHOC
 psyms = map(x->x.args[2].args[1],values(ldb))
 psyms = union(psyms,psyms)
 map(p->pgr[p]=[[],[]],psyms)
 
 for lid in keys(ldb)
  sign = ldb[lid].args[1] 
  psym = ldb[lid].args[2].args[1]

  if sign == :+   
    push!(pgr[psym][1],lid)
  else # sign == :-
    push!(pgr[psym][2],lid)
  end

 end
 return pgr
end

function makedb(clauses)
 cdb = []
 ldb = Dict() 
 for cid in 1:length(clauses)
  cls = clauses[cid] 
  cdb = makecdb(cdb, cls)
  ldb = makeldb(ldb, cid, cls)
 end
 pgr = makepg(ldb)
 return RESDB(cdb, ldb, pgr)
end

##
newcd(cdb) = length(cdb) + 1

function putcdb(cdb,cls)
 push!(cdb, cls)
end

function putcdb(cls, cdb,ldb,pgr)
 cid = newcid(cdb)
 cdb = putcdb(cdb,cls)
 ldb = putldb(ldb,cid, cls)
 pgr = putpgr(pgr,cls)

 return cdb, ldb, pgr
end

function replacecdb(clsb, clsa, db)
@nyi :replacecdb
end

findunit(cdb) = find(x->x==1,litcounts(cdb))

#==
printing
==#

function printvars(vars)
 print("[")
 for i in 1:length(vars)
  if i < length(vars); print("$(vars[i]),") end
  if i == length(vars); print("$(vars[i])") end
 end 
 print("]")
end

function printcdb(cdb)
 for i in 1:length(cdb)
  print("$i ")
  printvars(cdb[i][1])
  println(cdb[i][2])
 end
end

function printplist(plist)
 for i in 1:length(plist)
  if i < length(plist); print("$(plist[i]),") end
  if i == length(plist); print("$(plist[i])") end
 end
end

function printldb(ldb)
 for pr in keys(ldb)
  println("$pr => $(ldb[pr])")
 end
end

function printpgr(pgr)
 for p in keys(pgr)
  print("$p: ")
  print("\n +")
  printplist(pgr[p][1])
  print("\n -")
  printplist(pgr[p][2])
  println()
 end
end

## introduce a type for DB(cdb,ldb,pgr)

function printdb(resdb)
println("Clauses")
  printcdb(resdb.cdb)
println("\nLiterals")
  printldb(resdb.ldb)
println("\nGraph")
  printpgr(resdb.pgr)
end
 
