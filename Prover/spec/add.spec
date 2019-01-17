# spec of add 
!println("... add.spec in progress")

!gt(x,y)   = x>y
!succ(x) = x+1
!pred(x) = x-1

!INVARS=:[X!,Y!]
!OUTVARS=:[Z]

[X!,Y!,Z].[-Add(X!,Y!,Z)]

[u].[+Add(u,j,u),+gt(j,0)]
[i,j,w].[-Add(i,pred(j),w),+Add(i,j,succ(w)),-gt(j,0)]

[x].[+Add(x,add(x))]

