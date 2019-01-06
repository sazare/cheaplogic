# cheap LPS(Logical Program Synthesis)

function lps_prover(spec, steplimit, contralimit)
 cdx=readcore(spec)
 tdx=alltemplateof(cdx)
 gb=[lidsof(:C1, cdx)]
 conds = []
 nstep = 0;

 evalproc(cdx.proc)
 execs = execof(cdx)
 cdx, branch = srule(cdx, execs)

 while true
  ga=dostepgoals1(gb, cdx)
  nstep += 1
  conds = contradictionsof(cdx)
  if length(conds) >= contralimit;break end
  if nstep >= steplimit;break end
  gb = ga
 end
 return conds,cdx,branch,INVARS,OUTVARS
end

## S-rule
function fname(str)
  ix=findfirst("(", str)
  if isa(ix, Nothing) 
    return Nothing
  else
    return Symbol(str[1:(ix[1]-1)])
  end
end

function execof(core)
  exdb = []
  for pd in core.proc
    fn = fname(pd)
    if !isa(fn, Nothing)
      push!(exdb, fn)
    end
  end
  return exdb
end

function isexec(sym, edb)
  return in(sym,edb)
end

function srule(core, execs)
 branch = Dict{Symbol,Array}()
 for cid in keys(core.cdb)
   lits = []
   exes = []
   for lid in lidsof(cid, core)
     psym = literalof(lid, core).body.args[2].args[1]
     if isexec(psym, execs)
       push!(exes, lid)
     else
       push!(lits, lid)
     end
   end
   core.clmap[cid]  = lits
   branch[cid] = exes
 end
 core, branch
end

### extraction
function traceof(rid, vars, core)
  if rid in keys(core.proof)
    step = core.proof[rid]
    vars = traceof(cidof(step.leftp,core), vars, core)
    vars = traceof(cidof(step.rightp,core), vars, core)
    vars = apply(ovarsof(step.leftp, step.rightp, core), vars, step.sigma)
    vars = apply(step.rename[1], vars, step.rename[2])
# else
#  printclause(rid, core)
  end
   return vars
end

function extract(core,ins,ons)
  einf = []
  for conid in contradictionsof(core)
    rins = traceof(conid, ins, core)
    rons = traceof(conid, ons, core)
    push!(einf, [rins,rons,conid])
  end
  return [ins,ons],einf 
end


### coder for julia
function printExpr(io,e::Number)
  print(io,e)
end

function printExpr(io,e::Symbol)
  print(io,e)
end

function printExpr(io,ea::Array)
  for e in ea
    print(io,e);print(io," ")
  end
end

function printExpr(io,e::Expr)
  print(io,"$(e.args[1])(")
  if 1==length(e.args)
    print(io,")")
    return
  end
  for ix in 2:length(e.args)
    ag = e.args[ix]
    printExpr(io,ag)
    if ix != length(e.args); print(io,",") end
  end
  print(io,")")
end

function printExprVec(io,ev)
  for ix in 1:length(ev)
    printExpr(io,ev[ix])
    if ix != length(ev); print(io,",") end
  end
end

function printaline(io, core, fname, iov, einf, bra)
  ea=apply(einf[1], einf[2], iov[1])
  printExprVec(io,ea)
end


function econdsof(rid, core, brdb, pabr)
  bras = []
  crid=rid 
  if iscid(crid)
    bras = union(brdb[crid], pabr)
    return bras
  else # has parents
    ps = stepof(rid, core)
    lbrs=econdsof(cidof(ps.leftp,core), core, brdb, pabr)
    rbrs=econdsof(cidof(ps.rightp,core), core, brdb, pabr)
    bras = union(lbrs, rbrs)
  end
  bras = intersect(bras,bras)
  return bras
end

function terms2julia(core, fname, econds, einf)
  jterm = []
  for elid in econds
    lf2 = literalof(elid, core)
    vars = varsof(cidof(lf2.lid, core),core)
    eterm = lf2.body
    if eterm.args[1] == :+
      eterm.args[1] = :!
    else
      eterm = eterm.args[2]
    end
    fterm = apply(vars, eterm, vcat(einf[1],einf[2]))
    push!(jterm, fterm) 
  end
  return jterm
end

# :L5 == econdsof(:R4, cf, bf,[])[1]
# terms2julia(cf, :fact, [literalof(:L5,cf).body])
# => "!gt(i_C3, 0)"

function inputcond(ins, einf)
  icond = []
  for ix in 1:length(ins)
    iv = ins[ix]
    ev = einf[1][ix]
    if iv != ev
      push!(icond, :(==($iv,$ev)))
    end
  end
  return icond
end

function makeands(ts)
  if length(ts) == 0; return :[] end
  ands = ts[1]
  if length(ts) == 1; return ands end
  for ix in 2:length(ts)
    ands = :($ands && $(ts[ix]))
  end
  return ands
end

function isidaxiom(einf, fname)
  oform = einf[2][1]
  return isa(oform, Expr) && oform.args[1] == fname
end

function printbody(io,core, fname, iov, einfs, sdb)
  println(io)
  body = []
  for einf in einfs
    iconds = inputcond(iov[1],einf)
    econds = econdsof(einf[3], core, sdb, [])
    aconds = vcat(iconds, terms2julia(core, fname, econds, einf)) 
    ands = makeands(aconds)
    if isidaxiom(einf, fname); print(io,"# idaxiom: ") end
    if ands != []; print(io,"if $ands; ") end
    printlist(io,iov[2]);print(io,"=")
    
    printaline(io,core, fname, iov, einf, sdb)
    if ands != []; println(io, " end") end
  end
end

function printlist(io, syms::Array)
  for ix in 1:length(syms)
    print(io,syms[ix])
    if ix != length(syms); print(io,",") end
  end
end

function printargs(io,syms::Array)
  print(io,"(")
  printlist(io, syms)
  print(io,")")
end

function coder_julia(outfname, core, fname, iov, einfs, sdb)
  open(outfname, "w") do io
    println(io, "# $fname")
    print(io,"function $fname")
    printargs(io,iov[1])
    printbody(io,core, fname, iov, einfs, sdb)  
    print(io,"return "); printlist(io,iov[2]);println(io)
    println(io,"end")
  end
end

#### combined
function lps(outfname, specp, fname, steplimit, contralimit)
  df,cf,bf,ins,ons=lps_prover(specp, steplimit, contralimit)
  invs = ins.args
  onvs = ons.args

  ves, eis=extract(cf, invs, onvs)
  #coder_julia(cf, fname, [invs,onvs], eis, bf)
  coder_julia(outfname, cf, fname, ves, eis, bf)

  return df,cf,bf,eis,ins,ons
end

