# spec of id
# this fail to make a program
# bug: id(x-1) is regarded as IDaxiom

<spec/common.fun


!INVARS=:[X!]
!OUTVARS=:[Z]

[X!,Z].[-ID(X!,Z)]

[].[+ID(0,1)]
[i,w].[-ID(pred(i),w),+ID(i, w),-gt(i,0)]

[x].[+ID(x,id(x))]

