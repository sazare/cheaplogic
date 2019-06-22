# vhtmls.jl


function restrictvars(lid, core)
  fitting_vars(varsof(cidof(lid,core), core), [literalof(lid,core).body], core)
end



function htmlhtml(header, body)
"""
<head xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"ja\">
$header
$body
"""
end

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

function htmlbody(h1, pres, form)
"""
<h1>$h1</h1>
$pres
$form
</body></html>
"""
end

function htmlform(op, fields, confirm, cancel)
 inputs = ""
 for f in fields
  inputs *= f
 end

"""
<form action=\"/go\" method=\"get\">
<input type=\"hidden" name=\"op\" value=\"$op\"></br>
$(inputs)
<input type=\"submit\" value=\"$confirm\"></br>
<input type=\"reset\" value=\"$cancel\">
</form>
"""
end
 
function htmlinput(key, name)
"""
<div>$key : <input type=\"text\" name=\"$name\"></div>
"""
end

function makeinputs(vars)
# TODO: [X,Y] := [a,Y] then input of X has value a, of Y has none
 bb = ""
 for v in vars
   bb = bb * "<p><span>$(v):</span><input type=\"text\" name=\"$(string(v))\" size=\"40\"></p>"
 end
 bb
end

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


function makeinputs2(cavars, vars, gargs)
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

function makeView2(op, glid, ovarc, varg, argg)
 inputs = makeinputs2(varc, varg, argg)
"""
<h2>GLID: $glid</h2>
<form action=\"/go\" method=\"get\">
<input type=\"hidden" name=\"op\" value=\"$op\"></br>
$(inputs)
<input type=\"submit\" value=\"$confirm\"></br>
<input type=\"reset\" value=\"$cancel\">
</form>
"""
end


