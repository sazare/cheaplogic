push!(LOAD_PATH, ".")
#==
ls2()=names(current_module())
ls1()=begin map(x->println(x),ls());[] end
==#

function matchpath(x, r)
  mm = match(r, string(x))
  mm isa RegexMatch
end

function ls(pat="")
 nms = names(current_module()) 
 ixs = find(x->matchpath(x, Regex(pat)),nms)
 nms[ixs]
end

function ls1(pat="")
 map(x->println(x),ls(pat))
 println()
end

