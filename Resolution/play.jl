## real data
include("loadall.jl")

madoka=readclausefromfile("madoka.def")
madodb=makedb(madoka)
printdb(madodb)
