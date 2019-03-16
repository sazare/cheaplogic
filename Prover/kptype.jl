# basics for keyword system


# KPExpr
mutable struct KPExpr
 op   :: Symbol
 args :: Dict{Symbol, Any}
end

kpequal(x::KPExpr, y::KPExpr) = x.op == y.op && x.args == y.args

# MyExpr
BigExpr = Union{Expr, KPExpr, Symbol, Number}

