# viewlogic.jl

# from vlogic0.jl
# url: http://localhost:8000/go?op=start
#==
# in program
cmd=`open -a "Google Chrome.app" http://localhost:8000/go?op=start`
run(cmd)
==#

using Genie
import Genie.Router: route
import Genie.Router: @params

global core = nothing
global glid
global gcid
global goal
global varg
global gvar
global firstview=true

global gatm
global varc
global vatm
global σi
global gid = :nogid

####
function getσo(cvars, gvars, pm)
 σo=[]
 for v in cvars
  try
    vr = pm[v]
    if isconst(vr, gvars)
      push!(σo, vr)
    elseif "" == vr
      push!(σo, v)
    else
      push!(σo, Symbol(vr))
    end
  catch
    push!(σo, :none)
    #push!(σo, Symbol(v))
  end
 end
 σo
end

#==
 start=>cnfpath=>
 readcore(cnfpath)=>core=>
# viewpage(gid)=>[view]=>
 stepgoal(gid)=>evaluate&view=>{postview}
 postview()=> 
 stepgoal()=>evaluate&reso=>
 confirmgoal()=>

==#
route("/go") do
 pm = @params()
 op = pm[:op]
if core != nothing
  @info gid
end
@info op
 if op == "start"
@info :start
  return gostart()
 elseif op == "readcore"
@info :readcore
  return goreadcore(pm)
 elseif op == "stepgoal"
  @info :stepgoal
  if gid == :nogid
@info :nogid
   global gid = pm[:gid]
   return goevaluate(pm,gid)
  else
@info gid
   return goevaluate(pm,gid)
  end
 elseif op == "postview"
@info :postview
  return postview(pm)
 elseif op == "resolve"
@info :resolve
  return goresolve(pm,gid)
 end
end

#==
"""
 divergence of level i 
"""
#function divergence(lid, i, core)
 if i == 0; return [lid] end
 divlids = []
 for lid2 in lidsof(cidof(lid, core),core)
  nextids = divergence(lid2, i-1, core)
  divlids  = union(nextids, divlids)
 end
 return  divlids
end
==#

"""
 priority function for resolve
"""
function chooseresolvelid(lids, core)
@info :chooseresolvelid
 nlit = []
  
 for lid in lids
  lit2 = literalof(lid,core)
  if !isProc(lit2) && !isCano(lit2, core)
# this choose one of lits, but it will be more complicate.
   return lid
  end # !isProc(lit2) && !isCano(lit2, core)
 end #for lid
@info :chooseresolvelid_nothing
 return nothing
end

"""
resolvelid(glid, core)
"""
function resolvelid(glid, core)
@info :resolvelid
# get a literal
 glit = literalof(glid, core)
 varsg = cvarsof(glid, core)
 atomg = atomof(glid, core)
 remg  = setdiff(lidsof(cidof(glid, core), core), [glid])
@info glit, varsg, atomg, remg
# maching for all opposit
 sign, psym = psymof(glid, core)
@info sign, psym
 
 oppos = oppositof(sign, psym, core)
 for olid in oppos
@info olid
# try unify them
# if sigma made, it should return
  ovars = cvarsof(olid, core)
  oatom = atomof(olid, core)
@info ovars, oatom
  ovars=vcat(varsg, ovars) 
@info ovars

  try
   core.trycnt[1] += 1
@info :before_unify, ovars, atomg, oatom
   σ = unify(ovars, atomg, oatom)
@info σ,olid
   orem = lidsof(cidof(olid,core), core)
@info orem,remg, olid
   grem = setdiff(vcat(orem, remg), [olid])
@info grem

#rename resolvent 
@info :rename_resolvent
   rid  = newrid(core)
   nrem = rename_lids(rid, grem, core)
   nbody = literalsof(grem, core)
   nbody1 = apply(ovars, nbody, σ) ### ovars are renamed??
@info rid, nrem, nbody,nbody1
@info :no_evaluation 
# no evaluation

   vars = fitting_vars(ovars, nbody1, core)
   body = rename_clause(rid, vars, nbody1)

   renameσ = [vars, body.vars]
@info renameσ

 ## settlement

   core.succnt[1] += 1
   core.cdb[rid] = VForm2(rid, body.vars)
   core.clmap[rid] = nrem
   for i in 1:length(nrem)
    core.ldb[nrem[i]] = LForm2(nrem[i], body.body[i])
   end #for i
   for rlid in nrem
    core.lcmap[rlid] = rid
   end # for rlid
   core.proof[rid] = STEP(rid, glid, olid, σ, renameσ[2], :reso)
@info :after_core_proof, body
#   rcf2=CForm2(rid, body.vars, body.body)
#@info rcf2

   gid = rid
   return gid, core

  catch e
   println("e = $e")

   if isa(e, VALID)
    return validview(gid, core)
   elseif isa(e, ICMP)
    continue
   else 
@info :quit_if_fail_is_it_correct
@info :fail_and_next
    throw(e)
   end #if isa
  end # try
 end # for olid

end # function resolvelid


"""
resolve a lit no cano and no proc
"""
function goresolve(pm, gidl)
@info :goresolve, gidl
 glids = lidsof(gidl, core)
 if isempty(glids); return contraview(gidl, core) end
 nlits = literalsof(glids, core)
 glid = chooseresolvelid(glids, core)

 # time to resolve picklid
 # when picktlid cant be resolved
 # i do nothing... is it correct??
 
 if glid == nothing
  # no lid for resolve
  score = stringcore(core)
  pres = """
<pre>$(score)</pre>
<pre>=======</pre>
"""
  form = htmlform("stepgoal", [], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))
 end # if glid
# now new goal born
 gc=resolvelid(glid, core)
@info gc
 global gid = gc[1]
 global core = gc[2]

 score = stringcore(core)
pres = """
<pre>$(score)</pre>
<pre>=======</pre>
"""

 # 
 if isempty(lidsof(gid,core))
 # form = htmlform("start", [], "Confirm", "Cancel") 
  return contraview(gid, core)
 else # isempty
  form = htmlform("stepgoal", [], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))
 end # isempty
end

"""
goalprover
"""
function goalprover(pm, pres)
@info :goalprover
 try
  while true
   ogid = gid
   rico = evaluategoal(gid, core)
 @info :after, :evaluategoal
   global core = rico[2]
   global gid = rico[1]
   if gid == ogid
     break
   else # if gid == ogid
     ogid = gid
   end #if gid == ogid
  end # while true

## here gid, core has evaluated clause
@info gid
  glids = lidsof(gid, core)
  nlids = literalsof(glids, core)
@info :goalprover1, gid, glids, nlids

  if length(nlids) == 0
   return contraview(gid, core)
  else # if length
 # after eval, choose view or resolve in goaftereval?
 # choosecanoid() in askU select a view literal
   askpage =  askU(gid, core, "postview")
   if askpage != nothing
     return askpage
   end # if askpage
@info :askpage_nothing
  end # if length
 catch e
  if isa(e, VALID)
@info validview
   return validview(gid, core)
  else # if isa
@info :unknownview,e
   return unknownview(gid, e, core)
  end # if isa
 end #try

# no askpage
@info :noaskpage
# form = htmlform("stepgoal", [], "Confirm", "Cancel") 
 form = htmlform("resolve", [], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))

end # goalprover

function goevaluate(pm,gid0)
@info :goevaluate, gid0
  score = stringcore(core)
 pres = """
 <pre>$(score)</pre>
 <pre>=======</pre>
"""
@info :goevaluate1, pm
if gid != :nogid
  global gid = Symbol(gid0)
end

@info pres
  page = goalprover(pm, pres)
@info page
  return page
end

function contraview(cid, core)
  form = htmlform("start", [], "Confirm", "Cancel")
   cls = stringclause(cid, core)
   return htmlhtml(htmlheader("Contradiction"), 
                  htmlbody("$cls is Contradiction", "",form))
end

function validview(cid, core)
  form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
  return htmlhtml(htmlheader("Valid"), 
                  htmlbody("$cls is valid", "",form))
end

function unknownview(cid, except, core)
  form = htmlform("start", [], "Confirm", "Cancel")
  return htmlhtml(htmlheader("Exception occurs"), 
                  htmlbody("$cid makes  $(except)", "",form))
end

function failview(cid, core)
@info cid
  form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
@info cls
  return htmlhtml(htmlheader("Fail attempt"), 
                  htmlbody("$cls cant progress more", "",form))
end

#==
#function goaftereval(pm)
@info :goaftereval :nodef
end
==#

function postview(pm)
@info :postview
#temporalily view only
 global varg = lvarsof(glid, core)
 global gatm = literalof(glid, core).body.args[2]
# global varg = restrictvars(glid, core)
 global varc = canovarsof(glid,core)
 global catm = canoof(glid,core)[2]

@info :restvarg

 σo=[]
@info pm
@info varg
@info :abort
 if pm[:how] == "abort"
  score = stringcore(core)
  sres = stringclause(gid, core)
  pres = """
  <pre>$(score)</pre>
  <pre>GOAL
  $(sres)
  =======</pre>
 """
   form = htmlform("stepgoal", [], "Confirm", "Cancel")
   return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
 end
 for v in varc
  try
    vr = pm[v]
    if v == vr
      push!(σo, v)
    elseif "" == vr
      push!(σo, v)
    else
      !isa(vr, Symbol) && push!(σo, Meta.parse(vr))
    end
  catch
    push!(σo, Symbol(v))
  end
 end
@info σo

@info :beforeapply varc catm σo
 catm2= apply(varc, catm, σo)
@info :beforeunify varg gatm catm2
 σg = unify(varg, gatm, catm2)

@info :before_factify_clause
@info glid σo σg 
 try
  nid, ncore = factify_clause(glid,σg,core)

  global gid = nid
  global core = ncore
 
  score = stringcore(core)
  sres = stringclause(gid, core)
 
  pres = """
  <pre>$(score)</pre>
  <pre>GOAL
  $(sres)
  =======</pre>
 """
 
  if 0 == length(lidsof(gid, core))
   global firstview=true
   form = htmlform("start", [], "Confirm", "Cancel")
   return htmlhtml(htmlheader("proof completed"), 
           htmlbody("refuted", pres, form))
  else
   form = htmlform("stepgoal", [], "Confirm", "Cancel")
   return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
  end
 catch e
@info e
  if isa(e, VALID)
   return validview(gid, core)
  else
   return unknownview(gid, e, core)
  end
 end
end


function goreadcore(pm)
@info :goreadcore
 corepath = pm[:corepath]
 resetglobals()
 global core = readcore(corepath)

 evalon && evalproc(core.proc)

 clist = ""
 for id in sort(collect(keys(core.cdb)))
   clist *= "$(stringclause(id, core))</br>"
 end

 pres = "<pre>CLAUSES</pre>$(clist)"
 form = htmlform("stepgoal", [htmlinput("gid", "gid")], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Select GID"), htmlbody("which gid", pres, form))
end

function gostart()
@info :gostart
 form = htmlform("readcore", [htmlinput("CNF path", "corepath")], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Core selection"), htmlbody("select core", "", form))
end

function resetglobals()
global core = nothing
global glid = nothing
global gcid = nothing
global goal = nothing
global varg = []
global gvar = []

global firstview=true

global gatm = nothing
global varc = nothing
global vatm = nothing
global σi   = []
global gid = :nogid
end


Genie.AppServer.startup()


