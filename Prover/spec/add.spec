# spec of add 

!gt(x,y)= x>y
!succ(x)= x+1
!pred(x)= x-1

!INVARS=:[X!,Y!]
!OUTVARS=:[Z]

[X!,Y!,Z].[-Add(X!,Y!,Z)]


[i].[+Add(i,0,i)]
[j].[+Add(0,j,j)]
[i,w].[-Add(pred(i),0,w),+Add(i,0,succ(w)),-gt(i,0)]
[i,j,w].[-Add(i,pred(j),w),+Add(i,j,succ(w)),-gt(i,0),-gt(j,0)]

[x,y].[+Add(x,y,add(x,y))]

