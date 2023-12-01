
struct OccDataFrame
    OccData::DataFrame
    Species::Vector
    Seasons::Vector
    Sites::Vector
    Replicates::Vector
end

function OccDataFrame(OccData::DataFrame)
    # Validate DataFrame
    # Extract unique sets
    # Construct Object
end

function OccDataFrame(Species::Union{Vector,UnitRange}, Seasons::Union{Vector,UnitRange}, 
                      Sites::Union{Vector,UnitRange}, Replicates::Union{Vector,UnitRange})
    df = DataFrame(collect(Base.product(Species, Seasons, Sites, Replicates)))
    rename!(df,[:Species, :Seasons, :Sites, :Replicates])
    OccDataFrame(df, Species, Seasons, Sites, Replicates)
end

# Overloading Base.show for custom printing
Base.show(io::IO, z::OccDataFrame) = print(io, z.OccData)

# Validator for OccDataFrame
function validate_OccDataFrame(OccData::DataFrame)
    # Check columns
end