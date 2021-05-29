## ケーキのレシピ その3
prev:  20210522_CakeRecipe2.md
参考 https://cookpad.com/recipe/4712701

### 手順整理(かなり整理)
ここでは、架空の状態は作らない。
素材とそれからできたものの関係を書く

手順は、大きく三つにわかれる。
1) 素材の準備　生地を作る
2) 生地を焼いて前ケーキを作る
3) 前ケーキにクリームを塗ってととのえる

1を簡略化して書いてみる

1. Fresh(x) Sugar(y) Whip(x,y,z) Cream(z)
2. EggWhite(x) Sugar(y) Bowl(x,y,z) Mix(z,w) Melenge(w) 
3. EggYellow(x) Sugar(y) Bowl(x,y,z) Mix(z, w) Mixed(w)
4. Mixed(x) Rice(y) Mix(x,y,z) X(z)
5. X(x) Milk(y) Mix(x,y,z) Y(z)
6. Y(x) Melenge(y) Mix(x,y,z) Dough(z)

*  全体として、Dough(z)を作るまで

- これだと手続きはとれないのでは。

手続き述語は
Whip(x,y,whip(x,y))
Bowl(x,y,inbowl(x,y))
Mix(x,y,mix(x,y))

これの順番をどう抽出するのか?

?
Mixedは必要なのか? 状態を残すには必要
・goalは何か?  

素材が準備できているのはfact

1. -Dough(z)
2. +Fresh(a)
3. +Sugar(s1)
4. +EggWhite(w)
5. +EggYellow(y)
6. +Rice(r)
7. +Milk(m)
8


  


