# sample code for the future

function help()
 println("--- help")
 println("? shows help")
 println("end finish this loop")


 println("--- end of help")
end

function repl()
 print("> ")
 for line in eachline()
  if line == "end"; return
  elseif line == "?"; help()
  else
   println(line)
  end
  print("> ")
 end
end

