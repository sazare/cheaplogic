# 記号について
## 動機
自動証明のResolutionで、使われるUnification にまつわるいろいろなことを考えたので、書き残す。


## 表現
まずは表現を定義する。 そのあと、代入を考え、unificationを考えるという順番。

表現はsymbolから構成される。
新しい定義を考えるのは面倒なのでLISPのS-式を表現だと考える。symbolがatom。
ASTも原理的には同じようななものだし。

```[定義1 表現]
expr::= symbol | (symbol . expr*)
expr* ::= () | (e1 e2 .... ek)
■
```
```
例) a, x, (f x), (f x (g y))は表現. ((a) (f x) (g h))は表現ではない。表現にしてもかまわないような気もする。
```[定義: 表現の記号]
S(e) = 表現eに修験する記号すべての集合を表す。
■
```
変数はunificationを考えるときにでてくるので、代入までは変数を特別扱いしない。

### 表現の同一性
symbolの同一性は定義されているとする。表現の同一性。

e1 = e2は、表現の定義に従って定義する。

[定義2 表現の同一性] 

e1=e2であるとは

e1,e2がsymbolであり、同じsymbolならe1=e2はtrue
片方がsymbolでない表現なら e1=e2はfalse
両方がsymbolでない場合は、expr*の長さが同じで、すべての要素について=なら e1=e2はtrue。
そうでなければe1=e2はfalse。
■


### 部分表現

[定義3 部分表現]
e1の一部としてe2が出現していたら、e2はe1の部分表現になっている、というような言い方をする。
■

厳密な定義になっていないが、こうしておく。
同じ部分表現が異なる場所に現れた時曖昧になるけれど、それが重要な場合はないだろうと思う。

部分表現はe2 < e1 というふうに書く。四角い<(\sqsubset)がよいのだけど、キーボードにも辞書(unicode?)にもないので、<にする。
同じeについては、e <= eと書くことにしておく。


## 代入

代入にはいくつかのバリエーションがあり、それに依存してunificationにもバリエーションがありうる。

### 代入の記法(1)

代入σは
記法1: σ=[s1←e1,s2←e2,...,sk←ek]または
記法2: σ=[s1,s2,...,sk]←[e1,e2,...,ek]
のように二種類の記法を考える。
ここで、sはシンボル、eは表現。数字はインデックス。

便利記法として
L(σ) = {s1,s2,...,sk}
R(σ) = {e1,e2,...,ek}
と定義する。

その意味は、あとで定義する代入操作で決める。
記法1だけでも足りると思うが、記法2のほうがわかりやすい場合もあるのでこうした。

#### 代入操作
代入操作は、表現に対して代入を適用する操作である。型は次のとおり。

E x Σ → E
Eは表現の集合、Σは代入の集合。
この操作は、操作として定義される。


まず、基本となる、要素が1つの代入σ=[s←e]について定義する。
これを基本代入と呼ぶ。

[定義 基本代入の適用]
基本代入σ=[s←w]とする。
e・σ =  w when e = s
        e when e != s
        (e1・σ e2・σ ... ek・σ) o.w.
■

とする。

複数の要素を持つ代入を定義するために、代入と代入の演算を2つ定義する。

* : Σ x Σ → Σ
+ : Σ x Σ → Σ

これも 操作として定義する。

[定義 代入演算+と*]
σ1 = [s1←t1, s2←t2, ..., sk←tk]
σ2 = [u1←w1, u2←w2, ..., um←wm]
のとき

σ1*σ2 = [si←ti・σ2, uj←wj] ただし、uj!=si for all i
σ1+σ2 = [si←ti, uj←wj] ただし、uj!=si for all i

これを次のようにも表現する。
σ1+σ2 = [s1,s2,...,sk,uj,...,un]←[t1,t2,...,tk,wj,...,wn]
代入の順序が関係しないので、この表現は意味を持つ。
■

*は、代入を表現に順番に適用した場合に基づき、+は代入を並列に適用した場合に基づく。

普通の代入表記は、集合として書くので、{x←t, y←s}のようになるが、代入の要素の順番を考慮した代入操作が存在することや、代入は記号操作であるから、順番を無視するのがむずかしいということなどから、{}でなく[]で表す。
([]はJuliaでは、配列やベクトルを表すときに使う記号)


それぞれのアルゴリズムは次のとおり。
[アルゴリズム*]
これは、代入の前要素について、表現に対する置換を実行する操作になる。
■

[アルゴリズム+]
これは、表現eのsymbolをすべてトラバースし、それぞれのsymbolを置き換える操作になる。
■

[性質]
L(σ1) ∧ L(σ2) = φ かつ S(R(σ1)) ∈ L(σ2) でないならば、*と+は同じ。
■

複数要素の代入は、
σ = σ1 * σ2 * ... * σk
に等しい。というかそうなるように定義した。

アルゴリズムの違いから、処理時間は*の方が短くなるだろう。

LISPでは、atomとS-式の置換を行う関数SUBSTが定義されていて、これは*で行う代入要素の実行に使えるので、SUBSTを使って実装すると、+の代入操作が*よりも高速にできるかもしれない。


[例]
k=1, m=1 でs1!=u1の場合は次のようになる。

σ1+σ2 = [s1←t1, u1←w1]
σ1*σ2 = [s1←t1・σ2, u1←w1]

s1=u1の場合は

σ1+σ2 = [s1←t1]
σ1*σ2 = [s1←t1・σ2]

である。


[定義 空代入]
変数をx,y,z,..と表した時、表現に適用しても表現が変わらない代入を「空代入」と呼び、εで表す。
■

空代入の表現は無限に存在する

ε=[]=[x←x]=[x←x, y←y]=[x←x, y←y, z←z] = ...

空代入の非操作的定義としては

[定義 空代入]
任意の表現eについて、空代入とは
e・ε=e
となる代入εである。
■

表現がいろいろある代入が同じものであるというためには、代入の同値を定義しておく必要がある。

[定義 代入の同値(仮)]
代入σ1とσ2が機能的に等しいというのは、次の条件を満たす場合である。

任意の表現eについて、
e・σ1 = e・σ2
■

この定義が適切かどうかは検討が必要。

#### 変名
代入は、記号を表現で置き換える操作を表すが、記号を記号に置き換える代入を変名と呼ぶ。

[定義 変名]
σが代入であって、L(σ)もR(σ)もすべて記号の場合、σを変名(rename)と呼ぶ。
■

[定義 逆変名]
変名ρに対して、←の両辺を入れ替えた代入が作れる。これをρ'と書くことにする。
ρ=[x←y]のとき、ρ'=[y←x]である。


例)
 ρ1 = [x←y]のとき、ρ1'=[y←x]である。

ρ・ρ'がどうなるかをみてみよう。
a) e = [x]の場合。
e・ρ1=[y]であり、e・ρ1・ρ1'=[x]=eとなるので、'は群でいう逆元にあたるかのように思われるが、e = (x,y)をとると、e・ρ1=(y,y)となり、これにρ1'をかけてもeには戻らない。

だから、ρ*ρ' != εである。

ρ1+ρ1'=[x,y]←[y,x]

であり、(x,y)・(ρ1+ρ1') = (x,y)となる。
代入の演算+の定義では、'は逆元を与える記号操作である。



たとえば、並列代入可能な代入の集合は定義できるだろうか。
そのような集合Σcが存在したとして、その要素の二つのσ1とσ2は可換だろうか。
並列代入は必要だろうか。ないとどれくらい議論の展開が大変になるだろうか。


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
その条件は強すぎるのではないかとも思うが、どうなのだろうか。

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



##### 代入の等価関係
定義
σ1=σ2

・同じLに対してどちらも同じRを持つ。

##### 代入は一般に非可換
σ1*σ2 != σ2*σ1


#### idempotentの形を持った代入を自動的に作るようなunificationアルゴリズムがあるか
代入を作るアルゴリズムはunificationのみである。
unificationは、代入の中でもmguを作る。

### unification 
##### unificationの前提条件
1) <e1:e2>で、V(e1)∧V(e2)=φ
2) σ=<e1:e2>のときは、e1*σ=e2*σ
3) <e1:e2>が失敗するばあい、例外発生するようなパスで失敗する。
  <e1:e2>が失敗する場合は、DS(e1,e2)=(t1,t2)のとき
　t1,t2が定数で異なる。
  t1<t2か t2<t1のとき
4) mguにσを加えていく時、
　　mgu = mgu ○ σ
　の○を+にするか*にするかで結果がかわる。

アルゴリズム
入力: e1, e2
mgu:初期値[]

 1. e1とe2のdisgreement ds を求める。
　dsがなければ終了。
 2. ds=(p1:p2)とする。
　　両方定数の場合は、p1とp2は異なるので、unifyは失敗=NOとする
     (a,bとかf(-),g(-)の場合)は、失敗=NOとする。　　
    定数と非symbolのexprの場合(a, f(x)の場合)は失敗=NOとする。
　　また、p1が変数とするとp1<p2の場合は、inside とよび失敗=NOとする。
　　p1かp2が変数なら、p1が変数とすると、σi=[p1<-p2]を作る。
 3. mgu = mgu ○ σi
 4. e1,e2にσiを適用する
 5. 1にもどる

3の○には、+を入れるか*を入れるか。

*DSで制御されるループになっている
*DSから要素代入を作るときに、変数かどうかが影響する。
*DSより左の部分は、4では適用する必要はない。同一になるのは決まっている。

例) ○=*の場合
<f(a,y):f(w,g(w))>
d1 = (a:w) ⇨ σ1=[w←a] ⇨ mgu =[w←a]
|y):|g(a))
d2 = (y:g(a)) ⇨ σ2=[y←g(a)] ⇨ mgu=[w←a, y←g(a)]
):)
d3=φ
mgu=[w←a, y←g(a)]

例) ○=+の場合
<f(a,y):f(w,g(w))>
d1 = (a:w) ⇨ σ1=[w←a] ⇨ mgu =[w←a]
|y):|g(a))
d2 = (y:g(a)) ⇨ σ2=[y←g(a)] ⇨ mgu=[w,y]←[a,g(a)]
|):|)
d3=φ
mgu=[w,y]←[a,g(a)]

例)○=*の場合
<f(x,g(x)):f(y,y)>の場合、
d1 = (x:y) ⇨ σ1=[x←y]とすると、mgu = [x←y]
|g(y)): |y)
d2=(g(y):y) ⇨ σ2=[y←g(y)]なのでinside checkでNOになる。

#### 要検討
* insideを残しておいたらダメなのか?
insideで止めないとどうなるか
○は+とする。
例)
<f(x,x,h(x)):f(y,g(y),h(g(y)))>
d1 = (x:y) ⇨ σ1=[x←y] ⇨ mgu=[x←y]
|y,h(x)):|g(y),h(g(y)))
d2 = (y:g(y)) ⇨ σ2 = [y←g(y)] ⇨ mgu=[x,y]←[y,g(y)]
|h(g(y))):|h(g(g(y))))
d3 = (y:g(y)) ⇨ [y←g(y)]⇨mgu=[x,y]←[y,g(y)] ;; y←g(y)はかわらなかった
|):|)
d4=φ
mgu=[x,y]←[y,g(y)]

### 計算量
 並列代入e・σは、eの全記号についてσを実行するので、
 O(e・σ) = #S(e)*O(σ)

 直列代入e*σは、σの全要素についてe*σ1を行う。
 eが1symbolならば、σは平均|σ|/2の計算が必要。
 それを|σ|回実行しなくてはならないので、
 O(e*σ) = #S(e)*|σ|/2*|σ|

 1 resolutionでは、unificationは1回行う。

 (C1 + L) x (C2 + L')
 の場合、

 resolventの作成にかかる代入の回数(Literal数)は
 |C1|+|C2|回

 LとL'のUnificationでは
 unificationがLとL'の間で行われるとすると、
 diを求める回数 exprの個数の上限 = 引数の数x深さ
 代入を行う回数と範囲 exprの個数の/2

 こうしてみると、unificationはC1+C2に対する代入の回数よりも
多そうだが、代入の範囲は1/2になる。

 proof of []にかかる代入の数
 proof の可能性についての代入の数

 すべてのliteralは、input literalのインスタンスであることを考えると、何か全体としての代入の回数が見積もれるのではないか

 

