function [] = RotorEquivalentWindSpeedBehavior
    clc
    clear
    close('all')

    %% Settings

    % Rotor settings
    RotorDiameter    	= 135;
    RotorRadius      	= RotorDiameter / 2;
    HubHeight       	= 130;
    StepSize            = 0.1;

    % Rotor coordinates
    RotorCoordinatesY 	= (HubHeight - RotorRadius) : StepSize : (HubHeight + RotorRadius);
    RotorCoordinatesX 	= sqrt(RotorRadius ^ 2 - (RotorCoordinatesY - HubHeight).^2);
    RotorPanelElements  = (RotorCoordinatesX * 2 * StepSize)';

    % Shear exponent
    ShearExponent    	= 0 : 0.01 : 0.4;

    ReferenceHeight   	= HubHeight;
    ReferenceWindSpeeds = 4 : 15;

    % Plot preparation
    ColorMap            = bone(25);
    AH                  = subplot(1, 1, 1);

    for ReferenceWindSpeed = ReferenceWindSpeeds

        %% Calculation

        % v_1   z_1 ^ a
        % --- = ---
        % v_2   z_2

        % For few large panel elements Bianca's equation suits better
        WindProfile                 = bsxfun(@power, RotorCoordinatesY' / ReferenceHeight, ShearExponent) * ReferenceWindSpeed;
        RotorEquivalentWindSpeed    = nthroot(1 / sum(RotorPanelElements) * sum(bsxfun(@times, WindProfile .^ 3, RotorPanelElements)), 3);

        %% Plot   
        hold(AH, 'on')
        plot(AH, ShearExponent, ReferenceWindSpeed - RotorEquivalentWindSpeed, 'color', ColorMap(ReferenceWindSpeed, :));

    end

    %plot(AH, WindProfile(:, (1 : 5 : length(ShearExponent))), RotorCoordinatesY, 'color', ColorMap(ReferenceWindSpeed, :));

    xlabel(AH, 'Shear exponent \alpha')
    ylabel(AH, 'v_{hub} - v_{eq}')
    title(AH, 'Relation of hub height wind speed to the rotor equivalent wind speed')
    grid(AH, 'on')
    
end