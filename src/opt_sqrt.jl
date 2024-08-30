using JuMP
using Cbc
using ChooseOptimizer
using DiscreteFunctions
using LinearAlgebra
import Base.sqrt

"""
`sqrt(g::DiscreteFunction)` returns a function `f` such that
`f*f==g` or throws an error if no such function exists.
This method uses integer linear programming.
"""
function sqrt(g::DiscreteFunction)::DiscreteFunction
    err_msg = "This function does not have a square root."
    n = length(g)
    B = Matrix(g)

    if !quick_sqrt_test(g)
        error(err_msg)
    end

    # options = Dict()
    # options[:logLevel] = 0

    MOD = Model(get_solver())

    @variable(MOD, a[1:n, 1:n], Bin)  # entry in A matrix
    @variable(MOD, w[1:n, 1:n, 1:n], Bin) # w[i,j,k] is a[i,j]*a[j,k]

    # this ensures w[i,j,k] is 0 if either a[i,j] or a[j,k] are
    for i = 1:n
        for j = 1:n
            for k = 1:n
                @constraint(MOD, a[i, j] >= w[i, j, k])
                @constraint(MOD, a[j, k] >= w[i, j, k])
            end
        end
    end

    # this ensures that the A matrix represents a function
    for i = 1:n
        @constraint(MOD, sum(a[i, j] for j = 1:n) == 1)
    end

    # this ensures that A^2 == B
    for i = 1:n
        for k = 1:n
            @constraint(MOD, sum(w[i, j, k] for j = 1:n) == B[i, k])
        end
    end

    # Turns out, we don't need to maximize the w's to get this to work!
    # @objective(MOD, Max, sum(w[i,j,k] for i=1:n for j=1:n for k=1:n))

    # try to solve
    optimize!(MOD)
    status = Int(termination_status(MOD))
    if status != 1   # if status isn't 1, the IP is not feasible, no sqrt
        error(err_msg)
    end

    # build the sqrt function from the A matrix
    A = Int.(value.(a))
    f = DiscreteFunction(n)
    for i = 1:n
        for j = 1:n
            if A[i, j] == 1
                f[i] = j
            end
        end
    end
    return f
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
`quick_sqrt_test(f::DiscreteFunction)` is a quick check of a necessary
condition for `f` to have a square root. If this returns `false` then `f`
does *not* have a square root. If it returns `true`, it might.
"""
function quick_sqrt_test(f::DiscreteFunction)::Bool
    evals = reduced_eigvals(f)
    d = real(prod(evals))
    return d > 0.5
end

function reduced_eigvals(A::Array{T,2}) where {T}
    elist = eigvals(A)
    return filter(x -> abs(x) > 1e-7, elist)
end

"""
`reduced_eigvals(f::DiscreteFunction)` returns the nonzero eigenvalues of
`f`'s matrix.
"""
function reduced_eigvals(f::DiscreteFunction)
    return reduced_eigvals(Matrix(f))
end
