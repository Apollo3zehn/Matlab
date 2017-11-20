function [PowerCurve, IsPowerCurveComplete, FilteredDataset] = PowerCurve(Dataset, ParameterSet)

    % Calculates the power curve
    %
    % - Syntax -
    %
    % PowerCurveInfo = PowerCurve(Dataset, ParameterSet)
    %
    % - Inputs -
    %
    % Dataset       - Table with following columns:
    %                   - Power in W
    %                   - WindSpeed in m/s
    %                   - WindDirection in deg
    %                   - Temperature in K
    %                   - Humidity (0..1)
    %                   - AirPressure (Pa)
    %
    % ParameterSet  - Structure with the following fields:
    %                   - MeasurementSectorSet: n x 2 matrix, with the following structure: 
    %                                           [MinWindDir1 MaxWindDir1]
    %                                           [MinWindDir2 MaxWindDir2]
    %                                           [MinWindDirn MaxWindDirn]
    %                   - CutInWindSpeed: wind speed where WTG starts
    %                   - RatedPower: nominal power output of WTG
    %                   - UseHumidity: boolean, which specifies if the humditiy is used to calculate the air density.
    %                   - RotorDiameter: rotor diameter of WTG
    %                   - UseMinMaxForWindDir: if false, use average of wind direction                 
    %
    % - Outputs -
    %
    % PowerCurveInfo - Structure with the following fields:
    %                   - PowerCurve: table with the following fields
    %                       - BinCenter in m/s
    %                       - Count
    %                       - WindSpeed in m/s
    %                       - Power in W
    %                       - IsBinComplete (boolean)
    %                       - IsBinRequired (boolean)
    %                   - IsPowerCurveComplete (boolean)
    %                   - FilteredDataset: table with filtered input data data
  
    %% power curve - preprocessing

    % filter by wind direction
    Indices         = zeros(size(Dataset, 1), 1);
    
    for i = 1 : size(ParameterSet.MeasurementSectorSet, 1)
        if ParameterSet.UseMinMaxForWindDir
            Indices = Indices | (ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection_min & Dataset.WindDirection_min <= ParameterSet.MeasurementSectorSet(i, 2) & ...
                                 ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection_max & Dataset.WindDirection_max <= ParameterSet.MeasurementSectorSet(i, 2));
        else
            Indices = Indices | (ParameterSet.MeasurementSectorSet(i, 1) <= Dataset.WindDirection & Dataset.WindDirection <= ParameterSet.MeasurementSectorSet(i, 2));                   
        end        
    end
    
    FilteredDataset = Dataset(Dataset.WindSpeed >= 17 | Indices, :);
    
	% constants
    R_0             = 287.05;
    R_w             = 461.5;                                                                    
    P_w             = [];
    Rho_0           = 1.225;
    
    % air density
    P_w = 0.0000205 .* exp(0.0631846 .* FilteredDataset.Temperature);

    if ParameterSet.UseHumidity
        New_AirDensity  = 1 ./ FilteredDataset.Temperature .* (FilteredDataset.AirPressure ./ R_0 - (FilteredDataset.Humidity .* P_w * (1 ./ R_0 - 1 ./ R_w)));
    else
        New_AirDensity  = FilteredDataset.AirPressure ./ (287.05 .* FilteredDataset.Temperature);           
    end

    % wind speed correction
    New_WindSpeed       = FilteredDataset.WindSpeed .* (New_AirDensity ./ Rho_0) .^ (1/3);           
    
    %% power curve - calculation
    
    WindSpeedBinCenters        	= 0 : 0.5 : 50;
    [BinIndices, NumberOfValues]= Statistics.SortDataIntoBins(New_WindSpeed, WindSpeedBinCenters, false, false);
    BinnedWindSpeed             = Statistics.ProcessBinSortedData(New_WindSpeed, BinIndices, length(WindSpeedBinCenters), @(x) mean(x));
    BinnedPower                 = Statistics.ProcessBinSortedData(FilteredDataset.Power, BinIndices, length(WindSpeedBinCenters), @(x) mean(x));

    PowerCurve                  = table(WindSpeedBinCenters.', NumberOfValues, BinnedWindSpeed, BinnedPower, 'VariableNames', {'BinCenter', 'Count', 'WindSpeed', 'Power'});
    PowerCurve.C_P              = WindHelper.PowerCoefficient(PowerCurve.Power, PowerCurve.WindSpeed, Rho_0, ParameterSet.RotorDiameter);
    PowerCurve.IsBinComplete    = PowerCurve.Count >= 3;

    %% power curve - postprocessing
    
    try % IsBinRequired
        
        % lower bin
        PowerCurve.IsBinRequired    = zeros(size(PowerCurve, 1), 1);
        [BinIndices, ~]             = Statistics.SortDataIntoBins(ParameterSet.CutInWindSpeed - 1, WindSpeedBinCenters, false, false);
        PowerCurve.IsBinRequired(BinIndices) = 1;

        % upper bin
        IsBinRequired_Power         = 0.85 * ParameterSet.RatedPower;

        for i = 1 : size(PowerCurve, 1) - 1
            if PowerCurve.Power(i) <= IsBinRequired_Power && IsBinRequired_Power <= PowerCurve.Power(i + 1)           
                IsNearToUpperBin    = IsBinRequired_Power - PowerCurve.Power(i) >= IsBinRequired_Power - PowerCurve.Power(i + 1);
                break            
            end
        end

        [BinIndices, ~]             = Statistics.SortDataIntoBins(PowerCurve.WindSpeed(i + IsNearToUpperBin) * 1.5, WindSpeedBinCenters, false, false);
        PowerCurve.IsBinRequired(BinIndices) = -1;

        % all
        PowerCurve.IsBinRequired    = cumsum(PowerCurve.IsBinRequired);
        
        % IsPowerCurveComplete
        IsPowerCurveComplete        = (sum(PowerCurve.IsBinRequired & PowerCurve.IsBinComplete) == sum(PowerCurve.IsBinRequired)) && ...
                                       sum(PowerCurve.Count(PowerCurve.IsBinRequired)) >= 360; % >= 180 h
        
    catch
        warning('Calculation of required bins for complete power curve failed.')
        IsPowerCurveComplete        = false;
    end    
   
    %
    PowerCurve.Properties.VariableUnits = {'m/s', '-', 'm/s', 'kW', '-', '-', '-'};
    
end