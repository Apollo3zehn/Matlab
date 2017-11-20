function [PredictedWindSpeed, ReferenceWindSpeed] = PredictWindSpeed(TimeLineData, FirstReferenceRangeGate, LastReferenceRangeGate, Distance)

    WindSpeed               = TimeLineData(:, :, 2)';
    
    ReferenceWindSpeed      = mean(WindSpeed(:, FirstReferenceRangeGate : LastReferenceRangeGate), 2);   
    ReferenceDateTime       = TimeLineData(1, :, 4)';
    
    Duration                = Distance ./ ReferenceWindSpeed;
    
    PredictedDateTime       = ReferenceDateTime + datenum(0, 0, 0, 0, 0, Duration);   
    BinIndices              = Statistics.SortDataIntoBins(PredictedDateTime, ReferenceDateTime, false, false);  
    PredictedWindSpeed      = Statistics.ProcessBinSortedData(ReferenceWindSpeed, BinIndices, length(ReferenceDateTime), @(x) mean(x, 'omitnan'));
    
end

