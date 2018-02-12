# sample data

c0=parse("+P(x)") 
c1=parse("-P(x),+P(f(x))") 
c2=parse("-P(x),+Q(x,y),+R(y)")
c3=parse("-P(x),+R(g(x))")
c4=parse("-Q(a,g(b))")
c5=parse("+R(g(x))")
c6=parse("+R(f(x))")


pr1=[makeastep(:resolution, [:x], parse("[+P(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], EmptyClause, [:a]),
 makeastep(:reduction, [:x], parse("[+P(x,a),+P(x,x)]"), 1, 2, parse("[+P(a,a)]"), [:a])
]

pr2=[
makeastep(:resolution, [:x], parse("[+P(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], EmptyClause, [:a]),
makeastep(:resolution, [:x], parse("[+P(x,a),+Q(x,a)]"), 1, [:x], parse("[-P(x,x)]"),1, [:v], parse("[+Q(a,a)]"), [:a]),
makeastep(:reduction, [:x], parse("[+P(x,a),+P(x,x)]"), 1, 2, parse("[+P(a,a)]"), [:a])
]

cls1 = [
 parse("[x,y].[+P(x),+Q(x,y)]"),
 parse("[y,x].[+P(a),-Q(x,y)]"),
 parse("[x,y].[+Q(x,x),-P(x)]"),
 parse("[].[-P(b)]"),
 parse("[x].[-P(x)]"),
 parse("[x].[-Q(x,x)]")
]

cls2 = [
 parse("[x,y].[+P(x),+Q(x,y)]"),
 parse("[y,x].[+P(a),-Q(x,y)]"),
 parse("[x,y].[+Q(x,x),-P(x)]"),
 parse("[].[-P(b),+Q(b,b)]"),
 parse("[x].[-P(x),+Q(x,x)]")
]

cls3 = [
 parse("[x,y].[+Q(x,x),+R(x),-P(x),+R(x)]"),
 parse("[y,x].[+P(a),-R(a),-Q(x,y),-R(a)]"),
 parse("[x].[-P(b),+R(b),+R(x),+Q(b,b)]"),
 parse("[x,y].[+P(x),+Q(x,y),-R(x),-R(y)]"),
 parse("[y,x].[+P(a),-Q(x,y),-R(a)]"),
 parse("[x,y].[-P(x),+Q(x,x),+R(x,f(a)),+R(x,y)]")
]

res1=[
 parse("[y].[+Q(b,y)]"),
]

# 0 means contradiction :([])

cdb1=addcdb([],vcat(cls1,res1))
db1=makedb(vcat(cls1,res1))

ipr1=[
 makeastep(:resolution,[:x],4,1,[:x,:y],1,1,[:y],7, [:b,:y]),
 makeastep(:resolution,[:x],7,1,[:y],6,1,[],     0, [:b,:y])
]

cdb2=addcdb([],cls2)
db2=makedb(cls2)
cdb3=addcdb([],cls3)
db3=makedb(cls3)


#==
# Image 
==#
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


