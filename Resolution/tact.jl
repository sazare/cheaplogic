# tactical operation

include("reso.jl")

#==
 All literals of resolvents have the root literal in the 
input clauses. 
 A literal in a resolvent is determined by the input 
literal and the substituion σ by previous resolutions.

 A step of proof is determined by a resolved literal pair.

 Literal ID(lid) is a unique id for all input literals.

==# 

#==
 A step : (rid llid rlid σ lid_i...)
  rid        : resolvent id
  method     : :resolution, :reduction
  llid, rlid : literal id
  σ          : substitution of llid, rlid
  lid_i      : lid_i of the resolvent. input clause's lid.

#primitive operations
 lid to cid  : in core
 cid to lid* : in core
 cid to vars : in core
 rid to vars : in core


==#
"""
Definition
"""
struct PSTEP
  op::Symbol
  rid::Symbol  # :Rk
  llid::Symbol # :Ln
  rlid::Symbol # :Lm
  sigma::Tlist
end

#==
"""
Functions
"""
function makeastep(op, rid, 1lid, rlid, sigma)
 return ProofStep(:resolution, rid, llid, rlid, sigma)
end

function makeastep(op, vars, c1, l1, l2, r, sigma)
 return ProofStep(:reduction, rid, llid, rlid, sigma)
end


### printing

function printliteral(lit)
 print(lit)
end

function printclause(cls::Clause)
 if isempty(cls)
  print("□")
 else
  for lit in cls
   printliteral(lit)
  end
 end
end

function printclause(cid, core)
 vars,cls = getcls(cdb, cid)
 print("$cid:")
 printvars(vars)
 print(".")
 printclause(cls)
end

function printastep(step, db)
  print("$(step.op): ")
  if step[1] == :resolution 
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

function printproof(proof, db=[])
 for ix in 1:size(proof,1)
  printastep(proof[ix,:][1], db)
 end
end


==#

