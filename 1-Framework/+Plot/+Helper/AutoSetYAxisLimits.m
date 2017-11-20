function AutoSetYAxisLimits(AxisHandle, SeriesHandle, RelativeOffset, Precision)

    YData = get(SeriesHandle, 'YData');

    AbsoluteOffset  = (max(YData) - min(YData)) * RelativeOffset;

    Minimum         = Math.Round(min(YData) - AbsoluteOffset, Precision, Math.RoundDown);
    Maximum         = Math.Round(max(YData) + AbsoluteOffset, Precision, Math.RoundUp);

    if Minimum == Maximum
        Minimum = Minimum - 10^Precision;
        Maximum = Maximum + 10^Precision;
    end

    yLimits         = [Minimum Maximum];
    ylim(AxisHandle, yLimits)

end