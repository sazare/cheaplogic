rdata000,cdata000=simpleprover("data/data000.cnf",2,2)
rdata000a,cdata000a=simpleprover("data/data000a.cnf",2,2)
r20Q01,c20Q01=simpleprover("data/20Q01.cnf",5,2)
rdata001,cdata001=simpleprover("data/data001.cnf",3,5)
rdata002,cdata002=simpleprover("data/data002.cnf",3,5)
rdata003,cdata003=simpleprover("data/data003.cnf",3,5)
rdata004,cdata004=simpleprover("data/data004.cnf",5,2)
rdata005,cdata005=simpleprover("data/data005.cnf",5,5)
rdata006,cdata006=simpleprover("data/data006.cnf",5,2)
rdata007,cdata007=simpleprover("data/data007.cnf",15,5)
rdata008,cdata008=simpleprover("data/data008.cnf",3,5)
rdata010,cdata010=simpleprover("data/data010.cnf",5,2)
rdata011,cdata011=simpleprover("data/data011.cnf",5,2) #0
rdata012,cdata012=simpleprover("data/data012.cnf",5,2) #0
rdata013,cdata013=simpleprover("data/data013.cnf",5,2) #0
rdata014,cdata014=simpleprover("data/data014.cnf",5,2) #0
# if config.jl has evalon=true, then 15 make 1[], else 0[]
rdata015,cdata015=simpleprover("data/data015.cnf",5,2)
rdata016,cdata016=simpleprover("data/data016.cnf",5,2)
rdata017,cdata017=simpleprover("data/data017.cnf",5,2)
rdata018,cdata018=simpleprover("data/data018.cnf",10,4)
rdata019,cdata019=simpleprover("data/data019.cnf",5,5)
rdata020,cdata020=simpleprover("data/data020.cnf",5,1)
rdata021,cdata021=simpleprover("data/data021.cnf",5,2)
rdata022,cdata022=simpleprover("data/data022.cnf",3,1) #1
rdb1,cdb1=simpleprover("data/db1.cnf",5,2)
reveryonedie,ceveryonedie=simpleprover("data/everyonedie.cnf",5,2)
rfriend1,cfriend1=simpleprover("data/friend1.cnf",5,2) 
rfriend2,cfriend2=simpleprover("data/friend2.cnf",5,2)
rfriend3,cfriend3=simpleprover("data/friend3.cnf",5,1)
rfriend4,cfriend4=simpleprover("data/friend4.cnf",5,2)
rfriend41,cfriend41=simpleprover("data/friend41.cnf",5,2)
rfriend5,cfriend5=simpleprover("data/friend5.cnf",5,2)
rfriend6,cfriend6=simpleprover("data/friend6.cnf",5,2) 
rfriend7,cfriend7=simpleprover("data/friend7.cnf",5,5) #9 []?
rfriend8,cfriend8=simpleprover("data/friend8.cnf",5,5) #8 [] ?
rfriend9,cfriend9=simpleprover("data/friend9.cnf",15,2) #0
rhave001,chave001=simpleprover("data/have001.cnf",7,1)
rhave002,chave002=simpleprover("data/have002.cnf",7,1)
rid1,cid1=simpleprover("data/id1.cnf",5,2)
rid2,cid2=simpleprover("data/id2.cnf",5,2) # 0
rid3,cid3=simpleprover("data/id3.cnf",5,2) # 2
rid4,cid4=simpleprover("data/id4.cnf",5,2) # 0
rimplya,cimplya=simpleprover("data/implya.cnf",5,2) #2
rimplyn,cimplyn=simpleprover("data/implyn.cnf",5,2) #1
rkuukai,ckuukai=simpleprover("data/kuukai.cnf",5,2) #1
rkuukai2,ckuukai2=simpleprover("data/kuukai2.cnf",5,2)
###
rmagia,cmagia=simpleprover("data/magia.cnf",5,2)


#rml001,cml001=simpleprover("data/ml001.cnf",5,2) # inpro
### from here, cheaplogic and naivelogic are different 
rml002,cml002=simpleprover("data/ml002.cnf",5,2)  # evalon
rml003,cml003=simpleprover("data/ml003.cnf",5,2)  # evalon
rml004,cml004=simpleprover("data/ml004.cnf",5,2)  # evalon
rml005,cml005=simpleprover("data/ml005.cnf",5,2)  # evalon
rml006,cml006=simpleprover("data/ml006.cnf",6,2)  # evalon #1[] determined img3 battle. but no others. 
rml007,cml007=simpleprover("data/ml007.cnf",50,20)  # evalon #5[] can't determin img3. 50 steps no effect. contralimit=20 needed
rml007a,cml007a=simpleprover("data/ml007a.cnf",50,20)  # evalon #5[] can't determin img3. 50 steps no effect. contralimit=20 needed
rml007b,cml007b=simpleprover("data/ml007b.cnf",50,20)  # evalon #5[] can't determin img3. 50 steps no effect. contralimit=20 needed
rml007c,cml007c=simpleprover("data/ml007c.cnf",50,20)  # evalon #5[] can't determin img3. 50 steps no effect. contralimit=20 needed
rml008,cml008=simpleprover("data/ml008.cnf",15,2)  # evalon 

#rproblogic0,cproblogic0=simpleprover("data/problogic0.cnf",5,2)

rprop001,cprop001=simpleprover("data/prop001.cnf",5,2)

rtime,ctime=simpleprover("data/time.cnf",5,2) # unless repeat check, infinitely loop

rtime2,ctime2=simpleprover("data/time2.cnf",50,2)
rtime3,ctime3=simpleprover("data/time3.cnf",50,2)
rto1,cto1=simpleprover("data/to1.cnf",5,2)
rto2,cto2=simpleprover("data/to2.cnf",5,2)
rto3,cto3=simpleprover("data/to3.cnf",5,2)
rto4,cto4=simpleprover("data/to4.cnf",5,2)

rser001,cser001=simpleprover("data/ser001.cnf",5,2)
rpar001,cpar001=simpleprover("data/par001.cnf",10,2) # too many proofs free for y

rhis001,chis001=simpleprover("data/his001.cnf",10,5)
rhis002,chis002=simpleprover("data/his002.cnf",10,5)

rjp1,cjp1=simpleprover("data/jp001.cnf",2,2)

#rpprop001,cpprop001=simpleprover("data/pprop001.cnf",5,2)
rprob00,cprob00=simpleprover("data/prob00.cnf",5,2) # 2[] 2ways found
rprob01,cprob01=simpleprover("data/prob01.cnf",5,4) # intrinsic 3[]in 7  2ways found
rpar002,cpar002=simpleprover("data/par002.cnf",10,5)

rdop001,cdop001=simpleprover("data/dop001.cnf",10,10) # contralimit must > 5
rident001,cident001=simpleprover("data/ident001.cnf",5,5) # identity 
rident002,cident002=simpleprover("data/ident002.cnf",5,5) # identity with near time 

#### end of dirrerent results

# case: Circuit trouble
# 001 answer the reason swich on but not lamp glow.
rcirc001,ccirc001=simpleprover("data/circ001.cnf",2,2) # 
# 002 this model swith, power, lamp and wire. same query
rcirc002,ccirc002=simpleprover("data/circ002.cnf",3,3) # 
# 003 knowledges are general
rcirc003,ccirc003=simpleprover("data/circ003.cnf",3,3) # 
# 004 knowledges are general
rcirc004_5a,ccirc004_5a=simpleprover("data/circ004a.cnf",5,5) # 
rcirc004_5b,ccirc004_5b=simpleprover("data/circ004b.cnf",5,5) # 
rcirc004_5b2,ccirc004_5b2=simpleprover("data/circ004b2.cnf",5,5) # 
rcirc004_5c,ccirc004_5c=simpleprover("data/circ004c.cnf",5,5) # 
rcirc004_5d,ccirc004_5d=simpleprover("data/circ004d.cnf",5,5) # 
rcirc004_5e,ccirc004_5e=simpleprover("data/circ004e.cnf",5,5) # 

rcirc004_5,ccirc004_5=simpleprover("data/circ004.cnf",5,5) # 

# circuit problem 
rce1,cce1=simpleprover("data/cire001.cnf",7,7)

