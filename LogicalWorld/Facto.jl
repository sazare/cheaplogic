# Facto.jl
# Like a Herbrand Universe and Quereis on it

global flog = stdout

"""
is t a var?
"""
isvar(N, t)= t in N

"""
index of var in N
"""
function vix(N,t)
    findall(map(x->x==t,N))
end

"""
apply a substitution (N,V) to a atomic term t
"""
function subst(N,t,V)
    if !isvar(N,t); return t end
    ix = vix(N, t)
    if V[ix[1]] == N[ix[1]]; return t
    else; return V[ix[1]]
    end
end

"""
apply a substitution to q
"""
function substitution(N,q,V)
    map(t->subst(N,t,V),q)
end

"""
apply a substitution to Q
"""
function substitutionQ(N,Q,V)
    map(q->substitution(N,q,V),Q)
end

"""
apply a unify t1 with t2
"""
function unifytt(N,t1,t2)
 if t1 == t2; t2
 elseif isvar(N,t1); t2
 elseif isvar(N,t2); t1
 else false
 end
end

"""
unify of q and f
"""
function unifyqf(N,q,f)
 R=deepcopy(N)
 if length(q)!=length(f); return false end
 for ix in 1:length(q)
  t1=q[ix]
  t2=f[ix]
  nt=subst(N,t1,R)
  if nt == t2; continue end
  if !isvar(N,nt)
   if !isvar(N,t2); return false end
  else # nt!=t2
   os = R[vix(N,t1)][1]
   vs = N[vix(N,t1)][1]
   if (os != t2) && (os != vs)
    return false
   end
@show N,nt,vix(N,nt)
@show R,t2,R[vix(N,nt)]
   R[vix(N,nt)[1]]=t2
  end
 end
 return R
end

"""
apply a unify m1 to m2
"""
function unifymm(N,m1,m2)
println(flog,"unifymm<m1,m2=$m1,$m2")
 if m2 == N; return m1 end
 nm = []
 for i in 1:length(m1) 
  t1,t2 = m1[i],m2[i]
  utt=unifytt(N,t1,t2)
  if utt == false; return false end
  push!(nm,utt)
 end
 return nm
end

"""
unify m and M
"""
function unifymM(N,m,M)
 if N==m; return M end
 if isempty(M); return [m] end
 rM=[]
 for m2 in M
  rm = unifymm(N,m,m2)
  if rm == false
   continue
  elseif isempty(rm)
   push!(rM,m)
  elseif rm==N
   continue
  else
   push!(rM,rm)
  end
 end
 rM
end

"""
unify M and M'
"""
function unifyMM(N,M1,M2)
 if isempty(M1); return M2 end
 if isempty(M2); return M1 end
 rM =[]
 for m1 in M1
  M12=unifymM(N,m1,M2)
  append!(rM,M12)
 end
 return rM
end

#=-
"""
unify members of M
"""
function unifyM(N, M)
 if isempty(M); return [N] end
 newM = [M[1]]
 if length(M)==1; return newM end
 for m in M[2:end]
  newM = unifymM(N,m,newM)
 end
 newM
end
==#

"""
find solution in K for q
"""
function solveq(N,q,K)
 M=[]
 for k in K
   am = unifyqf(N,q,k)
   if am==false; continue
   else push!(M,am) end
 end
 uM=unique(M)
 if isempty(uM); return false end
 return uM
end


"""
solve q with M
"""
function solveqM(N,q,M,K)
 rM = []
 if isempty(M)
  rM = solveq(N,q,K)
  return rM
 end
 for m in M
  bm=deepcopy(m)
  qq = substitution(N,q,bm)

  nM = solveq(N,qq,K)
  if nM==false; continue end

  rrM = unifymM(N,bm,nM)  ## replace bm with rrM
  if rrM==false; continue end

   append!(rM, rrM)
 end
 urM=unique(rM)
 if isempty(urM); return false end
 return urM
end


"""
make all models of qxf
"""
function makemodels(N,Q,K)
 MQ = Array{Any,2}(undef,length(K),length(Q))
 for ki in 1:length(K)
 for qi in 1:length(Q)
  MQ[ki,qi] = unifyqf(N,Q[qi],K[ki])
 end
 end
 return MQ
end

"""
reduction from MQ to models
"""
function reduction(N,mp,MFQ,qi)
println(flog,"reduction<mp,qi=$mp,$qi")
 if qi > size(MFQ,2); return [mp] end
 rM=[]
 for fi in 1:length(MFQ[:,qi])
println(flog,">fi=$fi")
  if MFQ[fi,qi] == false
   continue
  end
  mi = unifymm(N,mp, MFQ[fi,qi])  
println(flog,"unifymm>mi=$mi")
  if mi == false
   continue
  end

  Mi = reduction(N,mi,MFQ,qi+1)
println(flog,"reduction>Mi=$Mi")
  if Mi==false
    return false
  else
    append!(rM, Mi)
  end
 end
 return rM
end

"""
new solveQ solve Q
"""
function solveQ(N,Q,K)
println(flog,"solveQ<Q=$Q")
 MFQ=makemodels(N,Q,K)
#println(flog,"makemodels>MFQ=$MFQ")
 rr=reduction(N,N,MFQ,1)
println(flog,"solveQ>rr=$rr")
 return rr
end


### END of main funcions
"""
statements of query true
"""
function findFact(N,q,K)
 M=solveq(N,q,K)
 if isempty(M) || M == false
   print(statement(N,[q],N))
   println(" IS FALSE")
 else
   return(statements(N,[q],M))
 end
 return(:negative)
end

### UI
"""
convert q to statement
"""
statement(N,q,m) = substitution(N,q,m)

"""
make statements from Q and M
"""
function statements(N,Q,M)
 rM = []
 for am in M
 for aq in Q
  push!(rM, statement(N,aq,am))
 end
 end
 unique(rM)
end
"""
string statement
"""
function stringT(F)
 r = ""
 for T in F
  for t in T
   r = r * " " * string(t) 
  end
 r = r * ".\n"
 end
 r
end

"""
print F in string mode
"""
function printF(F)
 if length(F) == 0
  println("[]")
 else
  print(stringT(F))
 end
end

"""
print queries  on models
"""
function printQM(N,Q,M)
 ss =statements(N,Q,M)
 printF(ss)
 println()
end

"""
print model
"""
function printm(m)
 if length(m) == 0
  println("[]")
  return
 end
 
 for t in m[1:end-1]
  print("$t,")
 end
 println("$(m[end])")
end

"""
print models
"""
function printM(M)
 for m in M
  printm(m)
 end
end

