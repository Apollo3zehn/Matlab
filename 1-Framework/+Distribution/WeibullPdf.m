function p = WeibullPdf(X, k, Lambda)

    % Assuming a Weibull distribution, calculate the probability for a given X.
    %
    % - Syntax -
    %
    % p = WeibullPdf(X, A, Lambda)
    %
    % - Inputs -
    %
    % X - The function will be evaluated for each element.
    % k - Shape parameter of the Weibull distribution
    % A - Scale parameter of the Weibull distribution
    %
    % - Outputs -
    %
    % p - Vector that contains the probability for each specified X
    %
    % - Test -
    %
    % p = Distribution.WeibullPdf([1:2], 0.1, 1/2);
    
    [X, k, Lambda]  = InputSizeCheck(X, k, Lambda);

    p               = Lambda .* k .* (Lambda.*X).^(k-1) .* exp(-(Lambda.*X).^k);
    
end

