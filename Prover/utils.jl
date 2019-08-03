# sort clause
#include("misc.jl")

# for equalclause, they should be sorted.
#==
function renamevarinlit(vars, lit)
# dont complete
 for v in vars
  lit = replace(lit, string(v), "*")
 end
 return lit
end

function gelit(var1,L1,var2,L2)
 sl1 = renamevarinlit(var1,string(L1))
 sl2 = renamevarinlit(var2,string(L2))
 return(sl1<=sl2)
end

# sort literals for uniquness
function sortcls(vars, cls)
 nargs=sort(cls, lt=(x,y)->gelit(vars,x,vars,y))
 return vars, nargs
end

==#
#### readclause
function adjustcano(cano)
 vcano = Dict{Symbol, Any}()
 for can in cano
  vcano[can.args[2].args[1].args[1].args[1]] = (can.args[1].args, can.args[2].args[1].args[1])
 end
 vcano
end

#from a file
function readclausefromfile(fname)
 lines=readlines(fname)
 clss = []
 proc = []
 cano = []
 for line in lines
  if length(line)>0
    if line[1]=='['
      push!(clss,Meta.parse(line))
    elseif line[1] == '&'
      push!(cano,Meta.parse(line[2:end]))
    elseif line[1] == '!'
      push!(proc,line[2:end])
    elseif line[1] == '<'
      iclss, iproc, icano = readclausefromfile(strip(line[2:end],[' ','\t']))
      append!(clss, iclss)
      append!(proc, iproc)
      append!(cano, icano)
    end
  end
 end
 vcano = adjustcano(cano)
 return clss, proc, vcano
end

function readkpclausefromfile(fname)
 lines=readlines(fname)
 clss = []
 proc = []
 for line in lines
  if length(line)>0
    if line[1]=='['
      push!(clss,kpparse(line))
    elseif line[1] == '!'
      push!(proc,line[2:end])
    elseif line[1] == '<'
      iclss, iproc = readkpclausefromfile(strip(line[2:end],[' ','\t']))
      append!(clss, iclss)
      append!(proc, iproc)
    end
  end
 end
 return clss, proc
end

function printcnf(fname)
 cnfs, proc, cano=readclausefromfile(fname)
 @show proc
 for p in proc
   println("!$p")
 end
println()
 for ix in 1:length(cnfs)
   cnf = cnfs[ix]
   println("$(cidof(ix)): $cnf")
 end
println("Canonical")
 for can in cano
   println("$(can)")
 end
end

#### readcore
function readcore(fname, cid=1)
 println("readcore fname=$fname")
 cls,proc,cano = readclausefromfile(fname)
 createcore(fname, cls, proc, cid, cano)
end

function readcoredir(dirname)
 cores = []
 for (r,ds,fs) in walkdir(dirname)
   for f in fs
     push!(cores,readcore("$r/$f"))
   end
 end
 cores
end


#### 
#iscap(x) = isuppercase(x[1])
#isinvar(x) = '!' == String(x)[end]

###
"""
 ltis "C2" < "C12"
"""
function ltid(id1::String, id2::String) 
 if length(id1) == length(id2) 
  return id1 < id2
 else
  return length(id1) < length(id2) 
 end
end

function ltid(id1::Symbol, id2::Symbol) 
 return ltid(string(id1), string(id2))
end


