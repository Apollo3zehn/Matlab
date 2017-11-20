function AEP = AEP(PowerCurve)

    % Calculates annual energy production
    %
    % - Syntax -
    %
    % AEP = AEP(PowerCurve)
    %
    % - Inputs -
    %  
    % PowerCurve    - table with the following columns:
    %                   - Power in W
    %                   - WindSpeed in m/s
    %                   - IsBinComplete (boolean)
    %
    % - Outputs -
    %
    % AEP           - AverageWindSpeed in m/s
    %               - AEP in Wh
  
    %%

    N_h                         = 8760;
    AverageWindSpeed            = (4 : 11).';
    WindSpeed                   = PowerCurve.WindSpeed(PowerCurve.IsBinComplete);
    Power                       = PowerCurve.Power(PowerCurve.IsBinComplete);
    
    AEP                         = table(AverageWindSpeed, NaN(size(AverageWindSpeed, 1), 1), 'VariableNames', {'AverageWindSpeed', 'AEP'});

    for i = 1 : 8
        AEP.AEP(i)              = N_h * sum( ...
                                             ( ...
                                               WindHelper.RayleighCdf(WindSpeed, AverageWindSpeed(i)) - ...
                                               WindHelper.RayleighCdf([WindSpeed(1) - 0.5; WindSpeed(1 : end - 1)], AverageWindSpeed(i)) ...
                                             ) .* ...
                                             ([0; Power(1 : end - 1)] + Power) / 2 ...
                                           );
    end

    AEP.Properties.VariableUnits = {'m/s', 'Wh'};
    
end