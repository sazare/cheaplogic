# analyzer analyze proof space in core

##### STATIC Analysis
## Pairing

struct LIDPAIR
  plid
  nlid
end

function pairing(plist, nlist)
  pairs=[]
  for ps in plist
  for ns in nlist
    push!(pairs, LIDPAIR(ps, ns))    
  end
  end
  pairs
end

function pairmaker(core)
 pairs = []
 for psym in core.allpsym
  pos = oppositof(:-, psym, core)
  neg = oppositof(:+, psym, core)

  append!(pairs, pairing(pos, neg)) 

 end
 pairs
end

function resolvepair(pn, core)
 plid = pn.plid
 nlid = pn.nlid
 varp = varsof(cidof(plid, core), core)
 varn = varsof(cidof(nlid, core), core)
 vars = vcat(varp, varn)
 plit = literalof(plid, core)
 nlit = literalof(nlid, core)
 mgu = unify(vars, plit.body.args[2], nlit.body.args[2])
 return pn, vars, mgu

end

function pairmakefromcore(path::String)
 core = readcore(path)
 pairs = pairmaker(core)
 core, map(pn->resolvepair(pn,core), pairs)
end 

function pairmakefromcore(core::CORE)
 pairs = pairmaker(core)
 core, map(pn->resolvepair(pn,core), pairs)
end 

function printvm(vs, ts)
  cflag=false
  for ix in 1:length(vs)
    v = vs[ix]
    t = ts[ix]
    if v==t; continue end
    cflag && print(",")
    cflag=true
    print("$v/$t")
  end
  println()
end

function printlform2(lfm)
  print("$(lfm.lid):$(lfm.body)")
end

function printpair(pair, core)
 if cidof(pair.plid,core) == cidof(pair.nlid,core) 
   print("*")
 else
   print(" ")
 end
 print("<")
 printlform2(literalof(pair.plid, core))
 print("; ")
 printlform2(literalof(pair.nlid, core))
 println(">")
end

function printpvms(pvms, core)
  for pvm in pvms
    println("---")
    printpair(pvm[1], core)
    printvm(pvm[2], pvm[3])
  end
end

#############
# Graphical properties
"""
emptylsyms(core::CORE) find lsyms no clause attached.
"""
function emptylsyms(core::CORE)
 psyms = core.allpsym
 els = []
 for psym in psyms
  plsym = lsym(:+,psym)
  nlsym = lsym(:-,psym)
  if isempty(core.level0[plsym]) 
   push!(els, plsym)
  elseif isempty(core.level0[nlsym])
   push!(els, nlsym)
  end
 end
 return els
end

"""
find reachable lsyms from literal
"""
functio reachable(lsym, core::CORE)
end


