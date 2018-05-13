
for cid in ls("^c")
 !isa(eval(cid), CORE) && continue
 println("$cid = $(length(contradictionsof(eval(cid))))")
end
println()


