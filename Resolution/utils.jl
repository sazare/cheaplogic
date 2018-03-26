# sort clause
include("misc.jl")

# for equalclause, they should be sorted.

function renamevarinlit(vars, lit)
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

#### readclause

#from a file
function readclausefromfile(fname)
 lines=readlines(fname)
 clss = []
 proc = []
 for line in lines
  if length(line)>0
    if line[1]=='['
      push!(clss,parse(line))
    elseif line[1] == '!'
      push!(proc,line[2:end])
    elseif line[1] == '<'
      append!(clss, readclausefromfile(strip(line[2:end],[' ','\t'])))
    end
  end
 end
 return clss, proc
end

function printcnf(fname)
 cnfs, proc=readclausefromfile(fname)
 @show proc
 for p in proc
   println("!$p")
 end
println()
 for ix in 1:length(cnfs)
   cnf = cnfs[ix]
   println("$(cidof(ix)): $cnf")
 end
end

#### readcore
function readcore(fname)
 println("readcore fname=$fname")
 cls,proc = readclausefromfile(fname)
 createcore(fname, cls, proc)
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
iscap(x) = isupper(x[1])

