function [WindSpeed] = EstimateWindSpeed(AerodynamicMap, AirDensity, PitchAngle, RotorMoment, RotorSpeed)

    Display.TextWithoutBreaks('Estimating wind speed ... ')

    RowCount            = length(PitchAngle);

    cpMatrix            = interp2(AerodynamicMap.lambda_vec, ...
                                  AerodynamicMap.pitch_vec, ...
                                  AerodynamicMap.cp, ...
                                  AerodynamicMap.lambda_vec, ...
                                  PitchAngle .* 180 ./ pi, 'linear', NaN);
                             
    Indices             = AerodynamicMap.lambda_vec > 0;
    cpMatrix            = cpMatrix(:, Indices);
    TsrVector           = AerodynamicMap.lambda_vec(:, Indices);
       
    %% M = c_m * rho / 2 * A * v ^ 2
    RotorMomentMatrix   = 1/2 * (AerodynamicMap.RotorDiameter / 2)^5 * pi .* ...
                          AirDensity .* RotorSpeed .^ 2;
                      
    RotorMomentMatrix   = bsxfun(@times, RotorMomentMatrix, cpMatrix);
    RotorMomentMatrix   = bsxfun(@rdivide, RotorMomentMatrix, TsrVector .^ 3);

    clearvars('cpMatrix')
    
    %%
    
    % Find intersections of rotor moment vector and current rotor moment
    IsIntersection          = [diff(sign(bsxfun(@minus, RotorMomentMatrix, RotorMoment)), 1, 2) zeros(RowCount, 1)] ~= 0;
    RowHasIntersection      = sum(IsIntersection, 2) > 0;
    
    IsIntersection1         = Logical.RemoveNonUniqueIndices(IsIntersection, false);
    IsIntersection2         = circshift(IsIntersection1, [0 1]);
    IsIntersection2(:, 1)   = 0;
        
    % To list all elements of the matrix in the correct order when calculating the InterpolatedTsrVector
    IsIntersection1         = IsIntersection1';
    IsIntersection2         = IsIntersection2';
    RotorMomentMatrix       = RotorMomentMatrix';
    TsrMatrix               = repmat(TsrVector, RowCount, 1)';
    
    InterpolatedTsrVector   = NaN(RowCount, 1);
    InterpolatedTsrVector(RowHasIntersection) = LinearAlgebra.LinearInterpolation(RotorMoment(RowHasIntersection), ...
                                                                RotorMomentMatrix(IsIntersection1), RotorMomentMatrix(IsIntersection2), ...
                                                                TsrMatrix(IsIntersection1), TsrMatrix(IsIntersection2));
                                                              
    %%
    WindSpeed               = (AerodynamicMap.RotorDiameter / 2) .* RotorSpeed ./ InterpolatedTsrVector;

    Display.Done
    
    %% Test area
       
%     AH = axes;
%     cla(AH)
%     hold(AH, 'on')
%     plot(AH, RotorMomentMatrix(1, :), TsrVector, 'o-')  
%     plot([RotorMoment(1) RotorMoment(1)], [min(AerodynamicMap.lambda_vec)  max(AerodynamicMap.lambda_vec)], ':r')
%     plot(RotorMoment(1), InterpolatedTsrVector(1), '*r', 'linewidth', 3)
%     hold(AH, 'off')
%     
%     xlabel(AH, 'Rotor moment (Nm)')
%     ylabel(AH, 'Tip speed ratio (-)')
    
end

