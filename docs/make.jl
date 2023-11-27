using TuringOccupancy
using Documenter

DocMeta.setdocmeta!(TuringOccupancy, :DocTestSetup, :(using TuringOccupancy); recursive=true)

makedocs(;
    modules=[TuringOccupancy],
    authors="vlucet <valentin.lucet@gmail.com> and contributors",
    repo="https://github.com/vlucet/TuringOccupancy.jl/blob/{commit}{path}#{line}",
    sitename="TuringOccupancy.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://vlucet.github.io/TuringOccupancy.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/vlucet/TuringOccupancy.jl",
    devbranch="main",
)
