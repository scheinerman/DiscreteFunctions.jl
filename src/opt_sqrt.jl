using JuMP
using Cbc
using DiscreteFunctions
import Base.sqrt

"""
`sqrt(g::DiscreteFunction)` returns a function `f` such that
`f*f==g` or throws an error if no such function exists.
This method uses integer linear programming. It's reasonable
on smallish functions.
"""
function sqrt(g::DiscreteFunction)::DiscreteFunction
    err_msg = "This function does not have a square root."
    n = length(g)
    B = Matrix(g)

    options = Dict()
    options[:logLevel] = 0

    MOD = Model(with_optimizer(Cbc.Optimizer; opts=options) )

    @variable(MOD, a[1:n,1:n], Bin)  # entry in A matrix
    @variable(MOD, w[1:n,1:n,1:n], Bin) # w[i,j,k] is x[i,j]*x[j,k]

    for i=1:n
        for j=1:n
            for k=1:n
                @constraint(MOD, a[i,j]>=w[i,j,k])
                @constraint(MOD, a[j,k]>=w[i,j,k])
            end
        end
    end

    for i=1:n
        @constraint(MOD, sum(a[i,j] for j=1:n) == 1)
    end

    for i=1:n
        for k=1:n
            @constraint(MOD, sum(w[i,j,k] for j=1:n) == B[i,k])
        end
    end

    # @objective(MOD, Max, sum(w[i,j,k] for i=1:n for j=1:n for k=1:n))

    optimize!(MOD)

    status = Int(termination_status(MOD))
    if status != 1
        error(err_msg)
    end

    #println("status = $status")
    #val = objective_value(MOD)
    #println("objective value = $val")

    A = Int.(value.(a))

    f = DiscreteFunction(n)
    for i=1:n
        for j=1:n
            if A[i,j]==1
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
