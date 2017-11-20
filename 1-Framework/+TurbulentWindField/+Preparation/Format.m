function Data = Format(Data, TurbulenceIntensity)
    
    % Formats dimensionless wind speed deviations to get the real wind speed
    %
    % - Syntax -
    %
    % Data = Format(Data, TurbulenceIntensity)
    %
    % - Inputs -
    %
    % Data                      - Structure as provided by the turbulent wind field generators
    % TurbulenceIntensity (%)   - Optrional input. 3-component vector. Required for Kaimal or Mann wind field.
    %
    % - Outputs -
    %
    % Data                      - Structure with the modified field "WindField"

    switch Data.ID
                
        case 4 % Improved von Karman
            Data.WindField(:, :, :, 1) = Data.WindField(:, :, :, 1) * Data.MeanWindSpeed * Data.TurbulenceIntensity_u / 100 + Data.MeanWindSpeed;
            Data.WindField(:, :, :, 2) = Data.WindField(:, :, :, 2) * Data.MeanWindSpeed * Data.TurbulenceIntensity_v / 100;
            Data.WindField(:, :, :, 3) = Data.WindField(:, :, :, 3) * Data.MeanWindSpeed * Data.TurbulenceIntensity_w / 100;
            
        case {7, 8} % {Kaimal, Mann}      
            Data.WindField(:, :, :, 1) = Data.WindField(:, :, :, 1) * Data.MeanWindSpeed * TurbulenceIntensity(1) / 100 + Data.MeanWindSpeed;
            Data.WindField(:, :, :, 2) = Data.WindField(:, :, :, 2) * Data.MeanWindSpeed * TurbulenceIntensity(2) / 100;
            Data.WindField(:, :, :, 3) = Data.WindField(:, :, :, 3) * Data.MeanWindSpeed * TurbulenceIntensity(3) / 100;
            
        otherwise
            error('Model not implemented.')
            
    end
    
    Data.WindField_x    = permute(Data.WindField(:, :, :, 1), [3 1 2]);
    Data.WindField_y    = permute(Data.WindField(:, :, :, 2), [3 1 2]);
    Data.WindField_z    = permute(Data.WindField(:, :, :, 3), [3 1 2]);
    Data                = rmfield(Data, 'WindField');
    
end

