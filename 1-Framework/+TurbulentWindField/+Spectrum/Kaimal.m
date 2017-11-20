function PowerSpectralDensity = Kaimal(MeanWindSpeed, FrequencySet, xLengthScale_u, xLengthScale_v, xLengthScale_w)

    % Non-dimensional frequency parameter
    n_u                         = FrequencySet * xLengthScale_u / MeanWindSpeed;
    n_v                         = FrequencySet * xLengthScale_v / MeanWindSpeed;
    n_w                         = FrequencySet * xLengthScale_w / MeanWindSpeed;

    % Power spectral density
    PowerSpectralDensity(1, :)  = (4 * n_u) ./ (1 + 6 * n_u).^(5/3) ./ FrequencySet;
    PowerSpectralDensity(2, :)  = (4 * n_v) ./ (1 + 6 * n_v).^(5/3) ./ FrequencySet;
    PowerSpectralDensity(3, :)  = (4 * n_w) ./ (1 + 6 * n_w).^(5/3) ./ FrequencySet;
    
end