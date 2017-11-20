function p = GammaPdf(X, Alpha, Beta)

    [X, Alpha, Beta] = InputSizeCheck(X, Alpha, Beta);

    p = zeros(size(X));

    if any(Alpha <= 0 | Beta <= 0)
        error('The parameters Alpha and Beta must be greater than zero.')
    end

    p(X == 0 & Alpha < 1)   = Inf;
    p(X == 0 & Alpha == 1)  = 1 ./ Beta(X == 0 & Alpha == 1);

    Indices                 = X > 0;
    p(Indices)              = (Alpha(Indices) - 1) .* log(X(Indices)) - (X(Indices) ./ Beta(Indices)) - gammaln(Alpha(Indices)) - Alpha(Indices) .* log(Beta(Indices));
    p(Indices)              = exp(p(Indices));

end