# The goal of these methods is to determine the JCF of the matrix
# of tree functions.

using DiscreteFunctions, LinearAlgebra

function find_nonzero(v::Vector{T}) where T<:Real
    idx = findall(abs.(v) .> 0.1)
    return idx[1]
end

function cols2nums(NS::Matrix{T}) where T<:Real
    r,c = size(NS)
    idxlist = [ find_nonzero(NS[:,j]) for j=1:c ]
    return Set{Int}(idxlist)
end

"""
`null_vecs(A)`: We assume the nullspace of `A` is spanned by standard
basis vectors. This function determines which standard basis vectors
those are. The return is a set of integers.
"""
function null_vecs(A::Matrix{T})::Set{Int} where T<:Real
    NS = nullspace(A)
    return cols2nums(NS)
end

"""
`generalized_null(A)` computes the nullspace of `A`, `A^2`, `A^3`, and
so on. It returns the standard basis vectors of those nullspaces. The
first set is the nullspace of `A`. The second set contains the additional
vectors found in the nullspace of `A^2`, and so on.

`generalized_null(f)` is a short cut for `generalized_null(Matrix(f))`
"""
function generalized_null(A::Matrix{T}) where T<:Real
    found = Set{Int}()
    list  = Set{Int}[]
    k=1
    while true
        vecs = null_vecs(A^k)
        if length(vecs) == length(found)  # nothing new, we're done
            return list
        end

        newvecs = setdiff(vecs, found)
        push!(list, newvecs)
        found = vecs
        k += 1
    end
end

generalized_null(f::DiscreteFunction) = generalized_null(Matrix(f))
