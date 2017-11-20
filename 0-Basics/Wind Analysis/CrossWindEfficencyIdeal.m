function [] = CrossWindEfficencyIdeal()

    clc
    clear
    close all
       
    %% Preparation
    
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
    
    %% Wind speed and power drop
       
    % P_Ratio = P(Phi) / P(Phi=0);
    % P_Ratio = (cp * rho / 2 * v³ * cos(Phi) * A * cos(Phi)) / (cp * rho / 2 * v³ * A);
    
    Phi     	= -pi/2 : pi/200 : pi/2;
    v_Ratio     = cos(Phi);
    P_Ratio     = cos(Phi).^4;

    %% Plot
    
    AH = axes;
    hold(AH, 'on')
    
    plot(AH, Phi * 180 / pi, v_Ratio, 'k--', 'LineWidth', 2);
    plot(AH, Phi * 180 / pi, P_Ratio, 'k', 'LineWidth', 3);
    
    box(AH, 'on')
    
    xlabel(AH, 'Inclination $\varphi$ (deg)', 'Interpreter', 'LaTex', 'FontSize', 15);
    %xlim(AH, [-20 20])
    xlim(AH, [min(Phi) max(Phi)] * 180 / pi);
    
    ylabel(AH, 'Ratio (-)', 'Interpreter', 'LaTex', 'FontSize', 15);
    %ylim(AH, [0.7 1.001]);
    ylim(AH, [0 1.001]);
    
    legend(AH, {'$U_\varphi / U_{\varphi=0}$', '$P_\varphi / P_{\varphi=0}$'}, 'Interpreter', 'LaTex', 'FontSize', 15);
    grid(AH, 'on')
    
    %% Save
    
    OutputPath = [Environment.OutputPath '\General\' Reflection.FunctionName '\Test'];
    
    Figure.SaveAsFig(FH, OutputPath)
    Figure.SaveAsEmf(FH, OutputPath)
    
end

