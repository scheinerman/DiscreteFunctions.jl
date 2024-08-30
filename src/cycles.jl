export cycles

function _find_cycle(f::DiscreteFunction, s::Int)
    hits = Set{Int}()
    push!(hits, s)
    current = s

    while true
        current = f(current)
        if in(current, hits)  # we found a cycle!
            result = Array{Int,1}()
            push!(result, current)
            while true
                current = f(current)
                if current == result[1]
                    return result
                end
                push!(result, current)
            end
        end
        push!(hits, current)
    end
    error("This can't happen")
end

function _standardize_cycle(c::Array{Int,1})
    (x, idx) = findmin(c)
    front = c[idx:end]
    back = c[1:idx-1]
    return vcat(front, back)
end


"""
`cycles(f::DiscreteFunction)` returns a list of the cycles in `f`.
"""
function cycles(f::DiscreteFunction)::Array{Array{Int,1},1}
    result = Set{Array{Int,1}}()

    n = length(f)
    for s = 1:n
        c = _find_cycle(f, s)
        c = _standardize_cycle(c)
        push!(result, c)
    end

    return sort(collect(result))
end
