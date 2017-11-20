function WindStatistics = WindStatistics(Dataset, ParameterSet)

    % Calculates several wind statistics.
    %
    % - Syntax -
    %
    % PowerCurveInfo = PowerCurve(Dataset, ParameterSet)
    %
    % - Inputs -
    %
    % Dataset       - Table with the following columns:
    %                   - Power in W
    %                   - WindSpeed in m/s
    %                   - WindDirection in deg
    %                   - Temperature in K
    %                   - Humidity (0..1)
    %                   - AirPressure (Pa)
    %                   - WindSpeed_WTG_1 in m/s
    %                   - WindSpeed_WTG_2 in m/s
    %               - Note: dataset will only be filtered to match the valid wind sector,
    %                 other filters (period, WTG ready for power measurement) must 
    %                 applied be before calling this function
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
    %                   - PowerCurve: table with power curve data
    %                   - IsPowerCurveComplete: boolean
    %                   - FilteredDataset: table with output data
    %                   - AEP: table with AEP data
    %                   - SelfConsistency: table with self consistency test result
    %                   - NTF1: nacelle transfer function of first WTG anemometer
    %                   - NTF2: nacelle transfer function of first WTG anemometer
    %                   - InputDataset: table with input data
    %
    % - Test -
    %
    % ParameterSet.MeasurementSectorSet   = [MinWindDir MaxWindDir];
    % ParameterSet.CutInWindSpeed         = 3.5;
    % ParameterSet.RatedPower             = 5050 * 1000;
    % ParameterSet.UseHumidity            = UseHumidity;
    % ParameterSet.RotorDiameter          = 135;
    % ParameterSet.UseMinMaxForWindDir    = false;
    %
    % InputDataset        = table(Dataset.DateTime, Power, Dataset.v1_avg, Dataset.dir1_avg, Dataset.dir1_min, Dataset.dir1_max, Temperature, Humidity, Pressure, ...
    %                            'VariableNames', {'DateTime', 'Power', 'WindSpeed', 'WindDirection', 'WindDirection_min', 'WindDirection_max', 'Temperature', 'Humidity', 'AirPressure'});
    %
    % PowerCurveInfo = WindHelper.PowerCurve(InputDataset, ParameterSet);
  
    %% 

    [PowerCurve, IsPowerCurveComplete, FilteredDataset] = WindHelper.PowerCurve(Dataset, ParameterSet);
    
    try
        AEP                                                 = WindHelper.AEP(PowerCurve);
        SelfConsistency                                     = WindHelper.SelfConsistency(Dataset, PowerCurve);
        NacelleTransferFunction1                            = WindHelper.NacelleTransferFunction(Dataset, 'WindSpeed_WTG_1', ParameterSet, 1);
        NacelleTransferFunction2                            = WindHelper.NacelleTransferFunction(Dataset, 'WindSpeed_WTG_2', ParameterSet, 1);
    catch
    end
    
    %% Return
    
    WindStatistics.PowerCurve               = PowerCurve;
    WindStatistics.IsPowerCurveComplete     = IsPowerCurveComplete;
    WindStatistics.FilteredDataset          = FilteredDataset;
    
    if exist('AEP', 'var')
        WindStatistics.AEP                      = AEP;
    else
        WindStatistics.AEP                      = NaN;
    end
    
    if exist('SelfConsistency', 'var')
        WindStatistics.SelfConsistency      	= SelfConsistency;
    else
        WindStatistics.SelfConsistency      	= NaN;
    end
    
    if exist('NacelleTransferFunction1', 'var')
        WindStatistics.NTF1                     = NacelleTransferFunction1;
    else
        WindStatistics.NTF1                     = NaN;
    end
    
    if exist('NacelleTransferFunction2', 'var')
        WindStatistics.NTF2                     = NacelleTransferFunction2;
    else
        WindStatistics.NTF2                     = NaN;
    end
        
    WindStatistics.InputDataset             = Dataset;
    
end