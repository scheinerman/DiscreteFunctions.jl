using DiscreteFunctions, SimpleDrawing, Plots, SimpleGraphs

import SimpleDrawing.draw


function func2graph(f::DiscreteFunction)
    n = length(f)
    G = IntGraph(n)
    for a=1:n
        b = f(a)
        if a!=b
            add!(G,a,b)
        end
    end
    embed(G,:combined)
    return G
end



function draw(f::DiscreteFunction)
    n = length(f)
    newdraw()

    G = func2graph(f)
    xy = G.cache[:GraphEmbedding].xy

    # xy = [ (n*sin(2*pi*t/n),n*cos(-2*pi*t/n)) for t=0:n-1 ]

    for j=1:n
        x,y = xy[j]
        draw_point(x,y,color=:black,marker=1)
        annotate!(1.1x,1.1y,text(string(j),6))
    end

    mu = 0.9
    for j=1:n
        fj = f(j)
        a,b = xy[j]
        c,d = xy[fj]
        if fj!=j
            draw_vector(mu*(c-a),mu*(d-b),a,b,color=:black)
        else
            draw_circle(a,b,0.1,color=:black)
        end
    end

    finish()
end
