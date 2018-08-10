# parser trial

PUNCTS = [',']
ispunc(x) = x in PUNCTS

DELIMS = ['.','(',')']
isdelim(x) = x in DELIMS
delimDict=Dict('.' => :dot, '('=>:lpar, ')'=>:rpar)

islpar(x) = x == '('
isrpar(x) = x == ')'
isdot(x)  = x == '.'

LSYMS = ['∀','∃','∨','∧','⇒','¬','≡']
islsym(x) = x in LSYMS

lsymDict=Dict(
'¬'=>:not,
'∀'=>:all,
'∃'=>:some,
'∨'=>:or,
'∧'=>:and,
'⇒'=>:imply,
'≡'=>:eqv
)

isforall(x) = x=="∀"
isexist(x)  = x=="∃"
isor(x)     = x=="∨"
isand(x)    = x=="∧"
isthen(x)   = x=="⇒"
isiff(x)    = x=="≡"
isnot(x)    = x=="¬"

function breaksym(str)
 ix = 1
 while ix <= lastindex(str)
  println(str[ix])
  ix = nextind(str, ix)
 end
end

function findsym(str, six)
  ix = six
  while ix<=lastindex(str)    &&
    	!isspace(str[ix]) &&
	!isdelim(str[ix]) &&
	!ispunc(str[ix])  &&
	!islsym(str[ix])
   ix = nextind(str, ix)
  end
  if ix == six; error("usage") end
  return(str[six:ix-1], ix-1)
end

# sample code for tokenizer
function tokenizer(str)
 ix = 1 
 toklist = []
 nx = 0
 while ix <= lastindex(str)
   c = str[ix]
   if isspace(c);
   elseif ispunc(c);
   elseif isdelim(c)
     push!(toklist,delimDict[c])
   elseif islsym(c)
     push!(toklist,lsymDict[c])
   else
     sym,ix = findsym(str, ix)
     push!(toklist,Symbol(sym))
   end

   ix = nextind(str, ix)

 end
 return toklist
end

function parser(str)
 strn = str
 ix = 1 

 toklist = []
 while ix < length(str)
   nx = findnext(SEPRS, str, ix)
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
     block,nnx = parser(str[nx+1:end])
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

