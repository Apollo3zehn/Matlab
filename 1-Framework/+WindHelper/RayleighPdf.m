function p = RayleighPdf(WindSpeed, AverageWindSpeed)

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
    % p = WindHelper.RayleighPdf(10 * rand(5, 1), 5);

	p = Distribution.RayleighPdf(WindSpeed, AverageWindSpeed * sqrt(2 / pi));
    
end

