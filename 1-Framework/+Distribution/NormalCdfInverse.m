function X = NormalCdfInverse(Probability, Mu, Sigma)

    % Cumulated inverse normal distribution
    %
    % - Syntax -
    %
    % X = NormalCdfInverse(Probability, Mu, Sigma)
    %
    % - Inputs -
    %
    % Mu     	- Expected value.
    % Sigma     - Standard deviation.
    %
    % - Outputs -
    %
    % X         - Bounds for the specified probability.

    [Probability, Mu, Sigma] = InputSizeCheck(Probability, Mu, Sigma);

    X = zeros(size(Probability));

    if any(~(0 <= Probability & Probability <= 1))
        error('Probability must be within the limit 0..1.')
    end

    if any(Sigma <= 0)
        error('The parameter Sigma must be greater than zero.')
    end

    X(Probability == 0) = -Inf;
    X(Probability == 1) = Inf;
    
    %% Computation
    
    Indices     = 0 <= Probability & Probability <= 1;
    X(Indices)  = sqrt(2) * Sigma(Indices) .* erfinv(2 * Probability(Indices) - 1) + Mu(Indices);

end

