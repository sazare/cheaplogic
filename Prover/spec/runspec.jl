#df,cf,bf,ins,ons=lps_prover("spec/fact.spec", 3,3)

df,cf,bf,eisf,insf,onsf=lps("spec/fact.jl", "spec/fact.spec", :fact, 3,3)
db,cb,bb,eisb,insb,onsb=lps("spec/fibo.jl", "spec/fibo.spec", :fibo, 4,4)
d1,c1,b1,eis1,ins1,ons1=lps("spec/id.jl", "spec/id.spec", :id, 3,3)

