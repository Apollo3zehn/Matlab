function p = NormalPdf(X, Mu, Sigma)

    [X, Mu, Sigma] = InputSizeCheck(X, Mu, Sigma);

    if any(Sigma <= 0)
        error('The parameter Sigma must be greater than zero.')
    end
   
    p = exp(-0.5 * ((X - Mu) ./ Sigma) .^2) ./ (sqrt(2*pi) .* Sigma);

end