include("load_reactlogic.jl")

c0 = readcore("kbdata/kb001.cnf", 2) ## cidをC2から作る

#==
in data0.cnf
[who,age,where,what,system].[+Complete(who, age, where, what, system),-User(who, age, where), -Page(what, system)]
==#

printcore(c0)

g1, c1 = addgoal("[WO, A, WR, WA, SY].[-Complete(WO, A, WR, WA, SY)]", c0)

#g1は第一引数のclauseをc0に追加したときのcid

#あるいは
#g1 = makegoal("[WO, A, WR, WA, SY].[-Complete(WO, A, WR, WA, SY)]")
#c0 = addfact(g1, c0)
# g1はcoreと無関係に定義できるのか??

# 複数のgoalに分裂したあとの話はどうするか・・・

rs,c2=dostep(g1, c1)
# 
g1とc1のgoal以外のclauseを適用して、できたresolventすべてをrsにかえす
それを含むcore c2を返す。

★ COREにgoalsを追加する。これらはinput clause扱いだが
 指定されたgoalのselecter としてのみ使われ、resolutionの対象としては使わない。

# this run after the new fact made

# add new fact
g, c2 = addfact("[].[+User(omura, 63, Kanazawa)]", c1)
gには追加したgoalのidを返す

# try refute g1
g2,c3 = stepgoal(g1, c2) # final resolvent of g1 with c2
# g2 is resolvents of g1, c2 and c3は新しいcoreでg2を含む
# g2が複数のclauseの場合、c3は両方を含むのか??

# this run after the new fact made

c4 = addfact("[].[+Page(I100, myOS)]", c3) #final resolvent g2 of c3+x

g3,c5 = stepgoal(g2, c4)

if hasacontradiction(g3)
  println("goal done")
else
  println("fail to achieve the goal")
end


