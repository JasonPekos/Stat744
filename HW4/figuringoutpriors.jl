using MCMCChains, StatsPlots, Turing, Distributions, DifferentialEquations, Random

Random.seed!(969)

eyam_1665 = [3,4,1,3,1,3,1,1,0,0,1,0,1,1,2,0,1,2,0,1,2,
             1,1,4,2,2,1,2,0,1,0,1,1,2,3,6,1,0,0,0,3,0,
             1,3,4,0,1,3,5,4,2,6,6,3,0,3,4,1,1,2,1,2,8,
             3,5,1,3,4,2,4,2,1,1,1,3,0,2,1,0,3,0,2,1,1,
             2,0,0,2,1,3,1,0,0,2,0,0,0,0,1,0,1,1,1,3,0,
             0,0,0,0,1,0,1,1,0,1,1,2,0,2,0,0,1,1,2,1,1,
             0,2,1,0,0,0,0,0,0,0,0,0,1,0,0,0,1]


#=
here we define our model — using simple SID so that
I don't break things too much. 
=#

N = 350

function SID(du, u, p, t)
    s,i,d = u 
    β, γ = p

    du[1] = -(β/N)*s*i
    du[2] = (β/N)*s*i - γ*i
    du[3] = γ*i
end;

β = 8*0.5
γ = 1/7
p = [β,γ]
u0 = [N,1,0.0]

#setup and solve problem
prob = ODEProblem(SID, u0, (0.0, 143.0 + 1.0) , p)


#
retEvery = 1.0
sol = solve(prob, Tsit5(), saveat=retEvery)


scatter(eyam_1665)

plot!(diff(sol[2,:]))
plot!(diff(sol[3,:]))
