# viewlogic.jl

# in considering the new style

# targetを1つにしてsessionを作って、opcodeで分岐する
# こうすれば、処理が近くにかけるのでは?
# 処理のloopをViewなしで実行できるようにする
#  viewのかわりのaxiomが選べる
#   canoのliteralをランダムに生成する
#   その結果できるσoをランダムに生成する
# 




#using Genie
#import Genie.Router: route
#import Genie.Router: @params

#global core
#global glid
#global gcid
#global goal
#global lvs
#global goalsigma
#global govars
#global firstview=true




#==
#########
route("/newgoal") do
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


function makeinputs(vars)
# TODO: [X,Y] := [a,Y] then input of X has value a, of Y has none
# TODO: standard lit needed when constant be a var 
 bb = ""
 for v in vars 
   bb = bb * "<p><span>$(v):</span><input type=\"text\" name=\"$(string(v))\" size=\"40\"></p>"
 end
 bb
end

function restrictvars(lid, core)
  fitting_vars(varsof(cidof(lid,core), core), [literalof(lid,core).body], core)
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
 form = htmlform("/newgoal", inputs, "Confirm", "Cancel") 
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

