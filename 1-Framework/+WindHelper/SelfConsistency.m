function SelfConsistency = SelfConsistency(Dataset, PowerCurve)

    % Calculates self consistency
    %
    % - Syntax -
    %
    % SelfConsistency = SelfConsistency(PowerCurve)
    %
    % - Inputs -
    %  
    % Dataset   
    %               - table with the following columns:
    %                   - Power in W
    %                   - WindSpeed in m/s
    %                   - WindDirection in deg
    % 
    % PowerCurve    - table with the following columns:
    %                   - Power in W
    %                   - WindSpeed in m/s
    %
    % - Outputs -
    %
    % SelfConsistency - table with the following columns:
    %                   - BinCenter in deg
    %                   - Count
    %                   - WindDirection in deg
    %                   - SelfConsistency in %
    %                   - StandardDeviation
  
    %% Self consistency test     
   
    WindDirectionBins           = (0 : 10 : 360).';

    SelfConsistencyPowerCurve   = PowerCurve(12 : 17, :);
    %SelfConsistencyPowerCurve   = PowerCurve(10 : 19, :);
    SelfConsistency             = interp1(SelfConsistencyPowerCurve.Power, SelfConsistencyPowerCurve.WindSpeed, Dataset.Power, 'PCHIP', NaN) ./ Dataset.WindSpeed; 
    [BinIndices, NumberOfValues]= Statistics.SortDataIntoBins(Dataset.WindDirection, WindDirectionBins, false, false);    
    BinnedWindDirection         = Statistics.ProcessBinSortedData(Dataset.WindDirection, BinIndices, length(WindDirectionBins), @(x) mean(x, 'omitnan'));   
    BinnedSelfConsistency       = Statistics.ProcessBinSortedData(SelfConsistency, BinIndices, length(WindDirectionBins), @(x) mean(x, 'omitnan'));   
    BinnedSelfConsistency_std   = Statistics.ProcessBinSortedData(SelfConsistency, BinIndices, length(WindDirectionBins), @(x) std(x, 'omitnan'));   
    
    SelfConsistency             = table(WindDirectionBins, NumberOfValues, BinnedWindDirection, BinnedSelfConsistency, BinnedSelfConsistency_std, 'VariableNames', {'BinCenter', 'Count', 'WindDirection' 'SelfConsistency' 'StandardDeviation'});
    
end