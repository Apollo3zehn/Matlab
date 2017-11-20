function Plot(FigureHandle, x, y, u, v, RayCoordinatesX, RayCoordinatesY, RayAngleSet, RayWindSpeed)
    
    figure(FigureHandle)    

    AH1 = subplot(2, 1, 1);
    hold(AH1, 'on')
    quiver(y, x, v, u, 0.5, 'filled', 'Color', [1 1 1] * 0.2);
    plot(AH1, RayCoordinatesY, RayCoordinatesX, 'Color', [0 0.447 0.741], 'LineWidth', 1.0)
    plot(AH1, RayCoordinatesY', RayCoordinatesX', '--', 'Color', [1                    0.3125                         0], 'LineWidth', 1.0)
    plot(AH1, RayCoordinatesY', RayCoordinatesX', 'k.', 'MarkerSize', 15)
    text(0, 0, 'o', 'parent', AH1, 'HorizontalAlignment', 'center', 'FontWeight', 'bold')
    text(0, -40, 'Lidar position', 'parent', AH1, 'HorizontalAlignment', 'center', 'FontWeight', 'bold')
    hold(AH1, 'off')
    axis(AH1, 'equal')
    xlim(AH1, [-550 550])
    xlabel(AH1, 'y - lateral distance (m)')
    ylim(AH1, [-100 1000])
    ylabel(AH1, 'x - longitudinal distance (m)')
    
    AH2 = subplot(2, 1, 2);
    hold(AH2, 'on')
    plot(AH2, RayAngleSet, RayWindSpeed')
    plot(AH2, RayAngleSet, RayWindSpeed', 'k.')
    hold(AH2, 'off')
    xlim(AH2, [RayAngleSet(1) RayAngleSet(end)])
    xlabel(AH2, 'Ray angle (deg)')
    ylabel(AH2, 'Measured wind speed (m/s)')
    ylim(AH2, [-18 0])
    grid(AH2, 'on')

end

