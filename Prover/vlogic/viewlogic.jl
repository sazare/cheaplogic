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

include("factify.jl")

global core
global glid
global gcid
global goal
global lvs
global goalsigma
global govars
global firstview=true

global gvar
global gatm
global varc
global vatm
global σi


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
 if op == "start"
  return gostarthtml()
 elseif op == "readcore"
  return goreadcore(pm)
# elseif op == "viewpage"
#  return goviewpage(pm)
 elseif op == "stepgoal"
  return gostepgoal(pm)
 elseif op == "postview"
  return postview(pm)
 end
end

function gostepgoal(pm)
 global gid = Symbol(pm[:gid])
 
 try 
  rico = evaluategoal(gid, core)
  global core = rico[2]
  rid = rico[1]
@show stringcore(core)
  glids=lidsof(rid, core)
  nlids =  literalsof(glids, core) 
@show :gostepgoal1

  if length(nlids) == 0
   return contraview(gid, core)
  else
 # after eval, choose view or resolve in goaftereval?
   return askU(rid, core, "postview")
  end
 catch e
  if isa(e, VALID)
   return validview(gid, core)
  else
   return unknownview(gid, e, core)
  end
 end
 
end

function contraview(cid, core)
   return htmlhtml(htmlheader("Contradiction"), 
                  htmlbody("$cid Contradiction", "",""))
end

function validview(cid, core)
   return htmlhtml(htmlheader("Valid"), 
                  htmlbody("$cid is valid", "",""))
end

function unknownview(cid, except, core)
   return htmlhtml(htmlheader("Exception occurs"), 
                  htmlbody("$(except)", "",""))
end

function goaftereval(pm)

end

function postview(pm)
#temporalily view only
 global lvs = lvarsof(glid, core)
# global lvs = restrictvars(glid, core)

 σo=[]
 for v in lvs
  try
    vr = pm[v]
    if v == vr
      push!(σo, v)
    elseif "" == vr
      push!(σo, v)
    else
      push!(σo, Symbol(vr))
    end
  catch
    push!(σo, Symbol(v))
  end
 end
 if !firstview
   global goalsigma = apply(varsof(gcid,core), goalsigma, σo)
 end

 nc = factify_clause(glid,σo,core)

 if nc == :FAIL
  nrid = :FAIL
  newres = "FAIL"
 else
  nrid = nc[1]
  global core = nc[2]
  score = stringcore(core)
  sres = stringclause(nrid, core)
 end

 pres = """
 <pre>$(score)</pre>
 <pre>GOAL
 $(sres)
 =======</pre>
 <pre>info: $(stringarray(govars)):=$(stringarray(goalsigma))</pre>
"""

 if 0 == length(lidsof(nrid, core))
  global firstview=true
  form = htmlform("start", [], "Confirm", "Cancel")
  return htmlhtml(htmlheader("proof completed"), htmlbody("completed", pres, form))
 else
  form = htmlform("viewpage", [htmlinput("glid", "glid")], "Confirm", "Cancel")
  return htmlhtml(htmlheader("select next glit"), htmlbody("step goal", pres, form))
 end
end

#function goviewpage(pm)
#@show :goviewpage
# global gcid = Symbol(pm[:gid])
# global glids = lidsof(gcid, core)
#
## if length(glid) == 1 
##  lgoal = literalof(glid[1],core).body.args[2]
## else
##  lgoal = []
## end 
# if firstview
#   global goalsigma = varsof(gcid,core)
#   global govars = goalsigma
#   global firstview = false
# end
#
# global goal = stringclause(gcid, core)
# global lgoals = stringlids(glids, core)
#
# inputs = makeinputs(lvarsof(glid,core))
##TODO: lvars be only vars appear sn the literal.
# lvs = restrictvars(glid, core)
# svars = "["
# for ix in 1:length(lvs)
#  svars *= "$(lvs[ix])"
#  ix != length(lvs) && (svars *=",")
# end
# svars *= "]"
# score = stringcore(core)
#
# pres = """
#<pre>$(score)
#GOAL:$(svars).$(lgoals)
#GLID: $(glid)</pre>
#"""
# form = htmlform("stepgoal", inputs, "Confirm", "Cancel")
# return htmlhtml(htmlheader("select goal"), htmlbody("select goal", pres, form))
#end

function goreadcore(pm)
@show :goreadcore
 corepath = pm[:corepath]
 global core = readcore(corepath)

 evalon && evalproc(core.proc)

 clauses = stringclauses(core)
 clist = ""
 for id in reverse(collect(keys(core.cdb)))
   clist *= "$(stringclause(id, core))</br>"
 end

 pres = "<pre>CLAUSES</pre>$(clist)"
 form = htmlform("stepgoal", [htmlinput("gid", "gid")], "Confirm", "Cancel") 
# form = htmlform("viewpage", [htmlinput("gid", "gid")], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Select GID"), htmlbody("which gid", pres, form))
end

function gostarthtml()
@show :gostarthtml
 form = htmlform("readcore", [htmlinput("CNF path", "corepath")], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Core selection"), htmlbody("select core", "", form))
end

Genie.AppServer.startup()

#==
##################################################
# after all


# 処理のloopをViewなしで実行できるようにする
#  viewのかわりのaxiomが選べる
#   canoのliteralをランダムに生成する
#   その結果できるσoをランダムに生成する
# 

#@show "This file should be rewritten based on vlogic0.jl"

#using Genie
#import Genie.Router: route
#import Genie.Router: @params
#
#global core
#global glid
#global gcid
#global goal
#global lvs
#global goalsigma
#global govars
#global firstview=true


#########
route("/stepgoal") do
 pm = @params()
 global lvs = lvarsof(glid, core)
# global lvs = restrictvars(glid, core)
 σo=[]
 for v in lvs
  try 
    vr = pm[v]
    if v == vr
      push!(σo, v)
    elseif "" == vr
      push!(σo, v)
    else
      push!(σo, Symbol(vr)) 
    end
  catch
    push!(σo, Symbol(v)) 
  end
 end
 if !firstview
   global goalsigma = apply(varsof(gcid,core), goalsigma, σo)
 end

#TODO: 
# 1. remove glid from lids of goal to newglids
# 2. apply σo to newglids
# 3. make the newglids a resolvent in the core with new rid
# 4. show it clauseof(rid, core)
#@show glid,σo,core
nc = factify_clause(glid,σo,core)

if nc == :FAIL
 nrid = :FAIL
 newres = "FAIL"
else 
 nrid = nc[1]
 global core = nc[2]
 score = stringcore(core)
 sres = stringclause(nrid, core)
end

# TODO now, got the new goal
# 1. ask the new glid 
# 2. for the glid, go next step
#  next step is...
#   1) refute by base
#   2) remove executables
#   3) ask by view

 pres = """
 <pre>$(score)</pre>
 <pre>GOAL
 $(sres)
 =======</pre>
 <pre>info: $(stringarray(govars)):=$(stringarray(goalsigma))</pre>
"""

 if 0 == length(lidsof(nrid, core))
  global firstview=true
  form = htmlform("/startlogic", [], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("proof completed"), htmlbody("completed", pres, form))
 else
  form = htmlform("/viewpage", [htmlinput("glid", "glid")], "Confirm", "Cancel") 
  return htmlhtml(htmlheader("select next glit"), htmlbody("step goal", pres, form))
 end
end


route("/viewpage") do
 pm = @params()
 global glid = Symbol(pm[:glid])
 global gcid = cidof(glid, core)

 if firstview
   global goalsigma = varsof(gcid,core)
   global govars = goalsigma
   global firstview = false
 end

 global goal = stringclause(gcid, core)
 global lgoal = stringlid(glid, core)

 inputs = makeinputs(lvarsof(glid,core))
#TODO: lvars be only vars appear sn the literal.
 lvs = restrictvars(glid, core)
# lvs = lvarsof(glid, core)
 svars = "["
 for ix in 1:length(lvs)
  svars *= "$(lvs[ix])"
  ix != length(lvs) && (svars *=",")
 end
 svars *= "]"
 score = stringcore(core)

 pres = """
<pre>$(score)
GATOM:$(svars).$(lgoal)
GLID: $(glid)</pre>

"""
 form = htmlform("/stepgoal", inputs, "Confirm", "Cancel") 
 return htmlhtml(htmlheader("step goal"), htmlbody("step goal", pres, form))

end


route("/readcore") do
 pm = @params()
 corepath = pm[:corepath]
 global core = readcore(corepath)
 glid = lidsof(:C1, core)
 if length(glid) == 1 
  lgoal = literalof(glid[1],core).body.args[2]
 else
  lgoal = []
 end
 clauses = stringclauses(core)
 clist = ""
 for id in reverse(collect(keys(core.cdb)))
   clist *= "$(stringclause(id, core))</br>"
 end

 pres = "<pre>CLAUSES</pre>$(clist)"
 form = htmlform("/viewpage", [htmlinput("glid", "glid")], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Core"), htmlbody("which glit", pres, form))
end


route("/startlogic") do
 form = htmlform("/readcore", [htmlinput("CNF path", "corepath")], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Core selection"), htmlbody("select core", "", form))
end

Genie.AppServer.startup()
==#

