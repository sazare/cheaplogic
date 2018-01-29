# tactical operation

include("reso.jl")
#==
 in a case resolution, a picture...

 focus on one clause, and apply other clauses to it.
 does the resolvant become []?

 this is a basic scheme


 if in a case graph, because dont focus on a clause,
 the scheme may be not so clear. huum...


==# 

#==
 Proof :
 [(cid1,lid1), (cid2, lid2)]^*
 clauses= input + resolvents

 <(C1,i),(C2,j)> => (R,σ)
 <C1,i,j> => (R,σ)


 Proof find trace:
 trial and resolvents

 (C1,i),(C2,j) => fail
 (C1,k),(C2,m) => (R1,σ1)
 (R1,p,q) => (R2,σ2)
 (R1,r),(C3,1) => (complete,σ3)

 Proof:
 (C1,k):(C2,m) => (R1,σ1),p,q => ((R2,σ2),r),(C3,1) => ([], σ3)


 There are many intrinsic proofs.
 Finding all such proofs is difficult. It should require a graphic approach.
==#
"""
Definition
"""
struct Proofstep
  op::Symbol
  vars::Vlist
  c1::Clause
  ln1::Int
  c2::Clause
  ln2::Int
  resol::Clause
  sigma::Tlist
end


"""
Functions
"""
function makeastep(op, vars, c1, l1, ren1, c2, l2, ren2, r, sigma)
 return [:resolution, vars, (c1,l1,ren1), (c2,l2,ren2), (r,sigma)]
end

function makeastep(op, vars, c1, l1, l2, r, sigma)
 return [:reduction, vars, (c1,l1,l2), (r,sigma)]
end


### printing

function printliteral(lit)
 print(lit)
end

function printclause(cls::Clause)
 if isempty(cls.args)
  print("□")
 else
  for lit in cls.args
   printliteral(lit)
  end
 end
end

function printclause(cid::Int, cdb)
 vars,cls = getcls(cdb, cid)
 print("$cid:")
 printvars(vars)
 print(".")
 printclause(cls)
end

function printastep(step, db)
  if step[1] == :resolution 
    print("resolution: ")
    printclause(step[3][1])
    print("*")
    printclause(step[4][1])
    print("@($(step[3][2]),$(step[4][2]))")
    print("=>")
    printclause(step[5][1])
    print("|")
    printvars(step[5][2])
    println()
  elseif step[1] == :reduction 
    print("reduction: ")
    printclause(step[3][1])
    print("@($(step[3][2]),$(step[3][3]))")
    print("=>")
    printclause(step[4][1])
    print("|")
    printvars(step[4][2])
    println()
  else
    println("unknown")
  end
end

function printistep(step, db)
  if step[1] == :resolution 
    print("resolution: ")
    printclause(step[3][1],db)
    print("*")
    printclause(step[4][1],db)
    print("@($(step[3][2]),$(step[4][2]))")
    print("=>")
    printclause(step[5][1],db)
    print("|")
    printvars(step[5][2])
    println()
  elseif step[1] == :reduction 
    print("reduction: ")
    printclause(step[3][1],db)
    print("@($(step[3][2]),$(step[3][3]))")
    print("=>")
    printclause(step[4][1],db)
    print("|")
    printvars(step[4][2])
    println()
  else
    println("unknown")
  end
end


function printproof(proof, db=[])
 for ix in 1:size(proof,1)
  printastep(proof[ix,:][1], db)
 end
end

function printiproof(proof, db=[])
 for ix in 1:size(proof,1)
  printistep(proof[ix,:][1], db)
 end
end

