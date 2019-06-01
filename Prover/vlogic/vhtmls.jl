# vhtmls.jl

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

function htmlform(action, fields, confirm, cancel)
 inputs = ""
 for f in fields
  inputs *= f
 end

"""
<form action=\"$action\" method=\"get\">
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

