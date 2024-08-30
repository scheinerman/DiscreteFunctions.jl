export sources

"""
`sources(f::DiscreteFunction)` returns a list of all inputs to `f`
that are not the output of `f`. That is, this is a list of the vertices
with out-degree 0 in the graph of `f`.
"""
function sources(f::DiscreteFunction)
    n = length(f)
    S = setdiff(Set(1:n), image(f))
    return sort(collect(S))
end
