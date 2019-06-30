C1 Valid 
C2 Contradiction 
C3 View入力でなんでも[] 
C4 2つのViewでなんでも[] 
C5 View先、残りevalで[] 
C6 evalで残り1Viewで[] 
C7 Viewは後出し。ViewPでx>=yなら[] 
C7 ViewPでx<yなら[]ができない => validview  ... 入力が代入されていない
   clauseがcoreに登録されていない
C8 ViewPは先出し。ViewPで>=yなら[] 
C8 ViewPでx<yなら[]ができない => validview ... 入力が代入されていない
C9 ViewP{x,y}とViewR{z,w}があり、x>yなら[]、
   そうでないならValid...  入力が代入されていない
C10  {x>=y}、ViewP{x,y}, ViewR{z,w}, S(y,w) 
　　　y = 1, w= 2, x >=1 なら[] NG Sのresoができず途中
     それ以外はValid ... 

C12 {x>=w}、ViewP{x,y}, ViewR{z,w}, S2(1,2) 
　　a x>=2, y=1, w=2 なら [] NG Sのresolutionできず。Viewとevaluate部分は
    b それ以外はValie(かな)  
