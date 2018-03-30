# parser trial

SEPRS = [' ',',','.','(',')']
islpar(x) = x == '('
isrpar(x) = x == ')'
isdot(x) = x == '.'

issepr(x) = x in SEPRS
isforall(x) = x == "forall"
isexist(x) = x == "exist"
isor(x) = x == "or"
isand(x) = x=="and"
isthen(x) = x=="then"
isiff(x) = x=="iff"
isnot(x) = x=="not"


# sample code for tokenizer
function tokenizer(str)
 @show str
 strn = str
 ix = 1 

 toklist = []
 while ix < length(str)
   nx = search(str, SEPRS, ix)
   if nx == 0
     tok=strip(str[ix:end])
     println("$(tok)")
     push!(toklist,Symbol(tok))
     return toklist
   end
   tok=strip(str[ix:(nx-1)])
   if !all(isspace, tok)
     println("$(tok)")
     push!(toklist,Symbol(tok))
   end
   sep=str[nx]
   if islpar(sep); 
     println("(")
     push!(toklist, :lpar)
   end
   if isrpar(sep)
     println(")")
     push!(toklist, :rpar)
   end
   if isdot(sep)
     println(".")
     push!(toklist, :dot)
   end
#   println("sep=$(str[nx])")
   ix = nx+1
 end
 return toklist
end

function parser(str)
 @show str
 strn = str
 ix = 1 

 toklist = []
 while ix < length(str)
   nx = search(str, SEPRS, ix)
   if nx == 0
     tok=strip(str[ix:end])
     println("$(tok)")
     push!(toklist,Symbol(tok))
     return toklist,length(str)
   end
   tok=strip(str[ix:(nx-1)])
   if !all(isspace, tok)
     println("$(tok)")
     push!(toklist,Symbol(tok))
   end
   sep=str[nx]
   if islpar(sep); 
     println("(")
@show nx
     block,nnx = parser(str[nx+1:end])
@show block,nx,nnx
     nx = nx + nnx + 1
     push!(toklist, block)
   end

   if isrpar(sep)
     println(")")
     return toklist, nx
   end

#   println("sep=$(str[nx])")
   ix = nx+1
 end
 return toklist, ix
end

