# vlogic0 is many targets version first one
# original

include("load_cheaplogic.jl")

include("vlogic/viewreso.jl")

#this dosn't work
include("vlogic/vhtmls.jl")

# factify.jl is for first genie based system
include("vlogic/factify.jl")

@show "dont work ∵ vhtmls.jl dont fit to vlogic.jl"
include("vlogic/vlogic.jl")
