## sample prooving script

nc1=[X].[-P(X)]
nc2=[X].[-P(f(X))]

a1=[].[+P(a)]
a2=[].[+P(f(a))]
a3=[].[+P(f(f(a)))]

ax1=[a1,a2,a3]

conf=(ndepth=12, ncont=3]

rc1=refute(nc1, ax1, conf)
rc2=refute(nc2, ax1, conf)

printcore(rc1)
printcore(rc2)
printproofs(rc1)
printproofs(rc2)

print(:X, rc1) # print info concerns :X in rc1

## problem:
# 1. rc1 and rc2 are not corresponding. 2 refutes are independent...
# 2. It may be useful to use the resolvents of 1st refute(rc1). as...
   rc2=refute(nc2, ax1, conf, rc1)

