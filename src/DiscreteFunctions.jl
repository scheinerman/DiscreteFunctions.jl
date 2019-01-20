module DiscreteFunctions

import Base: length, show, getindex, setindex!, *, ^

export DiscreteFunction

struct DiscreteFunction
    data::Vector{Int}
    N::Int
    function DiscreteFunction(a::Vector{Int})
        if minimum(a)<1
            error("All function values must be positive")
        end
        n = max(length(a), maximum(a))
        data_ = ones(Int,n)
        for j=1:length(a)
            data_[j] = a[j]
        end
        new(data_,n)
    end
end

length(f::DiscreteFunction) = f.N

(f::DiscreteFunction)(x::Int) = f.data[x]
getindex(f::DiscreteFunction, x::Int) = f.data[x]

function setindex!(f::DiscreteFunction, val::Int, x::Int)
    n = length(f)
    if val < 1 || val > n
        error("Invalid value $val for x=$x; must be between 1 and $n")
    end
    f.data[x] = val
end

function show(io::IO, f::DiscreteFunction)
    n = length(f)
    A = zeros(Int,2,n)
    for i=1:n
        A[1,i] = i
        A[2,i] = f.data[i]
    end
    print(io,A)
end

function (*)(f::DiscreteFunction, g::DiscreteFunction)
    n1 = length(f)
    n2 = length(g)
    if n1 != n2
        error("Cannot compose `DiscreteFunction`s of different lengths")
    end
    data = zeros(Int,n1)
    for j=1:n1
        data[j] = f(g(j))
    end
    return DiscreteFunction(data)
end 

end  # end of module
