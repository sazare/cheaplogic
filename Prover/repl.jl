# sample code for the future

function usage(args, core)
 println(" > core c1 data/his001.cnf   # readcore from file to c1")
 println(" > core c2 data/his002.cnf")
 println(" > core c3 data/his001.cnf")
 println(" > prcore c1                 # printcore c1")
 println(" > prove c1 15 5             # simpleprove c1 with ns=15 and nc=5")
 println(" > prove c3 15 5")
 println(" > proof c1                  # show proofs of c1")
 println(" > mgu c1                    # show mgus of c1")
 println(" > mgu c1 t                  # show mgus of c1 with input vars")
 println("--- end of usage")
end

function help()
 println("help,?       : shows help")
 println("end          : finish this loop")
 println("core xx=cnf  : read core")
 println("prove xx n m : simpleprove(xx, n, m)")
 println("ls   xx      : ls xx")
 println("proofs xx    : show proofs of core")
 println("mgu   xx     : show mgus of core")
 println("cores        : show loaded core names")
 println("prcore xx    : print core")
 println("usage        : show sample command sequence")
 println("--- end of help")
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

function proofsfn(args, cores)
 name=args[1]
 printproofs1(cores[name])
end

function mgusfn(args, cores)
 name = args[1]
 if length(args) == 2
   printmgus(cores[name], true)
 else
   printmgus(cores[name])
 end
end

function provefn(args, cores)
 if length(args) >= 3
   name,sns,snc = args
 else 
   println("no max num of step and max num of contradictions")
   return
 end
 ns, nc = parse(Int, sns), parse(Int, snc)
 try 
  rcore = simpleprovercore(cores[name], ns, nc)[2]
  cores[name] = rcore
 catch 
  println("error in proving")
 end
end

function lsfn(args, cores)
 if 0 == length(args)
  run(`ls`)
 else 
  run(`ls $(args[1])`)
 end
end

function corefn(args, cores)
  name=args[1]
  cnf=args[2]
  println("cnf=$cnf => $name")
  core = readcore(cnf)
  cores[name] = core
end

# direct called functions
function prcore(args, cores)
  printcore(cores[args[1]])
end

function cores(args, cores)
  println(keys(cores))
end

commandmap = Dict(
 "help"  => :help,
 "ls"    => :lsfn,
 "core"  => :corefn,
 "prove" => :provefn,
 "proof" => :proofsfn,
 "mgu"   => :mgusfn
)

function repl()
 println("Now repl is exerimental.")
 println("help show what commands are available")
 println("end exist the loop")
 println()

 print("> ")
 
 cores = Dict()
 for line in eachline()
 try
  cmdline = separate(line)
  if cmdline[1] == "end"; return
  elseif cmdline[1] == ""; 
  elseif cmdline[1] == "#"; 
  elseif cmdline[1] == "?"; help()
  elseif cmdline[1] == "help"; help()
  else
   args = cmdline[2:end]
   cmd = strip(cmdline[1])
   if cmd in keys(commandmap)
     eval(Expr(:call, commandmap[cmd], args, cores))
   else
     eval(Expr(:call, Symbol(cmd), args, cores))
   end
  end
  catch e
   println(e)
  end
 print("> ")
 end
end

