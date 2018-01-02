# playTime.jl

##文法
include("grammer.jl")

qvar=[誰 何 何処]

#魔法世界
const QB=:QB
const ほむら=:ほむら
const 暁美=:暁美
const まどか=:まどか
const さやか=:さやか
const 上条=:上条
const 杏子=:杏子
const まみ=:まみ
const ひとみ=:ひとみ
const 魔法少女=:魔法少女
const 魔女=:魔女
const ソウルジェム=:ソウルジェム
const ワルプルギスの夜=:ワルプルギスの夜


魔法会議_0=[
 [暁美 は ソウルジェム を 持っている],
 [さやか は ソウルジェム を 持っている],
 [まみ は ソウルジェム を 持っている],
 [暁美 の ソウルジェム は きれい],
 [さやか の ソウルジェム は きれい],
 [まみ の ソウルジェム は きれい]
]
魔法会議_1=[
 [暁美 は ソウルジェム を 持っている],
 [さやか は ソウルジェム を 持っている],
 [まみ は ソウルジェム を 持っている],
 [暁美 の ソウルジェム は きれい],
 [さやか の ソウルジェム は 濁っている],
 [まみ の ソウルジェム は きれい]
]
魔法会議_2=[
 [暁美 は ソウルジェム を 持っている],
 [さやか は ソウルジェム を 持っている],
 [まみ は ソウルジェム を 持っている],
 [暁美 の ソウルジェム は きれい],
 [さやか の ソウルジェム は 濁っている],
 [まみ の ソウルジェム は きれい],
 [さやか は 魔女 です],
]

魔法会議_1n=[
 [暁美 は ソウルジェム を 持っている],
 [さやか は ソウルジェム を 持っている],
 [まみ は ソウルジェム を 持っている],
 [暁美 の ソウルジェム は きれい],
 [さやか の ソウルジェム は きれい でない],
 [まみ の ソウルジェム は きれい]
]
魔法会議_2n=[
 [暁美 は ソウルジェム を 持っている],
 [さやか は ソウルジェム を 持っている],
 [まみ は ソウルジェム を 持っている],
 [暁美 の ソウルジェム は きれい],
 [さやか の ソウルジェム は きれい でない],
 [まみ の ソウルジェム は きれい],
 [さやか は 魔女 です],
]

魔法会議_01=[魔法会議_0;魔法会議_1]
魔法会議_012=[魔法会議_01;魔法会議_2]

m0=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は きれい]],魔法会議_0)
m1=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は 濁っている]],魔法会議_1)
m2=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は 濁っている]],魔法会議_2)
m3=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は 濁っている],[:x は 魔女 です]],魔法会議_2) 

mn0=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は きれい でない]],魔法会議_0)
m1n=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は きれい でない]],魔法会議_1n)
m2n=solveQ([:x,:y,:z],[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は きれい でない],[:x は 魔女 です]],魔法会議_2n)

### 推論
#==
1. [:x は きれい でない] <=> [:y の ソウルジェム は きれい　でない] => :x <- [:y の ソウルジェム]
2. [:x は 濁っている] <= [:x は きれい でない]
3. [:x は きれい でない] => [:y の ソウルジェム は きれい でない] 


==#
N=[:x,:y,:z]
Q0=[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は 濁っている],[:x は 魔女 です]]
Q1=[[:x は ソウルジェム を 持っている],[:x の ソウルジェム は きれい でない],[:x は 魔女 です]]

