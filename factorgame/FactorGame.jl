module FactorGame 

#=
[factor game]
Let’s consider a game.
First, choose a number for example 16. 
From this number, make a new number as getting the factor of 16 is 2x2x2x2, 
then the new number is 2222.
From 2222, make a new number as same rule. Namely, it will be 2x11x101 then, 
the number is 211101. 
Next number is 3116397, and the last one is 31636373. 
Why this is the last because it is a prime number.

My question is from any number, does this procedure make a prime?

If any prime number  is reached, the procedure will continue infinitely. 
Is this true?

=#

export shiftnum, samenum, factornum, factorgame

using Primes

 function shiftnum(d1::Integer, d2::Integer)
  dg=strwidth(string(d2))
  convert(Integer,d1*10^dg+d2)
 end
 
 function samenum(dn::Integer, pw::Integer, res::Integer)
  for i in 1:pw
    res=shiftnum(res, dn)
  end
  return(res)
 end
   
 function factornum(num::Integer)
  if (num==0) return(0) end
  if (num==1) return(1) end
  res=0
  fact=factor(num)
  ikeys = sort(collect(keys(fact)))
  for key in ikeys
    res=samenum(key, fact[key], res)
  end
  return(res)
 end
 
# function factorgame(num::BigInt; loopmax=500, log=false)
 function factorgame(num::Integer; loopmax=500, log=false)
  fn = num
  if num <= 1
    print("$num is less than 2\n")
    return(0)
  end
 
  if log print("$fn>>") end
  for i in 1:loopmax
   fn = factornum(fn)
   if (isprime(fn))
     if log print("$fn prime!!\n") end
     return(fn)
   else
     if log print("$fn>") end
   end
  end
  print("$num : $loopmax looped!!\n")
  fn
 end
 
end

 
