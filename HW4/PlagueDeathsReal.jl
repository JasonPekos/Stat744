using MCMCChains, StatsPlots, Turing, Distributions, DifferentialEquations, Random, CSV, DataFrames

Random.seed!(969)

#= 
returning to a classic — fitting an SIR model to the deaths time series fromt the great plague
from math 4MB3

last time I did this, I did this with a rough grid search over the entire parameter space

this time I'll use MCMC
=#

df =  DataFrame(CSV.File("great_plague.csv"))
dat = cumsum(df.plague_deaths);

#=
here we define our model — using simple SID so that
I don't break things too much. 
=#

N = 1000000 #I made this number up, because cumsum(deaths) 


function SID(du, u, p, t)
    s,i,d = u 
    β, γ = p

    du[1] = -(β/N)*s*i
    du[2] = (β/N)*s*i - γ*i
    du[3] = γ*i
end;

β = 0.08
γ = 0.01
p = [β,γ]
u0 = [N,1,0.0]

#setup and solve problem
prob = ODEProblem(SID, u0, (0.0, 88 + 1.0) , p)


#
retEvery = 1.0
sol = solve(prob, Tsit5(), saveat=retEvery)




@model function fitSID(data, prob)

    σ ~ InverseGamma(3,1)
    β ~ Truncated(Normal(0.9, 4), 0, 10)
    γ ~ Truncated(Normal(0.4, 4), 0, 10)

    p = [β , γ]

    probNew = remake(prob, p=p)
    predicted = solve(probNew, Tsit5(), saveat = retEvery)

    for i in 1: length(predicted) - 1
        data[i] ~ Normal(predicted[3,:][i], σ)
    end
end

model = fitSID(dat, prob)


chain = sample(model, NUTS(.45), 5000)
chain_array = Array(chain)


pl = scatter(dat)


for k in 1:5000
    resol = solve(remake(prob,p=chain_array[rand(1:4000), 2:3]),Tsit5(),saveat=1)

    plot!(resol[3,:], alpha=0.1, color = "#BBBBBB", legend = false)
end

asol = solve(remake(prob,p=chain_array[4000, 2:3]),Tsit5(),saveat=1)

pl