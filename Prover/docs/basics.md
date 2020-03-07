# 記号について
## 動機
Unification について考えている。
いろいろなUnificationのアルゴリズムが存在し、それらを比較するのがややこしい。
エルブランの論文では、Unificationは規則として定義されているようなことが書かれていた(Unification Theoryという、一章in a book。検索して発見)

Unificationについて何かを言う時、表現の定義、代入の定義、変数の意味、そしてそれらの上にUnificationアルゴリズムが定義される。

たとえば変数をどうやって判定するか、それを表現の中に持つのかどうか、代入は順番に処理するのか、並行に処理するのか、Unificationのinside checkは変数の概念と切り離せない。表現の等価、代入の等価、renameの定義などなど、定義したとしてそれがwell definedかどうかもよくわからない。
そこで、一から考えてみようというのが、ここの意図　動機である。

## 表現
表現はsymbolから構成される。
面倒なのでS-式を表現だと考える。symbolがatom。

expr::= symbol | expr*
expr* ::= () | (symbol . expr*)

例) a, x, (f x), (f x (g y))は表現. ((a) (f x) (g h))は表現ではない。


まだ、変数は考えない。
変数はLogicからくる概念であり、表現と代入の世界は記号だけの世界なので、変数をいれずに考えてみる。
限界がきたら、導入するが、どういう不都合があるのかをみたい。

### 表現の同一性
e1 = e2は、表現の定義に従って定義する。記号的な同一をe1≡e2と書くこともあるようだが、ここは=でいく。

定義1) 
e1=e2であるとは

e1,e2がsymbolであり、同じsymbolならe1=e2はtrue
片方がsymbolでない表現なら e1=e2はfalse
両方がsymbolでない場合は、expr*の長さが同じで、すべての要素が同じなら e1=e2はtrue。
そうでなければe1=e2はfalse。

symbolの同一性は定義されているとする。

### 部分表現
e1の一部としてe2が出現していたら、e2はe1の部分表現になっている、というような言い方をする。
e2 < e1 というふうに書く。四角い<(\sqsubset)がよいのだけど、キーボードにないので、<にする。

同じeについては、e <= eということにしておく。


### 表現の同値
表現の同値関係、e1〜e2みたいなのは、変数がなければ必要ないと思うので、まだ使わない。

## 代入
代入は、ふつうは{変数i<-表現i}のような形で導入され、表現に対する代入操作をへて、表現+代入という世界に至ると思うが、その代入操作のバリエーションがいろいろあったり、明確に定義されていなかったりしてややこしいので、一歩一歩定義したい。

### 代入の表記
a) [s <- e] を基本と考える。記号sを表現eで置き換えるということを意味する。
　　任意の表現Eに対して、E*[s<-e]は、Eに出現する記号sをeに置き換える。
　この定義の曖昧なところは、eの中にsが出現している場合、どうするのかということ。

b) [s1 <- e1, s2 <- e2, ..., sk <-ek]
　普通の代入の定義だと{s1 <- e1, s2 <- e2, ..., sk <-ek}のように書くと思うが
　この順番が重要なので、ここでは[]で囲んで集合ではないことを明示する。
　ある種の代入は、要素の順番で結果が変わらなくなるが、一般には変わる。
　ちなみに、代入は非可換。

c) [s1,s2,...,sk] <- [e1,e2,...,ek]
　順番が関係ない場合、いいかえれば代入操作が、代入の要素を並列に実行しても
よい場合は、こう書くほうがよいだろう。

定義)
σ= [s1 <- e1, s2 <- e2, ..., sk <-ek]
のとき
L(σ) = {s1,s2,...,sk}
R(σ) = {e1,e2,...,ek}
と書く。
また、
S(e) : eに出現するsymbolの集合
と定義し、
SL(σ) = S(L(σ)) = L(σ)
という定義にする。

SR(σ) = S(R(σ)) 
は、代入の右辺に出現するsymbolの集合である。


### 代入操作の定義
方針
e*[s <- e] 
を定義し、それに基づいて一般の形の代入操作を定義していくようにしたい。
代入表現のc)については、ここでは考えない。

記号の操作として定義するとすると、e*[s1<-e1]は、eに出現するs1を
すべてe1に置き換えた表現のことである。



#### 代入の性質
##### 性質1)
σ1*σ2 は σ2*σ1と等しいとは限らない　非可換

例)
σ1=[x<-y]
σ2=[y<-a]
[x,y]*σ1*σ2=[y,y]*σ2=[a,a]
[x,y]*σ2*σ1=[x,a]*σ1=[y,a]

### 複数要素の代入操作
*代入操作案1
e*[s1 <- e1, s2 <- e2, ..., sk <-ek] = (...((e*[s1 <- e1])*[s2 <- e2])...)

左から順に適用していくということ。
この定義では、代入の表現の順序が、結果に影響する。

例)
σ1=[x<-y, y<-a]
σ2=[y<-a, x<-y]
e=[x,y]
とするとき、この代入操作の定義では
e*σ1=[a,a]
e*σ2=[y,a]
となり、要素は同じなのに順番によって代入の結果が異なる。

表現の順番が変わっても同じ結果にしたいのであれば、代入の並列操作を前提とするしかあるまい。
それについては後であらためて書く。


### 並列代入(仮
σ=σ1+σ2+...+σk
のとき、
σ1からσkを入れ替えたすべての組み合わせについて、任意のeについて
e*σi1*σi2*...*σik
が同じ値のとき、そのσは並列代入可能であると考え
[s1,s2,...,sk]<-[e1,e2,...,ek]
と表記する。

このような定義に意味があるのだろうか?
たとえば、並列代入可能な代入の集合は定義できるだろうか。
そのような集合Σcが存在したとして、その要素の二つのσ1とσ2は可換だろうか。
並列代入は必要だろうか。ないとどれくらい議論の展開が大変になるだろうか。

### 一般論。定義について
一般に定義にはいくつかの方法がある。
1) 表現の定義。代入を[s<-e]と表記するとかいうこと
2) 代入操作の定義。
3) 表現の間の関係や操作の間の関係
4) 直感的な概念に適合しているかどうか

注意すべき点
1) 代入の意味は、代入操作が適切に定義されるかどうかによってきまる。
   well definedかどうか
2) 定義できたとして、それが役に立つか、議論を進める上で無駄なステップが発生しないか。
　　は、また別の話。

#### 空代入
空代入を[]と書くとすると、空代入は、代入の合成において、単位元であり
a) e*[] = e
が成り立つ。

空代入はεで書くような気もする。ここまでの話の具合だと[]と書くのが整合しているようだ。
ただし、
[]と書いてはいるが、本当はすべてのsymbol siについて
[s1<-s1,s2<-s2,...](無限)
と書いているのと同じである。

{無限の表現が操作によって代用されるということか)

### [e1 <- e2]について
左側をsymbolに限定しているのは、いずれ変数に対する代入の話になる
ことを見込んでの話だが、ここでの代入としてはそういう必要はない。
σ=[e1 <- e2]は、記号の上でよく定義できるだろう。
同値関係の置換の話だと思えば、このような代入もありうる。

表現e*σは、eに出現するe1をすべてe2に置き換える操作である。
変数がなければ、これは厳密に定義できる。

この場合でも e1 < e2だと、e1を置き換えたe2の中のe1をどうするかという
問題がでてくる。

代入としては、最初のeに一度だけ適用するという定義でもよく、その場合何も
矛盾しない。

(x*[x<-f(x)])*[x<-f(x)] => (f(x))*[x<-f(x)] => f(f(x))
になるだけである。
*unificationでは繰り返し代入を適用する必要があるので、
このような代入は無限に繰り返しが発生するので
NGとすることになる。(inside check)

σ=[e1<-e2]は、term rewriting systemとも考えられる。
まだ変数を導入していないので、[add(1,2) <- 3]のような
concreteな計算はできるが、完全な計算システムにはならない。

代入の左辺をsymbolに限定すると、表現に代入を適用したとき、
その表現は必ずもとの表現よりも複雑になる。
instanciateされるとはそういうことだ。

表現のlatticeを考え、複雑な表現が下にいくようにレイアウトすれば
代入の適用は下降のみを可能にする。
symbolどうしの代入では、同じレベルでの移動はできるが、
上昇不可である。

### rename
代入の単純な例について考える。
[s<-e]のsもeもsymbolであるものをrenameと呼ぶことにする。

これは、表現の関係グラフ(パーザーでの表現木と違い、
こでの表現束というのは表現をノードとし、
インスタンス関係が大小関係になるような構造と考える。

表現上、rename ρには、<-の両側を逆にすることで逆変換にあたる
ρ^-1を定義できる。つまり

ρ=[x<-y]のとき
ρ^-1 = [y<-x]

この定義は

ρ*ρ^-1=[x<-x,y<-x]
ρ^-1*ρ=[y<-y,x<-y]

であり、第一要素を見ているかぎりは空代入に見えるが
第二要素があるので、空代入とはならないから
任意の表現eについて
e*ρ*ρ^-1 = e
や
e*ρ^-1*ρ = e
が成り立つわけではない。

([x,y]*ρ)*ρ^-1=[y,y]*ρ^-1=[x,x]
[x,y]*(ρ*ρ^-1) = [x,y]*[x<-x, y<-x] = [x,x]

であり、代入の合成としては同じ結果になるので
上に書いたように
ρ2=ρ*ρ^-1 = [x<-x,y<-x]
であるが、
e*ρ2 != e
ではないので、空代入にはならならい。
つまり、
ρ*ρ^-1 != []

#### 注意
すべての表現について成り立つかどうかと考えると
[x,y]が反例になってしまうが
[x]だけを考えると、ρ*ρ^-1は[x]に対する空代入である。

ρ^-1*ρは[y]に対する空代入だが、この二つは等しくないので
非可換の例になってもいる。


### renameの合成
例1)
ρ1=[x<-y]
ρ2=[z<-y]
のとき、
([x,y,z]*ρ1)*ρ2 = [y,y,z]*ρ2 = [y,y,y]

なので、ρ=ρ1*ρ2 = [x<-y,y<-y,z<-y] である。

[y<-y]はないのと同じなので、単純にρ1とρ2の和集合のようにみえる。
R(ρ1)∧L(ρ2)なのは、二つのrenameが直交しているようなものか。


例2)
ρ1=[x<-y,y<-z]
ρ2=[z<-y]
の場合は
([x,y,z]*ρ1)*ρ2)=[y,z,z]*ρ2=[y,y,y]
例1と同じ結果だが、y<-yはない。

y<-z * z<-yがy<-yになっているように見える。
個々のsymbolについて変化を追うと

xについては、x=>y=>y
yについては、y=>z=>y
zについては、z=>z=>y

と変化している。

### 一般的な代入の逆
σ^-1を考えると、同じ記号xが場所によってy,別の場所でzにもどる必要があるかもしれない。
σ4={y<-x, z<-x}の場合
[x,y,z]*σ4=[x,x,x]
となるが、σ4^-1が[x,x,x]を[x,y,z]にもどすには、そういうことが必要なので逆元は一般的には存在しない。

### 等冪
では、
ρ1=[x<-y, y<-z, z<-x]
のような巡回置換なら
[x]*ρ1*ρ1*ρ1=[x]
となる。
ρ^-1=ρ1*ρ1
なのか?

ρ1*ρ1=[x<-z,y<-x,z<-y]
であり、表現上は変数の入れ替えによる逆元になっている。

これも、同時に解決しないからうまくいくのであり
ρ5=[x<-y, y<-x]
の場合は
([x,y]*ρ5)*ρ5=[y,x]*ρ5=[x,y]
になる

e*ρ!=e

群論の焼き直しか・・・

#### 代入[s<-e]いろいろ

* [x<-x]を消していいのか
　Logicalなレベルで<e1:e2>を計算するときは、変数をローカルに持つほうが計算しやすい。
その場合は[x<-x]を残すほうがよいのではないか。
(実装として、Dictionaryを使うというのはありうる)

*cheaplogicで、fixed pointとかclosureとか呼んでいた現象について。

σ^2!=σのとき、繰り返しσをかけてくと、σをσ^n=σ^n-1となるか。
そのσ^nは最初のσと何が違うか、何が同じか。

* L(σ) ∧ R(σ) = φ
この場合は、eに出現しているL(σ)はσを適用するとすべて消えてしまうので、e*σ*σでは、二度目のσは何も変化させない。

* L(σ) ∧ R(σ) != φ
このときは、なんらかのeについて、e*σ*σ != e*σとなる。
なぜなら、共通の変数vについて、v<eとなるeを考えると
e*σにはvが残るが、そのvはもう一度σを適用すると、[v<-e']のe'に置き換わるので、e*σとe*σ*σは同じでないから。
e*σとe*σ*σの違いは何か?

証明は、次のようになる。
1) L(σ)とS(R(σ))の数を数える
2) e*σによって、だいたいeのL(σ)変数は減っていく。

σ=[x<-f(y,z),y<-g(w,z),z<-h(n)]
L(σ)={x,y,z}
S(R(σ))={y,z,w,n}

y,zが共通

このとき、σを一度適用すると、xが消える。
変数がどう変わるかは、σによって決まり、次のようになる。
x->{y,z}
y->{w,z}
z->{n}
もしすべての変数を含むeにこれらの代入を繰り返し適用したとすると、変数は次のようにかわる。
関数記号、定数記号は無視する。

{x,y,z}=>{y,z,w,z,n}={y,z,w,n}=>{w,z,n,w,n}={w,z,n}=>{w,n,n}={w,n}=>{w,n}
=>はBagとして重複を残し、=は集合として重複を除いた。

となり、変数が変化しなくなる。これらの変数はL(σ)に属さないので(属する変数はすべて代入で消えていく)
代入によってeが変化しなくなる。

insideで失敗が確定しないかぎり、有限回σを適用しつづけると、e*σ^n = e*σ^n+1　になるだろう。

### では、σ^n=σ^n-1となるσの形は?
上の証明のスケッチからは、
SL(σ)∧S(R(σ)) = φであれば、ループが起きない。
その条件は強すぎるのではないか。

e*σのとき
1) S(e)∧SL(σ)
  =φならσによってeは変化しないのでおしまい
  !=φの場合、σの代入でeは変化する。[x<-x]の形以外のものがあれば。
2) SL(σ)∧SR(σ)
  =φなら、σを2度以上適用しても代入結果は変わらない。
  !=φならば、idempotentではない。

3) SL(σ)∧SR(σ)!=φの場合、S(e)∧SL(σ)∧SR(σ)が
　=φならば、σは1度適用すると変化しなくなる。
  !=φならば、σ^nで変化しなくなるとすると、その時間は下記の計算になるが・・・


例)
 σ=[x<-f(y,z),y<-g(w,z),z<-h(n)]
 [y,z]*σ*σ=[g(w,z),h(n)]*σ=[g(w,h(n)),h(n)]
で収束する。

 (([x,y,z]*σ)*σ)*σ=([f(y,z),g(w,z),h(n)]*σ)*σ=[f(g(w,z),g(w,h(n)),h(n))]*σ
  = [f(g(w,h(n))),g(w,h(n)),h(n)]
で収束する。

xが収束するまでの時間をt(x)と書くとすると、L(σ)のそれぞれについて計算できて
t(x)=max(t(y),t(z))+1
t(y)=t(z)+1
t(z)=1

この式は、σの右辺を一度トラバースすればわかる。


となるから、具体的な値は。
t(z)=1
t(y)=2
t(x)=3
となり、σ^3=σ^4である。

例inside)
σ=[x<-f(y), y<-g(z), z<-h(x)]の場合のtは?

t(x)=t(y)+1
t(y)=t(z)+1
t(z)=t(x)+1

であり、t(x)=t(x)+3 となるから、insideがあるとわかる。
たどっていって、先にもどればinside checkと同じように終わらないのがわかる。
inside checkとどちらが効率的か??


#### 代入の合成
代入操作は、次のような関係を満たしてほしい。
(e*[s1 <- e1])*[s2 <- e2] =  e*([s1 <- e1]*[s2 <- e2])

そうなっているだろうか。
代入の間の適用操作はまだ定義していないので、これが目標ということ

##### 代入σ1,σ2の合成σ=σ1*σ2
σ=σ1*σ2
 SL(σ1)∧SL(σ2) != φならば、σ2のその要素は適用されない。
 SR(σ1)∧SL(σ2) != φならば、R(σ1)の要素は代入で形が変わる。

　σの要素の順番についてはあとで考えるとして、どの[v<-e]がσに含まれるかは次のとおり。

 [v<-e]∈σとなるのは次の場合
　v ∈ SL(σ1) ∨ SL(σ2)

  [v<-e]∈SL(σ1)の場合、
  [v<-e*σ2] ∈ σ
　
  [v<-e1] ∈ σ1 かつ [v<-e2] ∈ σ2の場合は、
  [v<-e1*σ2] ∈ σ

である。

  v ∈ SL(σ2) - SL(σ1)の場合は
  [v<-e3] ∈ σ2とすると
　[v<-e3] ∈ σとなる。
 　このe3にはσ1は適用されないが、σ2が適用されることはあるかもしれない。
　定義によっては。

こういう定義は、いろいろ可能性を混在させているのでややこしくなっているような気がする。


### 消える情報
e*σは、eの構造を壊していく。

σ1=[x<-y]
を
[x,y]
に適用すると
[y,y]
になる。本来独立した項であるxとyに同じであるという条件を適用することで
どのような代入によっても本の形には戻せない。

[y,y]の方が条件がかけられているので、エントロピーは低くなっていると考えられる。
それは、代入で変換できるかどうかと同じことになる。
σ: e1->e2
となるとき、e2からe1に戻せる代入が存在しないという点で、情報が失われたとも考えられる。


### unificationと代入の直列と並列(ancient.lisp修正)
直列の代入といっているのば、代入要素のたとえば左から順番に適用していくということ。
並列というのは、同時に適用するということだが、実際にそれは実現できないので、それができたとしたときの結果を考える。
つまり、 並列代入操作の場合、代入要素の順番によらない結果になってほしい。

順序によらないというのは、
a) <f(x, h(w)):f(g(y),y)>
b) <f(h(w),x):f(y,g(y))>
の違い。(<t:s>はtとsのunificationを意味する)

a)は、左から順にdsを解決していくと[x<-g(y)],[y<-h(w)]と作られ、
b)は、左から順にdsを解決していくと、[y<-h(w)],[x<-g(h(w))]となる。

a)ではmgu1=[x<-g(y), y<-h(w)], b)ではmgu2=[y<-h(w),x<-g(h(w))]となる。

代入を左から順に適用するとどちらでも同じだが、並列に適用することを考えると、mgu2はよいがmgu1は適切ではない。

#### 代入要素の順番
並列代入操作の場合、代入要素の順番はどうなっていても同じ結果になるので、たとえば、変数名の順番でそーとすることによって、代入表現を標準化できる。実装ではそれもしてみているが、時間を消耗するのと、結果は同じになるので不要なsortだとは思う。
テストのために導入してみたが、たぶんテストのときにsortすればよいことだろう。


#### 並列と直列の代入表現について
上で求めたmgu1とmgu2は見た目は異なるが、左から順に適用していく代入操作のもとでは等価になる。右から順でも同じになりそう。
たとえば、eとして変数リスト[x,y,w]を考えると

e*mgu1=[g(h(w)),h(w),w)
e*mgu2=[g(h(w)),h(w),w)

となって等しくなる。これは、左から右代入のような直列方式の場合、表現自体が作業場所になって、代入を蓄積していくからのように見える。

これの計算量として、eとS(σ)の比較回数(C(-))を考えると
C(e*σ)=|e|*|σ|
となる。
|e|はeに出現する記号の数。|σ|はSL(σ)の数。本当はσのs<-eでおきかわったeの記号の数も関係するから、もっと多くなる。

もしも並列型の代入(つまりmgu2)を求めていたら、代入操作ではSL(σ)のなかの一つの記号だけを置換すればよいので、他の記号は調べる必要がないから、その比較回数は|e|だけになる。

unification(<:>)における計算がすこし複雑になっても、何回行われるか分からない代入の計算が単純になれば、そちらのほうが経済的だと思う。


### 表現の同値ふたたび
given 代入σについて、e1とe2が同値であることを次のように定義する。

定義1)
代入σが与えられたとき、
e1〜e2/σ ⇔ e1*σ=e2*σ

これはwell definedだろうか。
というか、みためがあやしい

意図は、e1=[f(x)]とe2=[f(y)]を同一視したい(Logicでは)というのの実現だが
この場合、e1*[x<-y]=e2*[x<-y]=[f(y)]となって成り立つ。
でも、変数のつけかえでも変わらないという意味だと、特定のσでなりたつとかいうのはおかしい。

σを除いた〜を定義しようと思うと、renameを使って
e1〜e2 ⇔ ∃σ:rename e1*σ=e2*σ
になりそうだが、これはあやしい。

例)
σがrename [x<-y]のときは
x*σ=y なのでx〜y/σ


### 代入の同値
σ1〜σ2 ⇔ 任意の表現eについて、e*σ1=e*σ2となる

これもwell definedかどうか・・・
ややこしい

logicalなbinding変数を考えようとすると、ますます難しくなる・・・


##### 代入の等価関係
定義
σ1=σ2

##### 代入は非可換
σ1*σ2 != σ2*σ1


#### idempotentの形を持った代入を自動的に作るようなunificationアルゴリズムがあるか
代入を作るアルゴリズムはunificationのみである。
unificationは、代入の中でもmguを作る。

##### unificationの前提条件
1) <e1:e2>で、V(e1)∧V(e2)=φ
2) σ=<e1:e2>のときは、e1*σ=e2*σ
3) <e1:e2>が失敗するばあい、例外発生するようなパスで失敗する。
  <e1:e2>が失敗する場合は、DS(e1,e2)=(t1,t2)のとき
　t1,t2が定数で異なる。
  t1<t2か t2<t1のとき

DSでドライブしていく
 雑
ρ1*[z<-y] => [x<-y, z<-y]

可換図を書くと
([x,y,z]*ρ1)*[z<-y] = [y,y,y]

ρ2=[x<-z]
[x,y,z]*ρ2 = [z,y,z]
([x,y,z]*ρ2)*[y<-z] = [z,z,z]

ρ2*[y<-z] => [x<-z, y<-z]


となり、[x,y,z]の3つのeを同一にするという意味で
ρ1*[z<-y]とρ2*[y<-z]は等価である。

このあたりで変数を考えなくてはならないような気がしている。
まず、[y,y,y]と[z,z,z]が同じであると考えたい。



rename ρ1, ρ2で、S(ρ1)∧S(ρ2)=φの場合、

[x<-y] * [z<-w]

