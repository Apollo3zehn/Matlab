function [] = VisualizeCpMap(AerodynamicMap)

    AH = axes;

    cp = AerodynamicMap.cp;
    cp(~(0 <= cp & cp <= Environment.MaxPowerCoefficient)) = nan;
    
    surf(AH, AerodynamicMap.lambda_vec, AerodynamicMap.pitch_vec, cp)
    
    title(AH, 'C_p-map')
    xlabel(AH, '\lambda (-)')
    ylabel(AH, 'Pitch angle (°)')

    xlim([-5 20])
    ylim([-10 90])
    
    colorbar('peer', AH)
    
end

