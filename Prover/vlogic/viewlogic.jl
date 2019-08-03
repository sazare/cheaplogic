# viewlogic.jl

# access from a browser
# url: http://localhost:8000/go?op=start
#==
# kick a browser by some program
cmd=`open -a "Google Chrome.app" http://localhost:8000/go?op=start`
run(cmd)
==#

using Genie
import Genie.Router: route
import Genie.Router: @params

# global variables for an run the same
# if you wish to these globals in a session,
# keep them in a session object
#==
global core is the core read from a file

the goal is set by the view user

global glid is th focused lid of the goal
global gcid is the cid of the goal
global goal is the goal(=lids of gcid)

 varg and gvar is different view's pre and post
global varg is the vars of the goal
global gvar is the goal's vars

global firstview need gcid

global gatm is the atom of the glid. canonical determins atom only.
global varc  canonical's vars
global vatm  ?
global σi    the σ for the new view 
global gid is the cid of the goal. before an input, it is :nogid 
 ? gid is gcid?
==#

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
"""
getσo make a σ for after a view input.
the vars of σ is cvars
gvars is needed for a term in the context of glid
"""
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
  end # try
 end # for
 σo
end # getσo

#
# the route /go (Genie issue)
#
route("/go") do
 pm = @params()
 op = pm[:op]
 if core != nothing
  @info gid
 end # if
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
  end #if gid
 elseif op == "postview"
@info :postview
  return postview(pm)
 elseif op == "resolve"
@info :resolve,gid
  return goresolve(pm,gid)
 end # if op
end # route

"""
 chooseresolvelid chooses a lid for resolve
 the lid should be not Proc, not Cano
"""
function chooseresolvelid(lids, core)
@info :chooseresolvelid
 nlit = []
 for lid in lids
  lit2 = literalof(lid,core)
  if !isProc(lit2) && !isCano(lit2, core)
# this choose one of lits, but it will be more complicate.
   return lid
  end # !isProc && !isCano
 end #for lid
@info :chooseresolvelid_nothing
 return nothing
end # chooseresolvelid

"""
goresolve resolves a lit with oppos of it

"""
function goresolve(pm, gidl)
@info :goresolve, gidl
 glids = lidsof(gidl, core)
# no lids, this is a contradiction
 if isempty(glids); return contraview(gidl, core) end

# prepare a resolution
 nlits = literalsof(glids, core)
 glid = chooseresolvelid(glids, core)

 # time to resolve glid
 # when glid cant be resolved
 # I should backtrack. but now it is not clear 
 
 if glid == nothing
@show :glid_eq_nothing
  # no lid for resolve
  score = stringcore(core)
  pres = """
<pre>$(score)</pre>
<pre>=======</pre>
"""
  form = htmlform("stepgoal", [], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))
 end # if glid==nothing
# now new goal born
 try
  gc=resolvelid(glid, core)
  if gc != nothing
@info gc
   global gid = gc[1]
   global core = gc[2]
  end # if gc

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
 catch e
  println("e = $e")

  if isa(e, VALID)
   return validview(gid, core)
  elseif isa(e, ICMP)
@info :fail_unify,e
@info :needbacktrace
   return failview(gid, core)
  else 
@info :quit_if_fail_is_it_correct
@info :fail_and_next,e
    throw(e)
   end #if isa
  end # try
end #goresolve

"""
goalprover full control of view prover
"""
function goalprover(pm, pres)
@info :goalprover
 try
# eval step
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

# after eval
## here gid, core has evaluated clause
@info gid
  glids = lidsof(gid, core)
  nlids = literalsof(glids, core)
@info :goalprover1, gid, glids, nlids
  if length(nlids) == 0
   return contraview(gid, core)
  else # if length
 # after eval, choose view or resolve in goaftereval?
 # askU traverse postview after it
   askpage =  askU(gid, core, "postview")
   
 # askpage is generated 
   if askpage != nothing
     return askpage
   end # if askpage

 # when no cano lid, askpage is nothing 
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

# no askpage, no cano lid, following resolve(not stepgoal)
@info :noaskpage
# form = htmlform("stepgoal", [], "Confirm", "Cancel") 
 form = htmlform("resolve", [], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))

end # goalprover

"""
goevaluate is called from web

"""
function goevaluate(pm,gid0)
@info :goevaluate, gid0
# show core
  score = stringcore(core)
 pres = """
 <pre>$(score)</pre>
 <pre>=======</pre>
"""
@info :goevaluate1, pm
 if gid != :nogid
# if not firstview, set gid to gid0
  global gid = Symbol(gid0)
 end

@info pres
  page = goalprover(pm, pres)
@info page
  return page
end # goevaluate

"""
contravie is the view for contradiction occured
"""
function contraview(cid, core)
 form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
  return htmlhtml(htmlheader("Contradiction"), 
                  htmlbody("$cls is Contradiction", "",form))
end # contraview

"""
validview is the view for valid occured
"""
function validview(cid, core)
 form = htmlform("start", [], "Confirm", "Cancel")
 cls = stringclause(cid, core)
 return htmlhtml(htmlheader("Valid"), 
                  htmlbody("$cls is valid", "",form))
end # validview

"""
unknownview is the view for unknown state
"""
function unknownview(cid, except, core)
 form = htmlform("start", [], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Exception occurs"), 
                  htmlbody("$cid makes  $(except)", "",form))
end # unknownview

"""
failview is the view fail occured
"""
function failview(cid, core)
@info cid
 form = htmlform("start", [], "Confirm", "Cancel")
 cls = stringclause(cid, core)
@info cls
 return htmlhtml(htmlheader("Fail attempt"), 
                  htmlbody("$cls cant progress more", "",form))
end #failview

"""
postview is the last half of view input
"""
function postview(pm)
@info :postview, :SOURCETOOLONG
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
 end # if "abort"
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
  end # try
 end # for
@info σo

@info :beforeapply varc catm σo
 catm2= apply(varc, catm, σo)
@info :beforeunify varg gatm catm2
 σg = unify(varg, gatm, catm2)

@info :before_factify_clause
@info glid σo σg 
 try
  nid, ncore = factify_clause(glid,σg,core)

@info ncore

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
  end # if
 catch e
@info e
  if isa(e, VALID)
   return validview(gid, core)
  else
   return unknownview(gid, e, core)
  end #if
 end #try
end # postview

"""
goreadcore do readcore(path is given by pm)
"""
function goreadcore(pm)
@info :goreadcore
 corepath = pm[:corepath]
 resetglobals()
 global core = readcore(corepath)

 evalon && evalproc(core.proc)

 clist = ""
 for id in sort(collect(keys(core.cdb)),lt=ltid)
   clist *= "$(stringclause(id, core))</br>"
 end # for

 pres = "<pre>CLAUSES</pre>$(clist)"
 form = htmlform("stepgoal", [htmlinput("gid", "gid")], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Select GID"), htmlbody("which gid", pres, form))
end

"""
gostart input the path of the core
"""
function gostart()
@info :gostart
 form = htmlform("readcore", [htmlinput("CNF path", "corepath")], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Core selection"), htmlbody("select core", "", form))
end #goreadcore

"""
resetglobals initialize the globals for new start
"""
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
end #resetglobals

#Genie issue
Genie.AppServer.startup()

