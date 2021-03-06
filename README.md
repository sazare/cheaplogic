# cheaplogic(experimental)

0. lisp/rubbish is an implementation of the proof analyzer.
  Proof analyzer means not only prover but also analyer for many proofs and many axiom systems.
  It is just experimental tools.

-- previous activities are..
1. LogicalWorld
 A propositional inference system. 
 I intended a query-answer system on the facts of the World.
 The system is very restricted first order.
 Key concepts: axioms x model matrix, mgu vector is a model.
 
2. Prover(Julialang)
 A simpleprover based on resolution principle. 
 Intended to get all proofs from given axioms.
 simpleprover run on specified search space.
 But sometimes, it falls into an infinite loop which made no new resolvents.

3. viewprover has GUI interaction with a user.(Julialang)
 viewprover uses Genie.jl for Web Interface.
 It is a prover in sense of it tries to find one []. But it requires some help of human.
 


