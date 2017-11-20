function p = GammaCdf(X, Alpha, Beta)

    [X, Alpha, Beta] = InputSizeCheck(X, Alpha, Beta);

    if any(Alpha <= 0 | Beta <= 0)
        error('The parameters Alpha and Beta must be greater than zero.')
    end

    p           = zeros(size(X));

    Indices     = X > 0;
    p(Indices)  = gammainc(X(Indices) ./ Beta(Indices), Alpha(Indices));

    p(p > 1)    = 1;

end