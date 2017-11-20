function PowerSpectralDensity = ImprovedVonKarman(MeanWindSpeed, FrequencySet, HubHeight, BoundaryLayerHeight, xLengthScale_u, xLengthScale_v, xLengthScale_w) 
        
    % xLengthScale_u (ESDU 85020, p.22 & p.33)
    A     	= 0.115 * (1 + 0.315 * (1 - HubHeight / BoundaryLayerHeight)^6)^(2/3);

    % Non-dimensional frequency parameter
    n_u  	= FrequencySet * xLengthScale_u / MeanWindSpeed;
    n_v  	= FrequencySet * xLengthScale_v / MeanWindSpeed;
    n_w    	= FrequencySet * xLengthScale_w / MeanWindSpeed;

    % Additional parameters for the improved von Karman spectrum (ESDU 85020, p.31) 
    alpha  	= 0.535 + 2.76 * (0.138 - A)^0.68;
    beta_1	= 2.357 * alpha - 0.761;
    beta_2	= 1 - beta_1;
    F1    	= 1.0 + 0.455 * exp(-0.76 * n_u / alpha^-0.8);
    F2    	= 1.0 + 2.88 * exp(-0.218 * n_v / alpha^-0.9);
    F3    	= 1.0 + 2.88 * exp(-0.218 * n_w / alpha^-0.9);
       
    % Power spectral density
    PowerSpectralDensity(1, :) = (beta_1 * (2.987 * n_u / alpha) ./ (1.0 + (2*pi * n_u / alpha).^2).^(5/6) + ...
                                  beta_2 * (1.294 * n_u / alpha) ./ (1.0 + (pi * n_u / alpha).^2).^(5/6) .* F1) ./ ...
                                  FrequencySet;
                               
    PowerSpectralDensity(2, :) = (beta_1 * (2.987 * (1 + (8/3) * (4*pi * n_v / alpha).^2) .* (n_v / alpha)) ./ (1.0 + (4*pi * n_v / alpha).^2).^(11/6) + ...
                                  beta_2 * (1.294 * n_v / alpha) ./ (1.0 + (2*pi * n_v / alpha).^2).^(5/6) .* F2) ./ ...
                                  FrequencySet;
                               
    PowerSpectralDensity(3, :) = (beta_1 * (2.987 * (1 + (8/3) * (4*pi * n_w / alpha).^2) .* (n_w / alpha)) ./ (1.0 + (4*pi * n_w / alpha).^2).^(11/6) + ...
                                  beta_2 * (1.294 * n_w / alpha) ./ (1.0 + (2*pi * n_w / alpha).^2).^(5/6) .* F3) ./ ...
                                  FrequencySet;

end