
#==
NOTATION:
t : means a term constant or varialbe.(not contains function form)
    variables are quantified by our functions.
    as N, V below.
v : a variable
c : a constant

T : means a statement, a list of t

F : means a Fact. is a T without variables
K : is a set of F. called Knowledge.

q : called query. is a T with variables.
Q : is a list of q

## from here, Upper case means list of lower case.

N : is a variable names vector
V : is a vector of T whose length is equal to N
(N,V) : means a substitution(n_i <- v_i)
        n_i <- n_i is an empty substitution

M : is called models. like query, a vector of literals.
S : is called solutions for Q on K

Q, M, S all have same syntax.

