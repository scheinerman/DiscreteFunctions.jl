using DiscreteFunctions, Base.Iterators
import Base.sqrt

# This code is for finding compositional square roots of functions.
# It is extremely inefficient!!!

"""
`all_functions(n)` returns a generator that produces all
`DiscreteFunctions` on `{1,2,...,n}`
"""
function all_functions(n::Int)
    @assert n>0 "Argument must be a positive integer"
    arg = (1:n for t=1:n)
    iter = product(arg...)
    (DiscreteFunction(collect(t)) for t in iter)
end

"""
`sqrt(f::DiscreteFunction)` returns a `DiscreteFunction`
`g` such that `g*g==f` or throws an error if no such `g` exists.
"""
function sqrt(f::DiscreteFunction)::DiscreteFunction
    n = length(f)
    gen = all_functions(n)
    for g in gen
        if g*g == f
            return g
        end
    end
    error("This function does not have a square root")
end

"""
`has_sqrt(f::DiscreteFunction)` checks if there is a function `g`
such that `g*g==f`. Returns `true` if so and `false` otherwise.
"""
function has_sqrt(f::DiscreteFunction)::Bool
    try
        g = sqrt(f)
        return true
    catch
        return false
    end
end


"""
`all_sqrts(f::DiscreteFunction)` returns an array consisting
of all `g` such that `g*g==f`.
"""
function all_sqrts(f::DiscreteFunction)
    n = length(f)
    gen = all_functions(n)
    [ g for g in gen if g*g==f ]
end
