function RoughnessLength = TurbulenceIntensityToRoughnessLength(TurbulenceIntensity, CoriolisParameter, MeanWindSpeed, HubHeight)
    % Iterative calculation of RoughnessLength to meet the desired turbulence intensity
    % see: ESDU 85020, 4.1 eq. 4.2 & 4.3 / Bladed Theory Manual, 10.1.2 The improved von Karman model
      
    KarmanConstant                      = 0.4;
    Sigma_u                             = MeanWindSpeed * TurbulenceIntensity / 100;
    Delegate                            = @(x) SystemEquation(x);
    
    [RoughnessLength, MetaData]         = ParameterIdentification.LevenbergMarquardt(Delegate, 1E-10, 0.01);

    if ~MetaData.Success
        error('Determination of RoughnessLength failed. Try increasing MeanWindSpeed or decreasing HubHeight.')
    end

    function F = SystemEquation(RoughnessLength)

        u_star            	= (KarmanConstant * MeanWindSpeed - 34.5 * CoriolisParameter * HubHeight) / log(HubHeight / RoughnessLength);
        eta               	= 1 - 6 * CoriolisParameter * HubHeight / u_star;
        p                 	= eta^16;
        Sigma_u_iterative  	= (7.5 * eta * (0.538 + 0.09 * log(HubHeight / RoughnessLength))^p * u_star) / ...
                              (1.0 + 0.156 * log(u_star / (CoriolisParameter * RoughnessLength)));

        F                   = Sigma_u - Sigma_u_iterative;

    end
        
end          
