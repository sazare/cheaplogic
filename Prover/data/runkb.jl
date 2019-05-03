c0=readcore("data/kb003.cnf")
r1,c1=simpleprover("data/kb001.cnf",5,3)
r2,c2=simpleprover("data/kb002.cnf",5,3)
r3,c3=simpleprover("data/kb003.cnf",5,3)

printcore(c3)
printproofs1(c3)
printmgus(c3)

