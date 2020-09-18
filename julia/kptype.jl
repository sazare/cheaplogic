# basics for keyword system

KParam = Dict{Symbol,Any}
 
# KPAtom
mutable struct KPAtom
 Psym :: Symbol
 args :: KParam
end

# KPLiteral
mutable struct KPLiteral
 sign :: Any
 atom :: KPAtom
end

