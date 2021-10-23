using MCMCChains, Plots, StatsPlots, Turing, Distributions, DifferentialEquations

using Random
Random.seed!(969)

##Here is where you specify the conditions of the true data generating process
β = 0.3
γ = 0.1

#Define ODE
function SID(du, u, p, t)
    s,i,d = u
    β, γ = p

    du[1] = -β*s*i
    du[2] = β*s*i - γ*i
    du[3] = γ*i
end;


# initial β, γ
p = [β,γ]
# initial conditions 
u0 = [0.99,0.01,0.0]


#setup and solve problem
prob = ODEProblem(SID, u0, (0,80.0), p)


#Make fake data from true process
evalEvery = 0.1
sol = solve(prob,Tsit5(),saveat=evalEvery)
odedata = broadcast(abs,Array(sol) + 0.08 * randn(size(Array(sol))))



@model function fitSID(data, prob)

    σ ~ InverseGamma(3,0.5)
    β ~ Normal(0.2, 0.6)
    γ ~ Normal(0.2, 0.6)

    p = [β , γ]

    probNew = remake(prob, p=p)
    predicted = solve(probNew, Tsit5(), saveat = evalEvery)

    for i = 1:length(predicted)
        data[:,i] ~ MvNormal(predicted[i], σ)
    end
end


model = fitSID(odedata, prob)
chain = sample(model, NUTS(.45), 500)


pl = scatter(sol.t, odedata'[:,3]);
chain_array = Array(chain)
for k in 1:500
    resol = solve(remake(prob,p=chain_array[rand(1:200), 1:3]),Tsit5(),saveat=0.1)

    plot!(resol, alpha=0.1, color = "#BBBBBB", legend = false)
end

#display(pl)
plot!(sol, legend = false)

