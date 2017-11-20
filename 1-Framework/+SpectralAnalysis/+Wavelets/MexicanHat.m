function psi = MexicanHat(Time)
        
    Sigma   = 1;
    psi     = 2/(sqrt(3*Sigma) * pi^(1/4)) .* (1 - Time.^2/Sigma^2) .* exp(-Time.^2 / (2 * Sigma^2));

end