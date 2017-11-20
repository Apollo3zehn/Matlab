function p = RayleighCdf(X, Sigma)

    % Assuming a Rayleigh distribution, calculate the probability for a given X.
    %
    % - Syntax -
    %
    % p = RayleighCdf(X, Sigma)
    %
    % - Inputs -
    %
    % X     - The function will be evaluated for each element.
    % Sigma - Scale parameter of the Rayleigh distribution
    %
    % - Outputs -
    %
    % p - Vector that contains the probability for each specified X
    %
    % - Test -
    %
    % p = Distribution.RayleighCdf([1:2], 0.1);

	p = 1 - exp(-X.^2 ./ (2 * Sigma.^2));
    
end

