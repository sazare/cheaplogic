# sample code for the future

function help()
 println("--- help")
 println("?   :shows help")
 println("end :finish this loop")
 println("core xx=cnf : read core")
 println("show xx     : show core")
 println("ls   xx     : ls xx")
 println("--- end of help")
end

function repl()
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
   eqix=search(line,'=')
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

