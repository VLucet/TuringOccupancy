
function SingleOcc(OccData::NamedArray)
    SingleOcc_model(eachrow(OccData))
end

@model function SingleOcc_model(D)

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

