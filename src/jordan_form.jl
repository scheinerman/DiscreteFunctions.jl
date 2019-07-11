# The goal of these methods is to determine the JCF of the matrix
# of tree functions.

using DiscreteFunctions, LinearAlgebra, Counters, SimpleTools

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
        newvecs = vecs
        push!(list, vecs)
        found = vecs
        k += 1
    end
end

generalized_null(f::DiscreteFunction) = generalized_null(Matrix(f))

"""
`jordan(A::Matrix)` or `jordan(f::DiscreteFunction)` reports the Jordan structure
for the zero eigenvalues of `A` or `Matrix(f)`.
"""
function jordan(A::Matrix{T}) where T<:Real
    sets = generalized_null(A)
    n = length(sets)
    r = length.(sets)
    s = 0r
    s[1] = r[1]
    for j=2:n
        s[j] = r[j]-r[j-1]
    end
    m = 0s

    for j=1:n-1
        m[j] = s[j]-s[j+1]
    end
    m[n] = s[n]

    blocks = Counter{Int}()
    for j=1:n
        blocks[j] += m[j]
    end

    return blocks
end

jordan(f::DiscreteFunction) = jordan(Matrix(f))

function _zero_block(k::Int)
    A = zeros(Int,k,k)
    for j=1:k-1
        A[j,j+1]=1
    end
    return A
end

"""
`jordan_report(f::DiscreteFunction)` provides information about
the JCF of `Matrix(f)` where we assume `f` is a tree function.
The JCF is returned. We assume `f` has exactly one eigenvalue equal
to 1 and the rest of the eigenvalues are 0s.
"""
function jordan_report(A::Matrix{T}) where T<:Real
    counts = jordan(A)
    nc = length(counts)
    for j=1:nc
        if counts[j]>0
            println("$(counts[j]) Jordan blocks of size $j")
        end
    end

    JCF = ones(Int,1,1)
    for j=nc:-1:1
        for a = 1:counts[j]
            JCF = dcat(JCF,_zero_block(j))
        end
    end


    return JCF
end
jordan_report(f::DiscreteFunction) = jordan_report(Matrix(f))
