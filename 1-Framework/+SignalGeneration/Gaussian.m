function Gaussian = Gaussian(mu, Sigma, Data)
    Gaussian = 1 / (Sigma * sqrt(2 * pi)) * exp(-0.5 * (Data - mu).^2 / Sigma^2);
end

