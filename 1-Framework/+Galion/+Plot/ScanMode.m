function [SH] = ScanMode(AxisHandle, GalionExtension, Title, IsHorizontalScan, FilterKernel)

    RangeGates          = 1 : 65;

    WindSpeedLimit      = [0 10];
    TimeLineData        = GalionExtension.TimeLineData;

    if IsHorizontalScan
        Angles          = (360 - TimeLineData(RangeGates, :, 5)) ./ 180 .* pi + pi / 2;
    else
        Angles          = (360 - TimeLineData(RangeGates, :, 6)) ./ 180 .* pi;
    end
    
    Distances           = TimeLineData(RangeGates, :, 1) .* Galion.RangeGateDistance + Galion.RangeGateDistance / 2;
    WindSpeeds          = TimeLineData(RangeGates, :, 2);
    WindSpeeds          = conv2(WindSpeeds, FilterKernel, 'same');
    
    [x, y, WindSpeeds]  = pol2cart(Angles, -Distances, -WindSpeeds);

    % prevent shrinking of the plot due to the colorbar 
    AxisPosition = get(AxisHandle, 'position');
    set(AxisHandle, 'position', AxisPosition); 
    
    H = pcolor(AxisHandle, x, y, WindSpeeds);

    Galion.Helper.AdjustScanModePlot(AxisHandle, H, Title, WindSpeedLimit, IsHorizontalScan)
    
    if nargout > 0
        SH = H;
    end

end