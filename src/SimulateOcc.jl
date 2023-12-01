
function simulate_occ(
    n_sites::Int=5, n_reps::Int=5, 
    ψ::Vector{<:AbstractFloat}=[0.5],
    p::Vector{<:AbstractFloat}=[0.5])
    pres_dets = simulate_pres_dets(n_sites, n_reps, ψ, p)
    pres_dets_mat = permutedims(hcat(pres_dets...))
    
    names = ("Site_" .* string.(1:(size(pres_dets_mat)[1])),
             "Rep_" .* string.(1:(size(pres_dets_mat)[2])))
    dim_names = ("Sites", "Reps")

    return  0 .+ NamedArray(pres_dets_mat, names, dim_names)
end

function simulate_pres_dets(n_sites::Int, n_reps::Int, 
    ψ::Vector{<:AbstractFloat}=[0.5],
    p::Vector{<:AbstractFloat}=[0.5])
    pres_vec = simulate_pres(n_sites, ψ)
    dets_vec = rand.(Bernoulli.(pres_vec .* p), n_reps)
    return dets_vec
end

function simulate_pres(n_sites::Int, ψ::Vector{<:AbstractFloat}) 
    err_message = "ψ must be of length(n_sites) or of length 1"
    n_dist = length(ψ) == n_sites ? Bernoulli.(ψ) : length(ψ) == 1 ? Bernoulli(ψ[1]) : throw(err_message)
    pres = length(n_dist) > 1 ? [rand(n_dist[i], 1)[1] for i in 1:n_sites] : rand(n_dist, n_sites)
    return pres
end
