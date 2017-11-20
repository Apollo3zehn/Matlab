function AdjustTimeLinePlot(AxisHandle, DateTimeBegin, DateTimeEnd, yLimit, yTitle, Title, ColorAxisLimit, WithColorBar)
       
    %xlim(AxisHandle, [DateTimeBegin, DateTimeEnd])
    ylim(AxisHandle, yLimit)

    Days = Math.Round(DateTimeEnd - DateTimeBegin, 0, Math.RoundDown);

    if Days <= 1

        set(AxisHandle, 'xtick', linspace(DateTimeBegin, DateTimeEnd, 10))
        datetick(AxisHandle, 'x', 'hh:MM:ss', 'keepticks', 'keeplimits')

    elseif Days < 10

        set(AxisHandle, 'xtick', linspace(DateTimeBegin, DateTimeEnd, Days))
        datetick(AxisHandle, 'x', 'mm-dd hh:MM', 'keepticks', 'keeplimits')

    else

        set(AxisHandle, 'xtick', linspace(DateTimeBegin, DateTimeEnd, 10))
        datetick(AxisHandle, 'x', 'yyyy-mm-dd', 'keepticks', 'keeplimits')

    end

    xlabel(AxisHandle, 'Time')
    ylabel(AxisHandle, yTitle)
    caxis(AxisHandle, ColorAxisLimit)

    colormap(AxisHandle, 'jet')

    view(AxisHandle, 2)
    title(AxisHandle, Title)

    if WithColorBar
        colorbar('peer', AxisHandle, 'location', 'east');
    end

end