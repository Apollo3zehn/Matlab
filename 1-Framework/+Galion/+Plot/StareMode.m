function [SH] = StareMode(AxisHandle, GalionExtension, DateTimeBegin, DateTimeEnd, Title)
         
%     %prevent the shrinking of the plot due to colorbar 
%     AxisHandlePosition = get(AxisHandle,'position');
%     set(AxisHandle, 'position', AxisHandlePosition); 

    TimeLineData = GalionExtension.TimeLineData;
    
    SH = surf(AxisHandle, TimeLineData(1, :, 4), GalionExtension.DistanceValues, TimeLineData(:, :, 2));
    set(SH, 'linestyle', 'none')     
    
    Galion.Helper.AdjustTimeLinePlot(AxisHandle, ...
                                     DateTimeBegin, ...
                                     DateTimeEnd, ...
                                     [0 GalionExtension.MaximumRange], ...
                                     'Distance from AV07 (m)', ...
                                     Title, ...
                                     [0 10], ...    
                                     true)
    
    if nargout == 0
        clear('SH');
    end

end