using Turing
using MCMCChains
using StatsPlots
using Random
using DataFrames
using StatsFuns
using DataFrames

# Simulate the data
Random.seed!(12)
N_visits = 30
N_sites = 20

# true parameters
ψ = 0.8 # probability of presence (occupancy)
p = 0.5 # probability of detection

# Occupancy data
# pres_vec = [rand(Bernoulli(ψ), N_visits) for i in 1:N_sites]
pres_vec = rand(Bernoulli(ψ), N_sites)

# Detection data
dets_vec = [[rand(Bernoulli(pres_vec[n]*p)) for v in 1:N_visits] for n in 1:N_sites]

sum.(dets_vec)

df = DataFrame(dets_vec, :auto)
CSV.write("data.csv", df)

# Sites
# sites_vec = [repeat([val], N_visits) for val in 1:N_sites]

# DataFrame
# dat = DataFrame([ reduce(vcat, pres_vec)  reduce(vcat, dets_vec)  reduce(vcat, sites_vec)], 
# 	["pres", "dets", "sites"])

# pres_mat = reduce(hcat, pres_vec)
# dets_mat = reduce(hcat, dets_vec)
# sites = 1:N_sites

# Model
@model occupancy(D) = begin

    # Q sums 
    Q = sum.(D)
    
    # Priors
    ψ ~ Beta(1,1)
    p ~ Beta(1,1)

    for (i, q) in enumerate(Q)
        if q > 0
            Turing.@addlogprob! logpdf(Bernoulli(ψ), 1)
            for d in D[i]
                Turing.@addlogprob! logpdf(Bernoulli(p), d)
            end
        elseif q == 0
            present_but_missed = logpdf(Bernoulli(ψ), 1)
            for _ in D[i]
                present_but_missed += logpdf(Bernoulli(1-p), 1)
            end
            absent = logpdf(Bernoulli(1-ψ), 1)
            Turing.@addlogprob! logsumexp([present_but_missed, absent])
        end
    end

end

# # Model
# @model occupancy(D) = begin

#     # Q sums 
#     Q = sum.(D)
    
#     # Priors
#     ψ ~ Beta(1,1)
#     p ~ Beta(1,1)

#     for (i, q) in enumerate(Q)
#         if q > 0
#             for d in D[i]
#                 Turing.@addlogprob! logpdf(Bernoulli(ψ), 1)
#                 Turing.@addlogprob! logpdf(Bernoulli(p), d)
#             end
#         elseif q == 0
#             visit_sum = 0
#             for _ in D[i]
#                 visit_sum += log(1-p)
#             end
#             Turing.@addlogprob! logsumexp([ + visit_sum, log(1-ψ)])
#         end
#     end

# end

# sampler =  HMC(0.01, 10)
sampler =  Turing.NUTS(1000, 0.65) # HMC(0.01, 10)
# nsamples = 1000
# chain = sample(occupancy(dets_vec), sampler, nsamples);
# plot(chain[["p", "ψ"]]; colordim=:parameter, legend=true)

sampler =  Turing.NUTS(1000, 0.65)
num_chains = 4
nsamples = 5000
chains = mapreduce(c -> sample(occupancy(dets_vec), sampler, nsamples), chainscat, 1:num_chains)

plot(chains)
