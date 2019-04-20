## merge substitutions
#include("reso.jl")


# this will be used in proving with graph
# not yet implemented

"""
this merge may be a unfiy
"""
function merge(vars::Vlist, t1::Symbol, t2::Symbol)
 if t1==t2; return t1 end
 if isvar(t1,vars) && isvar(t2,vars)
   return t2
 elseif isvar(t1,vars)
   return t2
 elseif isvar(t2,vars)
   return t1
 else
   throw(ICMP(t1,t2,:merge))
 end
end

"""
merge unifys 2 to 1 for substituions
"""
function merge(vars::Vlist, sub1::Tlist, sub2::Tlist)
 if length(sub1) != length(sub2); throw(ICMP(sub1,sub2,:merge)) end
 s1=apply(vars,sub1,sub2) # is s1 == sub1??
 ss=apply(vars,sub2,s1)
 s2=apply(vars,sub1,ss)
 narg=[]
 for i in 1:length(sub1)
   mi = merge(vars, ss[i], s2[i])
   if ndims(sub1) == 1
     narg = vcat(narg,[mi])
   else
     narg = hcat(narg,[mi])
   end
 end 
 narg
end
