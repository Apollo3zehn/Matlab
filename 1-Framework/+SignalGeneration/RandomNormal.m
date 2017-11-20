function Result = RandomNormal(Mu, Sigma, Size)

    if any(Sigma <= 0)
        error('The parameter Sigma must be greater than zero.')
    end

    Result = randn(Size) .* Sigma + Mu;

end

