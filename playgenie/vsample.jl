# vsample.jl

# function controls view like dialog.


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

global waithtml = Dict{Symbol, String}(:init=>"empty")
global currhtml = nothing
global retpm = nothing

#
# the route /go (Genie issue)
#
route("/jum") do
 pm = @params()
 op = pm[:op]

 if op == "call"
  waitcall()
  return currhtml
 elseif op == "values"
  retpm = waitvalues(pm)
  return retpm
 end # if op
end # route

function waitcall()
 while currhtml == nothing;sleep(1) end
 return currhtml 
end

function waitvalues(pm)
 global currhtml = nothing
 return pm
end

#Genie issue
#Genie.AppServer.startup()


# <head xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\">
"""
htmlhtml(header, body) simply concatenates 2 htmls.
"""
function htmlhtml(header, body)
"""
$header
$body
"""
end

"""
htmlheader(title) makes head part with title
"""
function htmlheader(title)
"""
<head xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\">
<meta http-equiv=\"Content-Language\" content=\"Japanese\"/>
<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />
<style type="text/css">
<!--
input { width: 200pt; }
-->
</style>
<title>$title</title></head>
"""
end


"""
htmlbody(h1, pres, form) makes <h1> and pres, form
"""
function htmlbody(h1, pres, form)
"""
<h1>$h1</h1>
$pres
$form
</body></html>
"""
end

"""
htmlform(op, fields, confirm, cancel) makes a simple form
next target is op
generates input tags by fields
submit, reste with value confirm, cancel respectively
"""
function htmlform(op, fields, confirm, cancel)
 inputs = ""
 for f in fields
  inputs *= f
 end

"""
<form action=\"/jum\" method=\"get\">
<input type=\"hidden" name=\"op\" value=\"$op\"></br>
$(inputs)
<input type=\"submit\" value=\"$confirm\"></br>
<input type=\"reset\" value=\"$cancel\">
</form>
"""
end

"""
htmlinput(key, name) makes input tags
""" 
function htmlinput(key, name)
"""
<div>$key : <input type=\"text\" name=\"$name\"></div>
"""
end

"""
makeinputs(vars)
"""
function makeinputs(vars)
# TODO: [X,Y] := [a,Y] then input of X has value a, of Y has none
 bb = ""
 for v in vars
   bb = bb * "<p><span>$(v):</span><input type=\"text\" name=\"$(string(v))\" size=\"40\"></p>"
 end
 bb
end

"""
makeView(glid, core) makes a view for a canonical literal for the glid is a cano
"""
function makeView(glid, core)
 (sign, psym) = psymof(glid, core)
 glit         = literalof(glid, core).body
 gvars        = cvarsof(glid, core)
 if psym in keys(core.cano)
  (cavars, catom) = core.cano[psym]
  return makeinputs2(cavars,gvars,glit.args[2].args[2:end])
 else
  return "no View for $(psym)"
 end
end

"""
makeinputs2(cavars, vars, gargs) makes a view for input with value dependent on vars
"""
function makeinputs2(cavars, vars, gargs)
@info :makeinputs2
 bb = ""
 for ix in 1:length(cavars)
   v  = cavars[ix]
   tm = gargs[ix]

# this is not enough. 
   if isvar(tm, vars)
    bb = bb * "<p><span>$(v):</span><input type=\"text\" name=\"$(string(v))\" size=\"40\"></p>"
   else
    bb = bb * "<p><span>$(v):</span><input type=\"text\" name=\"$(string(v))\" value=\"$(tm)\" size=\"40\"></p>"
   end
 end
 bb
end

"""
makeView2(op, glid, ovarc, varg, argg) makes a view with values appropriate
"""
function makeView2(op, glid, ovarc, varg, argg)
@info :makeView2
 inputs = makeinputs2(ovarc, varg, argg)
"""
<h2>GLID: $glid</h2>
<form action=\"/jum\" method=\"get\">
<input type=\"hidden" name=\"op\" value=\"$op\"></br>
$(inputs)
<input type=\"submit\" name=\"how\" value=\"confirm\"></br>
<input type=\"submit\" name=\"how\" value=\"abort\"></br>
<input type=\"reset\"  value=\"cancel\">
</form>
"""
end

"""
makepres make <pre>sequence
"""
function makepres(pres::Array)::String
 spres = ""
 for pre in pres
  spres *= "<pre>$pre</pre>"
 end
 return spres
end

"""
joker() control over web transitions
"""
function joker()
 
 first()
 secont()
 third()
end

#==
 this function set currhtml to show web page
 get pm 


==#

function first()
htmlhtml(
 htmlheader("HI"), 
 htmlbody("OO", "", 
  htmlform("values/op=values", ["x"], "ok", "retry")))
end

