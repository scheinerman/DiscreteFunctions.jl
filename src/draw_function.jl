using DiscreteFunctions, SimpleDrawing, Plots

import SimpleDrawing.draw

function draw(f::DiscreteFunction)
    n = length(f)
    newdraw()

    xy = [ (n*sin(2*pi*t/n),n*cos(-2*pi*t/n)) for t=0:n-1 ]

    for j=1:n
        x,y = xy[j]
        draw_point(x,y,color=:black,marker=1)
        annotate!(1.1x,1.1y,string(j))
    end

    mu = 0.95
    for j=1:n
        fj = f(j)
        a,b = xy[j]
        c,d = xy[fj]
        if fj!=j
            draw_vector(mu*(c-a),mu*(d-b),a,b,color=:black)
        else
            draw_circle(a,b,0.25,color=:black)
        end
    end

    finish()
end
