using Base.Test

include("cgop.jl")


cls1 = [
 parse("[x,y].[+P(x),+Q(x,y)]"),
 parse("[y,x].[+P(a),-Q(x,y)]"),
 parse("[x,y].[+Q(x,x),-P(x)]"),
 parse("[].[-P(b)]"),
 parse("[x].[-P(x)]")
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

@testset "makecdb" begin
 cdb1 = []

 cdb2 = makecdb(cdb1,cls1[1])
 @test cdb2[1] == ([:x,:y], parse("[+P(x),+Q(x,y)]"))
 cdb3 = makecdb(cdb2,cls1[4])
 @test cdb3[2] == ([], parse("[-P(b)]"))

end

@testset "makeldb" begin
 ldb1 = Dict()
 ldb2 = makeldb(ldb1, 2, cls1[2])
 @test ldb2[(2,1)] == parse("+P(a)")
 @test ldb2[(2,2)] == parse("-Q(x,y)")
end

@testset "makepgr" begin
 ldb = Dict()
 ldb = makeldb(ldb, 1, cls1[1])
 gr1 = makepg(ldb)

end

@testset "makedb" begin
 resdb= makedb(cls1)

 @test length(resdb.cdb) == 5
 @test length(values(resdb.ldb)) == 8
 @test length(keys(resdb.pgr)) == 2
 @test length(values(resdb.pgr)) == 2

 @test getvars(resdb.cdb,1) == [:x,:y]
 @test getvars(resdb.cdb,4) == []

 @test litcounts(resdb.cdb) == [2,2,2,1,1]

 @test getlit(resdb.cdb,(2,2)) == (:-, parse("Q(x,y)"))

end

@testset "putclause" begin
 rdb1= makedb(cls1)
 rdb2= makedb(cls2)

 @test findunit(rdb1.cdb) == [4,5]
 @test findunit(rdb2.cdb) == []
end

@testset "putcdb" begin

end

@testset "putldb" begin

end

@testset "putpgr" begin

end

