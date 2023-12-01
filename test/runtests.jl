using TuringOccupancy
using Test
using Random
using Turing

@testset "Single Occupancy" begin

    Random.seed!(4523)
    occ = simulate_occ(100, 50)
    @test sum(occ) == 1333

    sampler =  Turing.NUTS(1000, 0.65)
    num_chains = 4
    nsamples = 5000
    chains = mapreduce(c -> sample(SingleOcc(occ), sampler, nsamples), chainscat, 1:num_chains)
    @test describe(chains)[1][1,:][1] ≈ 0.5394438754180287
    @test describe(chains)[1][2,:][1] ≈ 0.4938093868696573

end