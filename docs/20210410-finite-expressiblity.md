# 有限ドメインの表現について
## 分類
1. あらかじめ列挙できる(preenumerable)
 - 有限ドメインの制約条件を書いておける
 - このような条件は人間が書いて試すことができる
2. 大量であるため列挙は実質不可能{practially unenumerable}
 - 2^64のbitがあると、だいたいそれくらいの定数が存在してしまう
 - そのとき、制約条件をすべて書くことはできない(組合せになるかもしれない)
 - 動的に条件を生成していくような方法でどこまで対応できるか
3. 限界がないので本質的に列挙不可能{unenumerable}
 - 計算機の世界では、巨大な有限は存在するが、本質的な無限は存在しない。
 - ドメイン/変数が無限個の値をとれると考えるのは、計算表現が単純になるからと思われる
 - 実際には、overflowなどは、有限固有の部分を例外という表現によって除去して、無限であるかのように書いている。
 - 本当に単純になっているのだろうか?
 - これは「列挙が実質的に不可能」というケースになるのかも
 - 