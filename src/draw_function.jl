using DiscreteFunctions, SimpleDrawing


function draw_function(f::DiscreteFunction)
    n = length(f)
    newdraw()

    xy = [ (n*sin(2*pi*t/n),n*cos(-2*pi*t/n)) for t=0:n-1 ]

    for j=1:n
        x,y = xy[j]
        draw_point(x,y,color=:black,marker=3)
        annotate!(1.1x,1.1y,string(j))
    end

    mu = 0.95
    for j=1:n
        fj = f(j)
        a,b = xy[j]
        c,d = xy[fj]
        draw_vector(mu*(c-a),mu*(d-b),a,b,color=:black)
        # draw_segment(a,b,mu*c,mu*d,arrow=:arrow,color=:black,linewidth=2)
    end

    finish()
end
