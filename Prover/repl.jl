# sample code for the future

function help()
 println("--- help")
 println("?   :shows help")
 println("end :finish this loop")
 println("core xx=cnf  : read core")
 println("prove xx n m : simpleprove(xx, n, m)")
 println("show xx      : show core")
 println("ls   xx      : ls xx")
 println("proofs xx    : show proofs of core")
 println("mgu   xx     : show mgus of core")

 println("--- end of help")
end

function proofsfn(args, core)
 name=separate(args)[1]
 printproofs1(core[name])
end

function mgusfn(args, core)
 no=separate(args)
 name = no[1]
 if length(no) == 2
   printmgus(core[name], true)
 else
   printmgus(core[name])
 end
end

function separate(str)
 sps = findall(isspace, str)
 s = 1
 tokens = []
 for e in sps
   push!(tokens, strip(str[s:e]))
   s=e
 end
 push!(tokens, strip(str[s:end]))
 tokens 
end

function provefn(args, cores)
 name,sns,snc =separate(args)
 ns, nc = parse(Int, sns), parse(Int, snc)
 if ns == 0 || nc == 0; reuturn end
 try 
  rcore = simpleprovercore(cores[name], ns, nc)[2]
  cores[name] = rcore
 catch 
  println("error in proving")
 end
end

function lsfn(args, cores)
 if args == ""
  run(`ls`)
 else 
  run(`ls $args`)
 end
end

function corefn(args, cores)
  eqix=findfirst(isequal('='), args)
  name=strip(args[1:(eqix-1)])
  cnf=strip(args[(eqix+1):end])
  print("cnf=$cnf => $name")
  core = readcore(cnf)
  cores[name] = core
end

function showfn(args, cores)
  printcore(cores[args])
end

commandmap = Dict(
 "help"  => :help,
 "ls"    => :lsfn,
 "core"  => :corefn,
 "show"  => :showfn,
 "prove" => :provefn,
 "proof" => :proofsfn,
 "mgu"   => :mgusfn
)

function repl()
 println("Now repl is experimental.")
 println("help show what commands are available")
 println("end exist the loop")
 println()
 print("> ")
 cores = Dict()
 for line in eachline()
 try
  if line == "end"; return
  elseif line == ""; 
  elseif line == "?"; help()
  elseif line == "help"; help()
  else
   cix = findfirst(isequal(' '), line)
   if cix == 0
     cmd = strip(line)
     args = ""
   else
     cmd = strip(line[1:cix])
     if cix == length(line)
       args = ""
     else
       args = strip(line[(cix+1):end])
     end
   end

   if cmd != ""
     eval(Expr(:call, commandmap[cmd], args, cores))
   end

  end
  catch e
   println(e)
  end
  print("> ")
 end
end

#==
function repl0()

 print("> ")
 vars = Dict()
 for line in eachline()
 try
  if line == "end"; return
  elseif line == "?"; help()
  elseif line == "help"; help()
  elseif line[1:2] == "ls"
   if strip(line) == "ls"
    run(`ls`)
   else 
    dir=strip(line[3:end])
    run(`ls $dir`)
   end
  elseif line[1:4] == "core"
   eqix=findfirst(isequal('='), line)
   cnf=strip(line[(eqix+1):end])
   name=strip(line[5:(eqix-1)])
   print("cnf=$cnf => $name")
   core = readcore(cnf)
   vars[name] = core
  elseif line[1:4] == "show"
   name=strip(line[5:end])
   printcore(vars[name])
  else
   println(line)
  end
  catch e
   println(e)
  end
  print("> ")
 end
end
==#
