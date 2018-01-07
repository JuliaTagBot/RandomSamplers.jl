using Distributions

function sliceSampleStep(logf, x0, y0, w=1.0)
    newy = y0 + log(rand())

    # step outward
    L = x0 - w * rand()
    R = L + w
    yL = logf(L)
    yR = logf(R)
    while yL > newy || yR > newy
        if rand(Bool)
            L -= R - L
            yL = logf(L)
        else
            R += R - L
            yR = logf(L)
        end
    end

    #Step inward
    x = rand(Uniform(L, R))
    y = logf(x)
    while y < newy
        if x < x0
            L = x
            yL = logf(L)
        else
            R = x
            yR = logf(R)
        end
        x = rand(Uniform(L, R))
        y = logf(x)
    end

    return (x, y)
end


function sliceSample(logf, n, x0=0.0, y0=0.0, w=1.0)
    (x,y) = (x0,logf(x0))
    xs = zeros(n)
    for i in 1:n 
        (x,y) = sliceSampleStep(logf, x, y, w)
        xs[i] = x
    end

    return xs
end

function test(n)
    sliceSample(x -> logpdf(Normal(),x), n)
end

x = test(10000)
scatter(x[2:10000],x[1:9999],α=0.1)