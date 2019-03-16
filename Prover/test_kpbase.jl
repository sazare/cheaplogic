using Test

@testset "kpconv" begin
 @test kpequal(KPExpr(:f, Dict{Symbol,Any}(:a=>:b)), kpconv(:(f(a=b))))
 @test kpequal(KPExpr(:f, Dict{Symbol,Any}(:a=>:b,:c=>:(f(x)))), kpconv(:(f(c=f(x),a=b))))

 @test :(f()) == kpconv(:(f()))
 @test :(f(x)) == kpconv(:(f(x)))
end


@testset "kpapply" begin
 @test kpequal(kpconv(:(好き(ha=僕, ga=君))), kpapply([:x], kpconv(:(好き(ha=僕, ga=君))), [:誰]))
 @test kpequal(kpconv(:(好き(ha=僕, ga=誰))), kpapply([:x], kpconv(:(好き(ha=僕, ga=x ))), [:誰]))

 @test kpequal(kpconv(:(好き(ha=僕, ga=f(誰)))), kpapply([:x], kpconv(:(好き(ha=僕, ga=x ))), [:(f(誰))]))
 @test kpequal(kpconv(:(好き(ha=僕(h(花子)), ga=f(誰)))), kpapply([:x,:y], kpconv(:(好き(ha=僕(y), ga=x ))), [:(f(誰)),:(h(花子))]))

end

@testset "kp unify" begin
 @test [] ==  kpunify([], kpconv(:(f())), kpconv(:(f())))
 @test [] ==  kpunify([], kpconv(:(f(x))), kpconv(:(f(x))))
 @test [:x] ==  kpunify([:x], kpconv(:(f(x))), kpconv(:(f(x))))
 @test [] ==  kpunify([], kpconv(:(f(a=x))), kpconv(:(f(a=x))))

 @test [:x] ==  kpunify([:x], kpconv(:(f(a=x))), kpconv(:(f(a=x))))
 @test [:k] ==  kpunify([:x], kpconv(:(f(a=x))), kpconv(:(f(a=k))))
 @test [:k] ==  kpunify([:x], kpconv(:(f(a=k))), kpconv(:(f(a=x))))
 @test_throws ICMP kpunify([:x], kpconv(:(f(a=k))), kpconv(:(f(a=p))))

 @test [:k] ==  kpunify([:x], kpconv(:(f(a=(f(x))))), kpconv(:(f(a=(f(k))))))

 @test [:(g(k))] ==  kpunify([:y], kpconv(:(f(a=y))), kpconv(:(f(a=g(k)))))
 @test [:(g(k))] ==  kpunify([:y], kpconv(:(f(a=(f(y))))), kpconv(:(f(a=f(g(k))))))
 @test [:(g(k)),:k] ==  kpunify([:y,:w], kpconv(:(f(a=f(k,y)))), kpconv(:(f(a=f(w,g(w))))))

 @test [] == kpunify([], kpconv(:(f(a=x,b=y))), kpconv(:(f(a=x,b=y))))
 @test [:x,:y] == kpunify([:x,:y], kpconv(:(f(a=x,b=y))), kpconv(:(f(a=x,b=y))))
 @test [:p,:q] == kpunify([:x,:y], kpconv(:(f(a=x,b=y))), kpconv(:(f(a=p,b=q))))

 @test_throws ICMP kpunify([:x], kpconv(:(f(a=x,b=x))), kpconv(:(f(a=p,b=q))))

 @test [:p,:(f(p))] == kpunify([:x,:y], kpconv(:(f(a=x,b=f(x)))), kpconv(:(f(a=p,b=y))))
 @test_throws ICMP kpunify([:x,:y], kpconv(:(f(a=x,b=g(x)))), kpconv(:(f(a=p,b=g(q)))))
 @test_throws ICMP kpunify([:x,:y], kpconv(:(f(a=x,b=g(x)))), kpconv(:(f(a=p,b=h(y)))))
 @test [:p,:p] == kpunify([:x,:y], kpconv(:(f(a=g(x),b=h(x)))), kpconv(:(f(a=g(p),b=h(y)))))
 @test [:(g(p)),:(g(p))] == kpunify([:x,:y], kpconv(:(f(a=g(x),b=h(x)))), kpconv(:(f(a=g(g(p)),b=h(y)))))
 @test [:p,:p] == kpunify([:x,:y], kpconv(:(f(a=x,b=x))), kpconv(:(f(a=y,b=p))))
 @test [:p,:p] == kpunify([:x,:y], kpconv(:(f(a=y,b=y))), kpconv(:(f(b=p, a=x))))
 @test [:p,:p] == kpunify([:x,:y], kpconv(:(f(a=x,b=x))), kpconv(:(f(b=p, a=y))))

 @test [:k, :k, :(h(k,k)), :(p(k))] == kpunify([:x,:y,:z,:w], kpconv(:(f(a=x, b=g(h(x,y),y), c=p(y)))), kpconv(:(f(a=k, b=g(z,k),c=w))))
 @test [:p,:p] == kpunify([:x,:y], kpconv(:(f(a=x,b=x))), kpconv(:(f(a=p,b=y))))
 @test [:k, :k, :p] == kpunify([:x,:y,:z], kpconv(:(f(a=x, b=g(p,y)))), kpconv(:(f(a=k, b=g(z,k)))))
 @test [:k, :k, :(h(k,k))] == kpunify([:x,:y,:z], kpconv(:(f(a=x, b=g(h(x,y),y)))), kpconv(:(f(a=k, b=g(z,k)))))
 @test [:x, :k, :(h(x,k))] == kpunify([:x,:y,:z], kpconv(:(f(d=x, b=g(h(x,y),y)))), kpconv(:(f(a=k, b=g(z,k),c=:(g(x))))))

# common key args only unified
 @test [:k, :k, :(h(k,k))] == kpunify([:x,:y,:z], kpconv(:(f(a=x, b=g(h(x,y),y)))), kpconv(:(f(a=k, b=g(z,k),c=:(g(x))))))

println()
println("HERE")


end

