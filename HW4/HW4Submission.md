#Fitting Plague Models


Code here is present in two places — .jl files, which are nice to look at, and an rmd, which is not nice to look at. 

--

Model: this asg. asks

>  Fit a model to real data, or find a table of model results, and one or two plots illustrating a statistical inference. Let us know if you need help finding a data set, or a plausible scientific question to attack with a model.

The choice of model in this case was a mix of SIR / SIRD / SID models for various real and fake datasets. The point of this, for me, was to get better at fitting models using probabilistic programming languages. All models are fit with NUTS in Turing.jl. I'll just talk about the Eyam model due to time limitations.

##Eyam model

Completing the asg, model one fits an SIRD model to the Eyam dataset from the louse plague project. 

```{julia}

function SID(du, u, p, t)
    s,i,d,r = u 
    β, γ, μ  = p  

    du[1] = -(β/N)*s*i
    du[2] = (β/N)*s*i - γ*i - μ*i
    du[3] = γ*i
    du[4] = μ*i
end;

```


where '&' represents a unicode character in Julia, and my gamma and mu variables are switched from convention due to prior mistakes.

Our initial data is noisy, and only contains the 'deaths' time series.

The statistical assumptions are as follows:


```{julia}
    σ ~ InverseGamma(3,1)
    β ~ Truncated(Normal(0.9, 4), 0, 10)
    γ ~ Truncated(Normal(0.4, 4), 0, 10)
    μ ~ Truncated(Normal(0.4, 4), 0, 10)
```

There is no good reason for these picks, but I don't think they're that awful.

## plots

Model output, drawn as 50 pulls from the posterior distribution for each compartment. Deaths are in red, and are differenced to match the time series. Current infections are in teal. 




<img src="https://raw.githubusercontent.com/JasonPekos/Stat744/07d3c1646480536f6e1636417009532f63d00cf2/HW4/plot_92.svg
">



Streaming in points and watching as the model calibrates:




This graph is messed up in a bunch of ways. It also takes like two hours to plot, because I sample 50x NUTS runs at every step and then plot 50x graphs, for ~125 steps. 

I will fix this later --- if you're marking it now, don't judge it too much please :(



<img src="https://raw.githubusercontent.com/JasonPekos/Stat744/main/HW4/plot_113.gif">





