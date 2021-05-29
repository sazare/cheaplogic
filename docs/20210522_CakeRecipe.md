## ケーキのレシピ
参考 https://cookpad.com/recipe/4712701


### 材料
- 卵 3個
- グラニュー糖 80g
- 牛乳 大2
- 米粉 80g
- 生クリーム 200cc
- 砂糖 大2
- いちご 適量


### 手順(書き方整理1)
1. いちごを洗う。へたをとる
2. 間に挟むいちごは2つに切る
3. ボールに生クリーム、砂糖をいれてホイップする。(クリームを作る)
4. 1つのボールに卵白、砂糖を入れ、メレンゲ状に泡立てる
5. もう一つのボールに卵黄、砂糖を入れ、もったりとするまで、しっかりと混ぜる。
6. 5に米粉を入れ、混ぜる
7. 半分位混ざったところに牛乳を入れ混ぜる
8. 7に4のメレンゲを何回かに分けて混ぜる
9. 生地が完成する
10. 型にクッキングシートをセットする
11. 10に9の生地を流しこむ
12. １７０度のオーブンで４０分焼く
13. 粗熱をとってから、シートをはがし、２枚に切る
14. １枚に生クリームを塗る
15.  14にイチゴを並べる
16. 15の上にもう一枚の生地をおき、生クリームを塗る
17. 16にイチゴを飾る。


### 手順整理(かなり整理)
#### 材料
   - (Egg 3)
   - (GranulatedSugar 80)
   - (Milk 2)
   - (Rice 80)
   - (RawCream 200)
   - (Sugar 2)
   - (Strawberry any)
   - 
#### Cooking
これは、もとのレシピをそのまま書き直したもの。不十分。
方針
   1. 作業のステップごとに(StepN xxx)という述語で状態を示す。
   2. andだけ書いているが、implyとかはあとで調整する
   3. 「メレンゲ状になったら」とか「何回かに分けて」とか、どうすればよいかわからない表現は、今は適当に述語を導入して書いてみている。
   
 
 手順
   1) (WashedBerry x y) and (Strawberry x) and (RemoveCalyx y z) and (Step1 z)
   2) (Divide2 x y z) and (StrawberryIn y) and (StrawberryOn z) and (Strawberry x) and (Step2 y z)
   材料の全体とその一部を分ける??
   ここらへんの述語は、対象としている材料全体が変数のドメインになっている。ようだ。
   
   ```md
   文脈というかcource of discussionというか、そういうものがΣにはあるように思う
   というか、そういうふうに書いている
   ```
   
   (Strawberry x) <=> (StrawberryIn y) and (StrawberryOn z) and x=y∪z
   最初からむずかしい
   
   3) (Cream w) and (Step3 w) and (Whip x w) and (InBall x y z) and (RawCream y) and (Sugar z)
   4) (Step4 z) and (IsMelenge z) and (Sugar y) and (EggWhite z) and (InBall x y z) and (Beat x z)
   5) (EggYolks x) and (Subar y) and (BowlIn x y z) and (Mottari w) and (MixHard z w) and (Step5 w)
   6) (Step5 x) and (BowlIn x y z) and (RiceFlour y) and (Mix z w) and (Step6 w)
   7) (Step6 x) and (MixInHalf x) and (BowlIn x w z) and (Milk w) and (Mix z u) and (Step7 u)
   8) (Step7 x) and (Step4 y) and (Separate some y) and (Mix x some w) and (Step7 w) and (- Empty some)
   9)  (Step7 x) and (Step4 y) and (Separate some y) and (Mix x some w) and (Step8 w) and (+ Empty some)
9) (Step8 x) <=> (MadeKiji x)
10) (Setup k s x) and (Kata k) and (CookingSheet s) and (Step10 x)
11) (Step10 x) and (MadeKiji y) and (PutIn x y z) and (Step11 z)
13) (Step11 x) and (Bake x 170C 40M z) and (Step13 z)
14. (Step13 x) and (Cooloff x y) and (Step14 y)
15.  (Step14 x) and (Removesheet x y) and (Cut2 y z1 z2) and (Step15 z1 z2)
16.  (Step15 x1 x2) and (Paste x1 y z1) and (RawCream y) and (Step16 z1 x2)
17.  (Step16 x1 x2) and (Puton y x1 z1) and (Strawberry y) and (Step17 z1 x2) 
18. (Step17 x1 x2) and (Puton x1 x2 y) and (Step18 y )
19. (Step18 x) and (Puton x y z) and (RawCream y) and (Step19 y)
20. (Step19 x) and (Strawberry y) and (Decolate x y z) and (Step20 z)

```md
「生クリーム」と「クリーム」の違いはどうした。後半は、「生クリーム」ばかりでてきて、「クリーム」はどこで使っているのか?
メレンゲ状になったものは「クリーム」で、あとでケーキに塗っているのは「生クリーム」ということらしい。
```

#### ふりかえり
- (StepN )はいかにも手続きだ。ここの状態でなく、手続き的な観点からの状態。
	- レシピなのである程度は仕方ないにしても
	- 個々の状態(たとえば Melengeなどの状態にもとづく)





### 手続きの取り出しかた(検討事項)
手順を残したい場合、Φ(x){p(x;y)}ψ(x,y) と書くところ、こうもかけるのでは?
最初は (Recipe ())としておいて

(Wash x (wash x))
(Wash x y) (Recipe w (seq w y))
で(Reciepe a (seq a (wash x)))になるようなかんじ。 
 うまくいくかどうか?
 {p(x;y)}をつないでいく仕組みを作るのが面倒だし、Logicの部分を変えたくないので・・・
 さらに調べる
 
 
 
