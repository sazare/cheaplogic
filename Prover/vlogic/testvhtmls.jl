# test for vhtmls.jl
# vhtmls.jl functions for make html in readable form....

include("vhtmls.jl")

# these are really readable??


# body has many variation. Can i it simply

htmlheader("hihi")

htmlform("/readcore", [htmlinput("CNF path", "corepath")], "confirm", "cancel")
# input may intputs.. and

# how can i write many inputs in simple form?
f1=htmlform("/gothere", [htmlinput("A", "valueA"), htmlinput("B", "valueB")], "OK", "NO")

# this is one input. it may be simple.

htmlinput("CNF path", "corepath")

htmlhtml(htmlheader("My thought"), htmlbody("input values", f1 ))
