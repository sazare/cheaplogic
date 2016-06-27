# asmacros.R

evaltime<-function(e__e, label="elapsed time"){
  t0=Sys.time()
  eval(e__e, parent.frame())
  t1=Sys.time()
  laptime=t1-t0
  cat(sprintf("\n%s: %s ==> %s \n", label, deparse(e__e), format(laptime)))
  laptime[[1]]
}

function(){
  library(testthat)
  ff<-function(x,y){
    x*y
  }
  x=3
  expect_lte(evaltime(quote(for (x in 1:10000) cat(ff(x,x)))), 1) # should less than 1sec
}
