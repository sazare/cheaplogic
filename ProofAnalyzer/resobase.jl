# basics for resolution
#
function make_binding2(vl1, vl2)
	if length(vl1) != length(vl2); return end
  b = Dict()
  for ix in 1:length(vl1)
    v1 = vl1[ix] 
    v2 = vl2[ix]
    b[v1] = v2
  end
  return b
end

function represent_term(b, tm)
  ix = get(b, tm, 0)
  if ix == 0; return tm end
  return ix
end

function represent_as(b, exp)
  nexp = []
  for tm in exp
    push!(nexp, represent_term(b, tm))
  end
  return nexp
end

