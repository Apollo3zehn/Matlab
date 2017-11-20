function X = GammaCdfInverse(Probability, Alpha, Beta)

    [Probability, Alpha, Beta] = InputSizeCheck(Probability, Alpha, Beta);

    if any(~(0 <= Probability & Probability <= 1))
        error('Probability must be within the limit 0..1.')
    end

    if any(Alpha <= 0 | Beta <= 0)
        error('The parameters Alpha and Beta must be greater than zero.')
    end

    X = zeros(size(Probability));

    X(Probability == 0) = 0;
    X(Probability == 1) = Inf;

    %% Computation (Newton's Method)

    MaxIterationCount   = 100;
    IterationCount      = 0;

    Indices             = 0 < Probability & Probability < 1;
    Probability         = Probability(Indices);
    Alpha               = Alpha(Indices);
    Beta                = Beta(Indices);

    % Starting guess: use a method of moments fit to the lognormal distribution 
    mn  	= Alpha .* Beta;
    v       = mn .* Beta;
    temp    = log(v + mn .^ 2); 
    Mu      = 2 * log(mn) - 0.5 * temp;
    Sigma   = -2 * log(mn) + temp;
    
    Xk      = exp(Distribution.NormalCdfInverse(Probability, Mu, Sigma));
    Step    = ones(size(Probability)); 

    % Iteration
    while( ...
           any(abs(Step) > sqrt(eps) * abs(Xk)) && ... %  1) The last update is very small (compared to x)
          max(abs(Step)) > sqrt(eps) && ...            %  2) The last update is very small (compared to sqrt(eps))
          IterationCount < MaxIterationCount ...       %  3) There are more than 100 iterations.
         ) 

        IterationCount  = IterationCount + 1;
        
        Step            = (Distribution.GammaCdf(Xk, Alpha, Beta) - Probability) ./ Distribution.GammaPdf(Xk, Alpha, Beta);
        SubIndices      = Xk - Step < 0;   
        Step(SubIndices)= Xk(SubIndices) - Xk(SubIndices) / 10;
        
        Xk              = Xk - Step;

    end

    X(Indices) = Xk;

    if IterationCount == MaxIterationCount
        error('The inverse cumulative gamma function did not converge.')
    end

end