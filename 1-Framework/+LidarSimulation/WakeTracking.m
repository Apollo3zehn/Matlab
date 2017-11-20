function StatisticsSet = WakeTracking(TimeLineDataWindSpeed, xPositions, RangeGates)

    Delegate                   	= @(x) SystemEquation(x);
    RangeGateOffset             = min(RangeGates);
    StatisticsSet(1, numel(RangeGates)) = struct('WakeOffset', [], 'MetaData', []);
    
    for RangeGateNumber = RangeGates
              
        [Result, MetaData]      = ParameterIdentification.LevenbergMarquardt(Delegate, [0 40 1000 -5; 0 5 30 0], 1);
        
        Statistics.WakeOffset 	= Result(1);
        Statistics.MetaData   	= MetaData; 
        StatisticsSet(1, RangeGateNumber + 1 - RangeGateOffset) = Statistics;
        
%         %% Plot
%         
%         xDistances              = xPositions(RangeGateNumber + 1, :);
%         WindSpeed               = TimeLineDataWindSpeed(RangeGateNumber + 1, :);
%         Gaussian                = (Result(1, 3) * SignalGeneration.Gaussian(Result(1, 1), Result(1, 2), xDistances)) - ...
%                                   (Result(2, 3) * SignalGeneration.Gaussian(Result(1, 1), Result(2, 2), xDistances)) + Result(1, 4);
%              
%         set(gcf, 'Position', [0 0 1500 650])
%         set(gcf, 'PaperPositionMode', 'manual', ...
%                                     'PaperUnits', 'points', ... 
%                                     'PaperSize', [1500 650], ...  
%                                     'PaperPosition', [0 0 1500 650])
% 
%         
%         if RangeGateNumber == 4
%             subplot(2, 2, 1)
%         elseif RangeGateNumber == 7
%             subplot(2, 2, 2)
%         elseif RangeGateNumber == 10
%             subplot(2, 2, 3)
%         elseif RangeGateNumber == 15
%             subplot(2, 2, 4)
%         else
%             continue
%         end
%             
%         plot(xDistances, -WindSpeed)
%         hold on
%         plot(xDistances, -Gaussian)
%         hold off   
%         grid on
%         pbaspect([2.5 1 1])
%         ylim([0 10])
%         xlim([-150 150])
%         ylabel('Wind speed in m/s')
%         xlabel('Lateral distance to AV07 in m')
%         
%         if RangeGateNumber == 4
%             title('Range gate 4 (135 m)')
%         elseif RangeGateNumber == 7
%             title('Range gate 7 (225 m)')
%         elseif RangeGateNumber == 10
%             title('Range gate 10 (315 m)')
%         elseif RangeGateNumber == 15
%             title('Range gate 15 (465 m)')
%         end
        
    end
    
    function F = SystemEquation(Y)
        
        xDistances              = xPositions(RangeGateNumber + 1, :);
        WindSpeed               = TimeLineDataWindSpeed(RangeGateNumber + 1, :);
        Gaussian                = (Y(1, 3) * SignalGeneration.Gaussian(Y(1, 1), Y(1, 2), xDistances)) - ...
                                  (Y(2, 3) * SignalGeneration.Gaussian(Y(1, 1), Y(2, 2), xDistances)) + Y(1, 4);            

        F                       = WindSpeed - Gaussian;    
        
    end
    
end

