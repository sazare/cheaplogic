c0=readcore("kbdata/kb003.cnf")
r1,c1=simpleprover("kbdata/kb001.cnf",5,3)
r2,c2=simpleprover("kbdata/kb002.cnf",5,3)
r3,c3=simpleprover("kbdata/kb003.cnf",5,3)

printcore(c3)
printproofs1(c3)
printmgus(c3)

