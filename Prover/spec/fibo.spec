# spec of fibonacci
!gt(x,y)   = x>y
!sub(x,y) = x-y
!add(x,y) = x+y

!INVARS=:[X!]
!OUTVARS=:[Z]

[X!,Z].[-Fibo(X!,Z)]

[].[+Fibo(0,1)]
[].[+Fibo(1,1)]

[i,w1,w2].[-Fibo(sub(i,1),w1),-Fibo(sub(i,2),w2),+Fibo(i, add(w1,w2)),-gt(i,1)]

[x].[+Fibo(x,fibo(x))]


 !pred(x,y) = x-1
 ## in this line, pred(pred(i)) fail
 [i,w1,w2].[-Fibo(pred(i),w1),-Fibo(pred(pred(i)),w2),+Fibo(i, add(w1,w2)),-gt(i,1)]



