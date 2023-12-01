module TuringOccupancy

using Turing
using NamedArrays
using StatsFuns

export SingleOcc
export simulate_occ

include("SingleOcc.jl")
include("SimulateOcc.jl")

end
