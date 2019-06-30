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

#include("factify.jl")

global core
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
@show op
 if op == "start"
@show :start
  return gostart()
 elseif op == "readcore"
@show :readcore
  return goreadcore(pm)
 elseif op == "stepgoal"
  @show :stepgoal
  if gid == :nogid
@show :nogid
   global gid = pm[:gid]
   return goevaluate(pm,gid)
  else
@show gid
   return goevaluate(pm,gid)
  end
 elseif op == "postview"
  return postview(pm)
 end
end

function goalprover(pm, pres)
@show :goalprover
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
   askpage =  askU(gid, core, "postview")
   if askpage != nothing
     return askpage
   else
     return failview(gid, core)
   end
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

function goevaluate(pm,gid0)
@show :goevaluate, gid0
  score = stringcore(core)
 pres = """
 <pre>$(score)</pre>
 <pre>=======</pre>
"""
@show :goevaluate1
@show pm
try
  global gid = Symbol(gid0)
catch
  @show :continue
end

@show pres
  page = goalprover(pm, pres)
@show page
  return page
end

function contraview(cid, core)
   cls = stringclause(cid, core)
   return htmlhtml(htmlheader("Contradiction"), 
                  htmlbody("$cls is Contradiction", "",""))
end

function validview(cid, core)
  form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
  return htmlhtml(htmlheader("Valid"), 
                  htmlbody("$cls is valid", "",form))
end

function unknownview(cid, except, core)
  form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
  return htmlhtml(htmlheader("Exception occurs"), 
                  htmlbody("$cls makes  $(except)", "",form))
end

function failview(cid, core)
  form = htmlform("start", [], "Confirm", "Cancel")
  cls = stringclause(cid, core)
  return htmlhtml(htmlheader("Fail attempt"), 
                  htmlbody("$cls cant progress more", "",form))
end

function goaftereval(pm)
@show :goaftereval :nodef
end

function postview(pm)
@show :postview
#temporalily view only
 global varg = lvarsof(glid, core)
 global gatm = literalof(glid, core).body.args[2]
# global varg = restrictvars(glid, core)
 global varc = canovarsof(glid,core)
 global catm = canoof(glid,core)[2]

@show :restvarg

 σo=[]
@show pm
@show varg
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
@show σo

@show :beforeapply varc catm σo
 catm2= apply(varc, catm, σo)
@show :beforeunify varg gatm catm2
 σg = unify(varg, gatm, catm2)

@show :before_factify_clause
@show glid σo σg 
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
           htmlbody("completed", pres, form))
  else
   form = htmlform("stepgoal", [], "Confirm", "Cancel")
   return htmlhtml(htmlheader("next glit"), htmlbody("step goal", pres, form))
  end
 catch e
  return validview(gid, core)
 end
end


function goreadcore(pm)
@show :goreadcore
 corepath = pm[:corepath]
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
@show :gostart
 resetglobals()
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


