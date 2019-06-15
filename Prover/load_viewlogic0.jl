# vlogic0 is single target go version
#same as vlogic.jl

include("load_cheaplogic.jl")

include("vlogic/viewreso.jl")
include("vlogic/vhtmls.jl")

# factify.jl is for first genie based system
include("vlogic/factify.jl")

include("vlogic/vlogic0.jl")
