classdef Filter
   
methods(Static)
           
    function [FilteredData] = ByRangeGate(GalionExtension)
        
        FilteredData	= GalionExtension.Data;
        Indices         = FilteredData(:, 1) < Galion.FirstUsableRangeGate;
        FilteredData(Indices, 2) = NaN;
        
    end
    
    function [FilteredData] = ByIntensity(GalionExtension)
        
        FilteredData	= GalionExtension.Data;
        Indices         = FilteredData(:, 3) <= Galion.IntensityThreshold;
        FilteredData(Indices, 2) = NaN;
        
    end
    
    function [FilteredData] = ByGradient(GalionExtension)

        Data            = GalionExtension.Data;
        
        WindSpeedData   = Data(:, 2);
        FilteredData    = Data;
        
        GradientData    = ((WindSpeedData(2 : end - 1) - WindSpeedData(1 : end - 2)) .* ...
                           (WindSpeedData(3 : end)     - WindSpeedData(2 : end - 1))) .^ 2;
        
        Indices         = [0; GradientData; 0] >= Galion.GradientThreshold & ... 
                          [diff(Data(:, 1)); 0] >= 0;
                       
        FilteredData(Indices, 2) = NaN;
       
    end
    
    function [FilteredData] = ByNaNQuota(GalionExtension)
        
        TimeLineData                = GalionExtension.TimeLineData;
        NaNQuota                    = sum(isnan(TimeLineData(:, :, 2))) ./ GalionExtension.RangeGateCount;
        Indices                     = NaNQuota > Galion.NaNQuotaThreshold;
        TimeLineData(:, Indices, 2) = NaN;
        FilteredData                = reshape(TimeLineData, [], 8, 1);
        
    end
    
    function [FilteredData] = ByWindDirection(GalionExtension, ScadaData, MinAngle, MaxAngle)
        
        WindDirection       = WindHelper.WindDirection(ScadaData.Gondelposition_in_Grad_____, ScadaData.relative_Windrichtung_1_____);
        
        FilteredData        = GalionExtension.Data;
        DateTimeData        = FilteredData(:, 4);

        BinCenters          = ScadaData.DateTimes';
        
        CorrelatingBinIndices = Statistics.SortDataIntoBins(DateTimeData, BinCenters, false, true);

        Indices             = ~(MinAngle <= WindDirection & WindDirection <= MaxAngle);

        BinIndices          = 1 : length(BinCenters);
        InvalidBinIndices   = BinIndices(Indices);

        FilteredData(ismember(CorrelatingBinIndices, InvalidBinIndices), 2) = NaN;                          
              
    end
    
    function [FilteredData] = ByIsPowerMeasurementActive(GalionExtension, ScadaData)
       
        FieldName           = 'Leistungsmessung_10Min_Intervall_aktiv___';
        FilteredData        = GalionExtension.Data;
        DateTimeData        = FilteredData(:, 4);
               
        BinCenters          = ScadaData.DateTimes';
        
        CorrelatingBinIndices = Statistics.SortDataIntoBins(DateTimeData, BinCenters, false, true);
        
        IsPowerMeasurementActive = (ScadaData.(FieldName) > 0);
        
        BinIndices          = 1 : length(BinCenters);
        InvalidBinIndices   = BinIndices(~IsPowerMeasurementActive);
        
        FilteredData(ismember(CorrelatingBinIndices, InvalidBinIndices), 2) = NaN;                          
               
    end
    
    function [FilteredData] = ByMean(TimeLineData, KernelSize)

        TimeLineData    = Calculation.InterpolateNaN(TimeLineData);
        
        Kernel          = ones(KernelSize, KernelSize) / (KernelSize ^ 2);   
        FilteredData    = conv2(TimeLineData, Kernel, 'same'); 
        
    end
    
end
    
end