#/bin/zsh 

sbcl --control-stack-size 128MB --userinit c008.lisp  --eval '(let()(readkqc "kqc/ml002.kqc")(print-clauses))'



