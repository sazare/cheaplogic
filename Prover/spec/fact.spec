# spec of factorial
!gt(x,y)   = x>y
 !eq(x,y)   = x==y
!pred(x) = x-1
!prod(x,y) = x*y


!INVARS=:[X!]
!OUTVARS=:[Z]

[X!,Z].[-Fact(X!,Z)]

[].[+Fact(0,1)]
[i,w].[-Fact(pred(i),w),+Fact(i, prod(i,w)),-gt(i,0)]

[x].[+Fact(x,fact(x))]

