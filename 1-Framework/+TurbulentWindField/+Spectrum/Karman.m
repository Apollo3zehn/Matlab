function PowerSpectralDensity = Karman(MeanWindSpeed, FrequencySet, xLengthScale_u, xLengthScale_v, xLengthScale_w)

    % Non-dimensional frequency parameter
    n_u                         = FrequencySet * xLengthScale_u / MeanWindSpeed;
    n_v                         = FrequencySet * xLengthScale_v / MeanWindSpeed;
    n_w                         = FrequencySet * xLengthScale_w / MeanWindSpeed;

    % Power spectral density
    PowerSpectralDensity(1, :)  = (4 * n_u)                         ./ (1 +  70.8 * n_u.^2).^( 5/6) ./ FrequencySet;
    PowerSpectralDensity(2, :)  = (4 * n_v .* (1 + 755.2 * n_v.^2)) ./ (1 + 282.3 * n_v.^2).^(11/6) ./ FrequencySet;
    PowerSpectralDensity(3, :)  = (4 * n_w .* (1 + 755.2 * n_w.^2)) ./ (1 + 282.3 * n_w.^2).^(11/6) ./ FrequencySet;

end