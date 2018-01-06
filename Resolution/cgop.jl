# Clause set operation

#==
 CDB(clauses) -> LDB(Literals), PGR(Graph)
==#

include("reso.jl")

#==
 primitives for CDB
==#

function getvars(cdb, cid)
 cdb[cid][1]
end

function getlit(cdb, clp)
 cid,lid=clp
 return cdb[cid][2].args[lid].args[1], cdb[cid][2].args[lid].args[2]
end

function litcounts(cdb)
 map(x->length(x[2].args),cdb)
end

#==
 maker for CDB,LDB,PGR
==# 
function makecdb(cdb,cls)
  push!(cdb, (Array{Symbol}(cls.args[1].args),cls.args[2].args[1]))
  return cdb
end

function makeldb(ldb, cid, cls)
 for lid in 1:length(cls.args[2].args[1].args)
  lit=cls.args[2].args[1].args[lid]
  ldb[(cid,lid)]=lit
 end 
 return ldb
end

function makepg(ldb)
 # psyms calc is too slow
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
#push!(cdb, (Array{Symbol}(cls.args[1].args),cls.args[2].args[1]))
  ldb = makeldb(ldb, cid, cls)
 end
 pgr = makepg(ldb)
 return cdb, ldb, pgr
end

##

