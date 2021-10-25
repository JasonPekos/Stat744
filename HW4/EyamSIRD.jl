using MCMCChains, StatsPlots, Turing, Distributions, DifferentialEquations, Random, CSV, DataFrames

#=

this fits a  model to the deaths time series from Eyam. Taken from the Louse
plague project.

This is the same code as from the RMD, but much nicer to look at.

=#

Random.seed!(969)


dat = cumsum([3,4,1,3,1,3,1,1,0,0,1,0,1,1,2,0,1,2,0,1,2,
              1,1,4,2,2,1,2,0,1,0,1,1,2,3,6,1,0,0,0,3,0,
              1,3,4,0,1,3,5,4,2,6,6,3,0,3,4,1,1,2,1,2,8,
              3,5,1,3,4,2,4,2,1,1,1,3,0,2,1,0,3,0,2,1,1,
              2,0,0,2,1,3,1,0,0,2,0,0,0,0,1,0,1,1,1,3,0,
              0,0,0,0,1,0,1,1,0,1,1,2,0,2,0,0,1,1,2,1,1,
              0,2,1,0,0,0,0,0,0,0,0,0,1,0,0,0,1]);

#=
here we define our model — using simple SID so that
I don't break things too much.
=#

N = 347
 #I made this number up, because cumsum(deaths) in the time series
 #Yields 500k Dead


function SID(du, u, p, t)
    s,i,r,d = u
    β, γ, μ  = p

    du[1] = -(β/N)*s*i
    du[2] = (β/N)*s*i - γ*i - μ*i
    du[3] = γ*i
    du[4] = μ*i
end;

#ICs so I can remake
β = 0.08
γ = 0.01
μ = 0.01
p = [β,γ, μ]
u0 = [N,1,0.0,0.0]

#setup and solve problem
prob = ODEProblem(SID, u0, (0.0, length(dat) - 1) , p)

#regardless of the interval you solve on, return values only once a day
retEvery = 1.0

#Tsit5 is the recommended solver unless you have a weird really stiff
#problem or something
sol = solve(prob, Tsit5(), saveat=retEvery)


@model function fitSID(data, prob)

    #priors
    σ ~ InverseGamma(3,1)
    β ~ Truncated(Normal(0.9, 4), 0, 10)
    γ ~ Truncated(Normal(0.4, 4), 0, 10)
    μ ~ Truncated(Normal(0.4, 4), 0, 10)

    p = [β, γ, μ]

    probNew = remake(prob, p=p)
    predicted = solve(probNew, Tsit5(), saveat = retEvery)

    for i in 1: length(predicted) - 1
        data[i] ~ Normal(predicted[4,:][i], σ)
    end
end

model = fitSID(dat, prob)

samples = 25000

chain = sample(model, NUTS(.45), samples)
chain_array = Array(chain)


pl = scatter(diff(dat))

for k in 1:1000
    resol = solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)

    plot!(diff(resol[4,:]), alpha=0.1, color = "#d97259", legend = false)
    plot!(resol[2,:], alpha=0.1, color = "#e08b22", legend = false)
end





##### OUTPUTS


a = solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)[2,:]
b = diff(solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)[4,:])

infected = a'
dead = b'

a = solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)[2,:]

infected = vcat(infected,a')


for i in 1:200
    a = solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)[2,:]
    b = diff(solve(remake(prob,p=chain_array[rand(1:24000), 2:4]),Tsit5(),saveat=1)[4,:])
    infected = vcat(infected,a')
    dead = vcat(dead,b')
end

DataFrame(a)

using(Tables)

CSV.write("ModelDrawsDead.csv", Tables.table(dead) , writeheader=false)
CSV.write("ModelDrawsInfected.csv", Tables.table(infected), writeheader=false)


CSV.write("ModelDraws.csv", q)
#write csv to directory for use in .rmd
CSV.write("ModelOut.csv", df)