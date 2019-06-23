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
global gvar
global firstview=true

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
 elseif op == "stepgoal"
  return gostepgoal(pm,1)
 elseif op == "stepngoal"
  return gostepgoal(pm,2)
 elseif op == "postview"
  return postview(pm)
 end
end

function goalprover(pm, step, pres)
@show :goalprover, step
 try
@show :after, gid
  rico = evaluategoal(gid, core)
@show :after :evaluategoal
  global core = rico[2]
  global gid = rico[1]
## here gid, core has evaluated clause
## 
@show gid 
@show stringcore(core)
  glids=lidsof(gid, core)
  nlids =  literalsof(glids, core)
@show :goalprover1
@show gid glids 
@show nlids

  if length(nlids) == 0
   return contraview(gid, core)
  else
 # after eval, choose view or resolve in goaftereval?
 # chooselid() in askU select a view literal
   return askU(gid, core, "postview")
  end
 catch e
  if isa(e, VALID)
@show validview
   return validview(gid, core)
  else
@show :unknownview
   return unknownview(gid, e, core)
  end
 end

 form = htmlform("stepgoal", [], "Confirm", "Cancel") 
 return htmlhtml(htmlheader("Step Goal"), htmlbody("Next", pres, form))

end

function gostepgoal(pm,cnt)
@show :gostepgoal, cnt
  score = stringcore(core)
 pres = """
 <pre>$(score)</pre>
 <pre>=======</pre>
"""
 if cnt==1
@show :gostepgoal1
@show pm
try
  global gid = Symbol(pm[:gid])
catch
  @show :continue
end
@show pres
  return goalprover(pm, 1, pres)
 else
@show :gostapgoal2
  return goalprover(pm, 2, pres)
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
@show :postview
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

@show :before_factify_clause
 nid, ncore = factify_clause(glid,σo,core)

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
  return htmlhtml(htmlheader("proof completed"), htmlbody("completed", pres, form))
 else
  form = htmlform("stepgoal", [], "Confirm", "Cancel")
  return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
 end
end


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
 return htmlhtml(htmlheader("Select GID"), htmlbody("which gid", pres, form))
end

function gostarthtml()
@show :gostarthtml
 form = htmlform("readcore", [htmlinput("CNF path", "corepath")], "Confirm", "Cancel")
 return htmlhtml(htmlheader("Core selection"), htmlbody("select core", "", form))
end

Genie.AppServer.startup()


