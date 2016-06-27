#primes.R
library(combinat)

raising<-function(p,x){
  for(i in 1:x){
    if(0==(x %% p)) {
      x<-x/p
    }else{
      return(i-1)
    }
  }
}

function(){
  raising(2,4)
  raising(2,8)
  raising(2,12)
  raising(2,3)
}

# this is for examining 
factoring<-function(x){
  first<-TRUE
  for(p in 2:x){
    n <- raising(p, x)
    if(0!=n){
      if(first){
        first<-F
      }else{
        cat("*",sep="")
      }
      cat(sprintf("%d^%d", p, n))
      x<-x/(p*n)
    }
  }
  cat(fill=T)
}

function(){
  factoring(2)
  factoring(4)
  factoring(6)
  factoring((2*3*5*7*11*13)+1)
}

# is.prime is a poor algorithm
# i assume the x <=9999, so enough
is.prime<-function(x){
  if(x<=1){return(FALSE)}
  p<-2
  while(p <= (x-1)){
    if(0==(x %% p)){
      return(FALSE)
    }else{
      p<-p+1
    }
  }
  return(TRUE)
}

function(){
  library(testthat)
  expect_true(is.prime(2))
  expect_true(is.prime(3))
  expect_false(is.prime(4))
  expect_true(is.prime(5))
  expect_true(is.prime(7))
  expect_false(is.prime(9))
  expect_true(is.prime(11))
  expect_true(is.prime(13))
  expect_true(is.prime(17))
  expect_true(is.prime(19))
  expect_true(is.prime(23))
  expect_false(is.prime((2*3*5*7*11*13)+1))
}

function(){
  source("asmacros.R")
  expect_lte(evaltime(quote(for (x in 1:9999) is.prime(x)), 6))
}

# NYI
comb.num<-function(nlist){
  as.numeric(permn(nlist, function(x){x[[1]]*1000+x[[2]]*100+x[[3]]*10+x[[4]]}))
}

find.4prime<-function(nlist){
  nnum<-length(nlist)
  
  combi<-comb.num(nlist)
  combi[sapply(combi, is.prime)]
  
}
function(){
  library(testthat)
  expect_equal(find.4prime(c(3,6,9,0)),numeric(0))
  expect_equal(find.4prime(c(2,4,8,0)),numeric(0))
  expect_equal(find.4prime(c(0,0,0,0)),numeric(0))
}
function(){
  find.4prime(c(0,4,2,1))
  find.4prime(c(2,3,5,7))
  
}
