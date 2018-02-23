#misc.jl has misceranious functions

macro nyi(name)
 return:(println("Not yet implemented ", $name))
end

