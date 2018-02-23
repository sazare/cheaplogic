# sort clause

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
 for line in lines
  if (length(line)>0)&&(line[1]=='[')
   push!(clss,parse(line))
  end
 end
 return clss
end

#### readcore
function readcore(fname)
 cls = readclausefromfile(fname)
 createcore(cls)
end

