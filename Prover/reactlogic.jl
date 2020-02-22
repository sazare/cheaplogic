# reactive logic is logic based on dynamic updated Axioms.
#==
 A inductive system M generate a fact and puts it in the axiom set of core.
 Then the system let reactive wake to do step forward.
 react progress a proof from g with the axiom of core.

 ! important !!
 while dvc-reso, all literals are included in input core.
 But if I added a fact to core, it means some new literals arrive.
==#

"""
react do step on g with core
react: g, core -> [r], core
forall a in core, add r = g x a to core when it exists.
"""
function react(g, core)

end


"""
update puts a fact to core
add clause f to cdb, literals of f to ldb, and more.
"""
function update(f, core)

end

"""
repl for react logic
"""
function repl()


end

"""
hasacontradiction in some goal
"""
hasacontradiction(goal) = any(isempty(x) for x in goal)

