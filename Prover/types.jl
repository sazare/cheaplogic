# types.jl

## Exceptions
"""
Exception for ununifiable terms in subst
"""
struct ICMPIn
 left
 right
 subst
 op
end

"""
Exception for ununifiable terms
"""
struct ICMP
 left
 right
 op
end

struct Loop
 left
 right
 op
end

"""
Valid
"""
struct VALID
 lid
 op
end

