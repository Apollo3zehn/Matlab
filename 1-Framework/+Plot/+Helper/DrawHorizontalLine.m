function SeriesHandle = DrawHorizontalLine(AxisHandle, yValue, LineStyle, LineWidth, Color)

    xLimits = get(AxisHandle, 'xlim');
    hold(AxisHandle, 'on')
    SeriesHandle = plot(AxisHandle, xLimits, [yValue yValue], LineStyle, ...
                                                               'LineWidth', LineWidth, ...
                                                               'Color', Color);

end