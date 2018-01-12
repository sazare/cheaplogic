# Image 

# input
Cls1 = [
 parse("[x].[+P(x),+Q(x)]"),
 parse("[x].[+P(a),-Q(x)]"),
 parse("[x].[+Q(x),-P(x)]"),
 parse("[].[-P(b)]"),
 parse("[x].[-P(x)]")
]

# cid : index of Cls

#==
 PG,sign,pred => (cid,lid) => literal
 CDB,cid -> [1] == vars
 CDB,cid -> [2] == literals
==#

# cid is the index of CDB1 also
CDB1=[
 ([:x],parse("[+P(x),+Q(x)]")),
 ([:x],parse("[+P(a),-Q(x)]")),
 ([:x],parse("[+Q(x),-P(x)]")),
 (Array{Symbol}([]),parse("[-P(b)]")),
 ([:x],parse("[-P(x)]"))
]


LDB1=Dict((1,1)=>(parse("+P(x)")),
        (1,2)=>(parse("+Q(x)")),
        (2,1)=>(parse("+P(a)")),
	(2,2)=>(parse("-Q(x)")),
	(3,1)=>(parse("+Q(x)")),
	(3,2)=>(parse("-P(x)")),
	(4,1)=>(parse("-P(b)")),
	(5,1)=>(parse("-P(x)")) 
)

PG1 = Dict(
   :P => [[(1,1),(2,1)],[(3,2),(4,1),(5,1)]],
   :Q => [[(1,2),(3,1)],[(2,2)]]
)


# Cls1[2].args[1].args::Vlist # vars
# Cls1[2].args[2]::Expr # clause
# Cls1[2].args[2].args[1]::Expr # clause
# Cls1[1].args[2].args[1].args[1] # Literal1
# Cls1[1].args[2].args[1].args[2] # Literal2
# Cls1[1].args[2].args[1].args[1].args[1] # sign
# Cls1[1].args[2].args[1].args[1].args[2] # Atom
# Cls1[1].args[2].args[1].args[1].args[2].args # decomposed form


# Lit1[(1,1)][1] :: Vlist
# Lit1((1,1)][2].args ::Expr
# Lit1((1,1)][2].args[1] ::sign
# Lit1((1,1)][2].args[2] ::Expr(Atom)

# vars empty check: isempty(Cls1[4].args[1].args)

# literal count: map(x->length(x[2].args),CDB1)

# (cid,lid) : (1,2)
#CDB1[cid][1] = vars
#CDB1[cid][2].args[lid] = literal
#CDB1[cid][2].args[lid].args[1] = sign::Sign{+,-}
#CDB1[cid][2].args[lid].args[2] = Atom::Expr

#CDB1[1][2] # literals
#CDB1[1][2].args[1] # literal
#CDB1[1][2].args[2] # literal
#CDB1[1][2].args[2].args[1] # sign::Symbol{+,-}
#CDB1[1][2].args[2].args[2] # atom::Expr






include("testcgop.jl")
db3=makedb(cls3)

