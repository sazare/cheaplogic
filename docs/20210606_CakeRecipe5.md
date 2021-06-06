# Cakeのレシピ
## 人間とLogicのつなげかた

prev:  20210606_CakeRecipe5.md

手続きが関数として実装される場合、こんな書きかたになる。

```wff
;; manipulations, (1) these literal remain after
;((x y) (+ Whippr x y (whip x y)))
;((x y) (+ Bowlpr x y (inbowl x y)))
;((x y) (+ Mixpr x y (mix x y)))
```

レシピの場合、何をしたいかというと、曖昧なレシピを人間の作業にどう反映していくかということを考えている。レシピという「曖昧な手続きもどき」を「具体的な手順」にする。

関連するレシピの論理表現はこのようにした。

```wff
((x y z) (- Fresh x) (- Sugarp y) (- Whippr x y z) (+ Cream z))
((x y z w) (- EggWhite x) (- Sugarp y) (- Bowlpr x y z) (- Mixpr z w) (+ Melenge w))
((x y z w) (- EggYellow x) (- Sugarp y) (- Bowlpr x y z) (- Mixpr z w) (+ Mixed w))
((x y z) (- Mixed x) (- Rice y) (- Mixpr x y z) (+ D1 z))
((x y z) (- D1 x) (- Milkp y) (- Mixpr x y z) (+ D2 z))
((x y z) (- D2 x) (- Melenge y) (- Mixpr x y z) (+ Dough z))
```

orphanで終わらず、orphan literalは残して、できるかぎりresolveできるリテラルを消すという方針のコードが今(20210605のcommit)版である。

それによって、これ以上resolutionが進まないとき、残されたliteralがprocedureだと今は考えている。
論理表現が間違っていて、手続きでないliteralが残るかもしれない。ここは重要

現状は、orphanとして残ったリテラルは
1) 将来のfactができたとき消えるか
2) 手続きとして実行されて消えるか

ということは、手続きの実行で (+ Mixpr z w)が事実化されればよい。

計算できるリテラルは、実行する前は

```wff
L24-6 (- BOWLPR YELLOW SUGAR1 Z.604) = (OLID L10-3 PLID L23-7 CID C24)
```

のように変数を含む。この手順が完了すると、
```wff
(+ BOWLPR YELLOW SUGAR1 YELLOWSUGAR1)
```

のようにgroundになる。
L24-6の場合、BOWLPRはボウルに卵黄と砂糖をいれた状態にすることなので、
EOがボウルに材料が入った状態を判別し、手順完了時には、たとえばYELLOWSUGAR1という定数(名前)でBOWLPRのリテラルをfactとしている。

EOがいちいち定数を作る必要があるのかどうかはEOの仕組みに依存する。
ただし、次の手順をactivateするためにはroundである必要がある(**今のところ**)ので、定数にしなくてはならない。



