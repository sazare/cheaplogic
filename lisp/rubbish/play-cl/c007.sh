#/bin/zsh 

sbcl --control-stack-size 128MB --userinit c007.lisp  --eval '(rubbish:print-clauses)'

