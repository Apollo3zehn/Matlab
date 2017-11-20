function SeriesHandle = DrawVerticalLine(AxisHandle, xValue, LineStyle, LineWidth, Color)

    yLimits = get(AxisHandle, 'ylim');
    hold(AxisHandle, 'on')
    SeriesHandle = plot(AxisHandle, [xValue xValue], yLimits, LineStyle, 'LineWidth', LineWidth, 'Color', Color);

end