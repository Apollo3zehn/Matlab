function [] = AnnualEnergyProduction()

    clc
    clear
    close all

    FH        = figure ('name', '', ...
                                    'color', 'w', ...
                                    'PaperPositionMode', 'manual', ...
                                    'PaperUnits', 'points', ... 
                                    'PaperSize', [700 400], ...  
                                    'PaperPosition', [0 0 700 400], ...
                                    ...
                                    'Units', 'Points', ...
                                    'Position',[0 0 700 400], ...
                                    ...
                                    'WindowStyle', 'docked');
                                
    figure(FH)
    clf(FH)
    
    WindSpeed       = 0 : 0.5 : 25;
    Power           = [0 0 0 0 0 150 400 800 1200 1800 2500 3500 5000 5000 5000 5000 5000 5000 5000 5000 5000 5000 5000 5000 5000 5000];
    Power           = interp1(0 : 1 : 25, Power, WindSpeed);
    
    k = 2;
    A = 8;

    Probability     = Distribution.WeibullPdf(WindSpeed, k, 1/A);

    %% Plot
    
    ScalingFactor   = max(max(Power, Probability));
    
    hold('on')
    area(WindSpeed, Probability * ScalingFactor / max(Probability), 'FaceColor', [0.1, 0.1, 0.1], 'EdgeColor', 'none');
    area(WindSpeed, Power, 'FaceColor', [0.4, 0.4, 0.4], 'EdgeColor', 'none')
    h = area(WindSpeed, Power .* Probability * ScalingFactor / max((Power .* Probability)), 'FaceColor', [0.75, 0.75, 0.75]);
    set(get(h, 'children'), 'FaceAlpha', 0.7, 'LineWidth', 2);
    ylim([0 7000])
    legend({'Probability', 'Power Curve', 'Annual energy production'})
    xlabel('Wind speed (m/s)')
    set(gca, 'YTick', [])
    box('on')
    Figure.SaveAsEmf(FH, 'M:\Data Analysis\Testumgebung_VWI\Test')
    
end

