
include("/home/chad/jlTools/Slice.jl")

using StatsFuns
using Plots
using Distributions
pyplot() 

function randSphere(d)
    x = randn(d)
    return x / vecnorm(x)
end

function hitrunStep(logf, x0, y0)
    v = randSphere(size(x0))
    logf1 = k ->  logf((x0 .+ k .* v))
    (k, y) = sliceStep(logf1, 0.0, y0, 1.0)
    x = x0 .+ k .* v
    (x, y)
end


function test(n)
    xs = zeros(n,2)
    logf = x -> logpdf(MvNormal(2,1.0), x)
    x = zeros(2)
    y = logf(x)
    for i in 1:n
        (x,y) = hitrunStep(logf, x, y)
        xs[i,:] = x
    end
    xs
end

x = test(1000)