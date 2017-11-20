function RayWindSpeed = Measurement(x, y, u, v, RayCoordinatesX, RayCoordinatesY)

    % Simulates a LIDAR measurement (no input validation for speed-up)
    %
    % - Syntax -
    %
    % WindRoseData = WindRose(AxisHandle, WindDirectionData, WindSpeedData, WindDirectionBins, WindSpeedBins, CirclePositions, Title, Parameters)
    %
    % - Inputs -
    %
    % x                 - x-coordinates in ndgrid format
    % y                 - y-coordinates in ndgrid format
    % u                 - u-component of wind velocity field (maps to x-axis) in ndgrid format
    % v                 - v-component of wind velocity field (maps to y-axis) in ndgrid format
    % RayCoordinatesX 	- n x m matrix containing the x-coordinates of the measurement points of the rays
    % RayCoordinatesY   - n x m matrix containing the y-coordinates of the measurement points of the rays
    %
    % - Outputs -
    %
    % RayWindSpeed      - n x m matrix containing the simulated measurement result of the wind velocity field
   
    u_interpolated          = interp2(x.', y.', u.', RayCoordinatesX.', RayCoordinatesY.');
    v_interpolated          = interp2(x.', y.', v.', RayCoordinatesX.', RayCoordinatesY.');
    
    u_interpolated          = u_interpolated.';
    v_interpolated          = v_interpolated.';
        
    WindSpeedVector         = [u_interpolated(:) v_interpolated(:)];
    WindSpeedVector_Norm    = LinearAlgebra.pNorm(WindSpeedVector.', 2);
    
    RayCoordinates        	= [RayCoordinatesX(:) RayCoordinatesY(:)];
    RayCoordinates_Norm    	= LinearAlgebra.pNorm(RayCoordinates.', 2);  
    
    RayWindSpeed            = WindSpeedVector_Norm .* dot(WindSpeedVector.', RayCoordinates.') ./ (WindSpeedVector_Norm .* RayCoordinates_Norm);
    RayWindSpeed            = reshape(RayWindSpeed, size(RayCoordinatesX));
    
end

