function Statistics = DetermineWindFieldProperties(Data, RayAngleSet, GateLength, GateCount, WindShear, WindDirection, IsPlotRequired)

    % Grid
    x               = ((0 : Data.FftLength - 1) - (Data.FftLength - 1) / 4) * Data.dx;
    y               = ((0 : Data.Ny        - 1) - (Data.Ny        - 1) / 2) * Data.dy;
    [x, y]          = ndgrid(x, y);

    % Wind field
    u               = -Data.WindField_x(:, :, 1) + WindShear * y;
    v               = Data.WindField_y(:, :, 1);
    [u, v]          = Transformation2D.RotateVectorField(x, y, u, v, WindDirection/180*pi); 
    
    % Lidar rays
    RayCoordinatesX	= GateLength * (0 : GateCount-1)' * cosd(RayAngleSet);
    RayCoordinatesY	= GateLength * (0 : GateCount-1)' * sind(RayAngleSet);
    
    RayCoordinatesX	= RayCoordinatesX(Galion.FirstUsableRangeGate + 1 : end, :);
    RayCoordinatesY	= RayCoordinatesY(Galion.FirstUsableRangeGate + 1 : end, :);
    
    % Measurement
    RayWindSpeed    = LidarSimulation.Measurement(x, y, u, v, RayCoordinatesX, RayCoordinatesY);

    % Solve
    Delegate                   	= @(x) SystemEquation(x);

    [Result, MetaData]        	= ParameterIdentification.LevenbergMarquardt(Delegate, [4; 0; 0], 0.01);

    Statistics.MeanWindSpeed 	= Result(1);
    Statistics.WindDirection   	= Result(2);
    Statistics.WindShear     	= Result(3); 
    Statistics.MetaData         = MetaData; 
    
    if IsPlotRequired
        
        OutputPath              = [Environment.OutputPath '\General\' Reflection.FunctionName sprintf('\\WindDirection %d deg, WindShear %.1f ms-1', WindDirection, WindShear)];
        set(gcf, 'DefaultAxesColorOrder', hot(GateCount*2))
        LidarSimulation.Plot(gcf, x, y, u, v, RayCoordinatesX, RayCoordinatesY, RayAngleSet, RayWindSpeed)
        Figure.SaveAsPdf(gcf, OutputPath)
                
    end
    
    function F = SystemEquation(Y)
    
        [u_Trial, v_Trial]  = LidarSimulation.CreateSimpleWindField(x, y, Y(1), Y(2), Y(3));
        TrialRayWindSpeed 	= LidarSimulation.Measurement(x, y, u_Trial, v_Trial, RayCoordinatesX, RayCoordinatesY);
        F                   = TrialRayWindSpeed(:) - RayWindSpeed(:);
    
    end
    
end

