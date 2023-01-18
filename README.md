# cheaplogic(experimental)

0. lisp/rubbish is an implementation of a proof analyzer.
  'Proof analyzer' contains not only prover but also tools for analyzing proofs. 

  How to write something in FOL is my basic interests. The tools are for.
  rubbish/kqc contains such something example files written with 'clause form'.
   ex. Twenty Questions(20 doors in japanse), flush light, finding paths of a graph, etc.

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
 


