function AdjustScanModePlot(AxisHandle, SeriesHandle, Title, WindSpeedLimit, IsHorizontalScan)
       
    set(SeriesHandle, 'linestyle', 'none')

    if IsHorizontalScan
        xlabel(AxisHandle, 'Lateral distance from AV07 in m')
        ylabel(AxisHandle, 'Longitudinal distance from AV07 in m')
    else
        xlabel(AxisHandle, 'Longitudinal distance from AV07 in m')
        ylabel(AxisHandle, 'Vertical distance from AV07 in m')
    end

    caxis(AxisHandle, WindSpeedLimit)
    colorbar('peer', AxisHandle, 'location', 'east')

    title(AxisHandle, Title)

end