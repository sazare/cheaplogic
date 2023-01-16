#!/bin/zsh

./test-path --eval '(in-package :rubbish)' --eval '(test-graph 10 "kqc/path/graph201.kqc" (quote (c1)))' --eval '(sb-ext:exit)'
./test-path --eval '(in-package :rubbish)' --eval '(test-graph 10 "kqc/path/graph202.kqc" (quote (c1)))' --eval '(sb-ext:exit)'
./test-path --eval '(in-package :rubbish)' --eval '(test-graph 10 "kqc/path/graph203.kqc" (quote (c1)))' --eval '(sb-ext:exit)'

