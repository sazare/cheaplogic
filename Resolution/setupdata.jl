include("loadall.jl")

magia=readclausefromfile("magia.wff")
cmagi=createcore(magia)

data001=readclausefromfile("data001.wff")
cd001=createcore(data001)

#== 
# proof
 prg1=[PSTEP(:resolution, :R1, :L1, :L7, []),
       PSTEP(:resolution, :R2, :L6, :L2, []),
       PSTEP(:resolution, :R3, :L8, :L5, [])
      ]

 rdb001 = Dict( 
       :R1 => RForm2(:R1, [:y], :L1, :L7, [:a,:y], [:L6, :L8]),
       :R2 => RForm2(:R2, [:y], :L6, :L2, [:y], [:L8]),
       :R3 => RForm2(:R3, []  , :L8, :L5, [:c], [])
      ) 


printresolvent(:R1, rdb001, cd001)
println()
printclause(:C7, cd001)
==#

#==
### resolution step (image)
### NO NO NO
r1= resolution(:L1,:L7,cd001)
r2= resolution(:L6,:L2,cd001)
r3= resolution(:L8,:L4,cd001)
==#

