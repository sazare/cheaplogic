# analyzer analyze proof space in core

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

function pairmakefromcore(path)
 core = readcore(path)
 pairs = pairmaker(core)
 core, map(pn->resolvepair(pn,core), pairs)
end 
