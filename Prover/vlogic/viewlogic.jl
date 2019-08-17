# viewlogic.jl

# access from a browser
# url: http://localhost:8000/go?op=start
#==
 kick a browser by some program
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
global DIL  DoItLater has lid's when it is used
global maxdil max count of DIL
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

global DIL = Dict{Symbol, Int}()
global maxdil = 0

#
# the route /go (Genie issue)
#
route("/go") do
 pm = @params()
 op = pm[:op]
 if core != nothing
  @info gid
 end # if

 if op == "start"
  return gostart()
 elseif op == "readcore"
  return goreadcore(pm)
 elseif op == "stepgoal"
  if gid == :nogid
   global gid = pm[:gid]
   return goevaluate(pm,gid)
  else
   return goevaluate(pm,gid)
  end #if gid
 elseif op == "postview"
  return postview(pm)
 elseif op == "resolve"
  return goresolve(pm,gid)
 end # if op
end # route

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
  pres = makepres([score, "======="])

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

  if isempty(lidsof(gid,core))
  # form = htmlform("start", [], "Confirm", "Cancel") 
   return contraview(gid, core)
  else # isempty
   pres = makepres([score, "======="])
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
doevals apply evaluate while applicable
"""
function doevals(gid, core)
@info :doeval,gid
 while true
  ogid = gid
@info :evaluategoal,gid
  gid,core = evaluategoal(gid, core)
@info :after, :evaluategoal
  if gid == ogid
    break
  else # if gid == ogid
    ogid = gid
  end #if gid == ogid
 end # while true
 return gid, core
end # doevals

"""
goalprover full control of view prover
"""
function goalprover(pm, pres)
@info :goalprover
 try
  rico = doevals(gid, core)
  global core = rico[2]
  global gid = rico[1]

## gid, core has evaluated clause
@info gid
  glids = lidsof(gid, core)
  nlids = literalsof(glids, core)
@info :goalprover1, gid, glids, nlids

  if length(glids) == 0 # when []
   return contraview(gid, core)
  else # if  when not []
# after eval, choose view or resolve in goaftereval?
# askU traverse postview after it
   askpage =  askU(gid, core, "postview")
   
# askpage is generated 
   if askpage != nothing
     return askpage
   end # if askpage
  end # if []
# when no cano lid, askpage is nothing 
@info :askpage_nothing
# no askpage, no cano lid, following resolve(not stepgoal)
  form = htmlform("resolve", [], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))

 catch e
  if isa(e, VALID)
@info validview
   return validview(gid, core)
  else # if isa
@info :unknownview,e
@info :thiscantbecontraandvalid
   return unknownview(gid, e, core)
  end # if isa
 end #try
end # goalprover

"""
goevaluate is called from web

"""
function goevaluate(pm,gid0)
@info :goevaluate, gid0
# show core
  score = stringcore(core)
 pres = makepres([score, "======="])
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
                  htmlbody("$cls can't progress", "",form))
end #failview

"""
getσo make a σ for after a view input.
the vars of σ is cvars
gvars is needed for a term in the context of glid
"""
function getσo(cvars, gvars, pm)
 σo = []
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
 return σo
end # getσo

"""
doitlater(gid) count the when tried
"""
function doitlater(gid)
# global maxdil += 1
# DIL[gid] = maxdil
 DIL[gid] = whendoit(gid) + 1
end

function doitlater(gid,wdi)
# global maxdil = max(wdi, maxdil)+1
# DIL[gid] = maxdil
 DIL[gid] = wdi + 1
end

"""
whendoit(gid) return the gid's count
"""
function whendoit(gid)
 if haskey(DIL, gid)
  return DIL[gid]
 end
 return 0
end

"""
postview is the last half of view input
"""
function postview(pm)
@info :postview, :SOURCElittleLONG
#temporalily view only
 global varg = lvarsof(glid, core)
 global gatm = literalof(glid, core).body.args[2]
# global varg = restrictvars(glid, core)
 global varc = canovarsof(glid,core)
 global catm = canoof(glid,core)[2]

 σo=[]
@info pm
@info varg
 if pm[:how] == "abort"
@info :isabort
  score = stringcore(core)
  sres = stringclause(gid, core)
  pres = makepres([score, "GOAL $(sres)", "======="])

  doitlater(glid)

  form = htmlform("stepgoal", [], "Confirm", "Cancel")
  return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
 end # if "abort"

@info :noabort
@show varc,varg
 σo = getσo(varc, varg, pm)
@show varc,σo,gatm.args[2:end]
 σo = apply(varc, σo, gatm.args[2:end])
@show varc,catm,σo
 catm2= apply(varc, catm, σo)
@info :after_apply catm2,varc,catm,σo
 σg = unify(varg, gatm, catm2)
@info :after_unify σg,varg,gatm,catm2
 try
  nid, ncore = factify_clause(glid,σg,core)
@info :after_factify,nid,glid,σo,σg 
  global gid = nid
  global core = ncore
 
  if 0 == length(lidsof(gid, core))
   @warn :is_thisfirstview_need
   global firstview=true
   return contraview(gid, core)
  else
   score = stringcore(core)
   sres = stringclause(gid, core)
   pres = makepres([score, "GOAL $(sres)", "======="])
   form = htmlform("stepgoal", [], "Confirm", "Cancel")
   return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
  end # if
 catch e
  @info e
  if isa(e, VALID)
   return validview(gid, core)
  else
   @warn gid,e
   return unknownview(gid, e, core) # remove this
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

 pres = makepres(["CLAUSES", clist])
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
global DIL = Dict{Symbol, Int}()
global maxdil = 0
end #resetglobals

#Genie issue
Genie.AppServer.startup()

