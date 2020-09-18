if VERSION < v"1"
  println("julia $VERSION is not supprted")
  return
end

global evalon = true
#global evalon = false

global trycount = 0
global succount = 0
