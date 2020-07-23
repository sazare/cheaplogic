# cheaplogic(experimental)

1. LogicalWorld
 A propositional logic system. I intended a query-answer system on the facts of the World.
 The system is very restricted first order.
 Key concepts: axioms x model matrix, mgu vector is a model.
 
2. Prover
 A simpleprover based on resolution principle. 
 Intended to get all proofs from given axioms.
 simpleprover run on specified search space.
 But sometime, it falls into an infinite loop which made no new resolvents.

3. viewprover has GUI interaction with a user.
 viewprover uses Genie.jl for Web Interface.
 It is a prover in sense of it tries to find one []. But it requires some help of human.
 
 
4. Prover/bterm/lisp/rubbish is current implementation of prover over lisp.
