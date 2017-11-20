classdef Extension < handle
    
    properties (GetAccess = 'public', SetAccess = 'public')
        Data   
    end
    
    properties (Dependent, GetAccess = 'public', SetAccess = 'private')
        DateTimes
        TimeLineDateTimes
    end
   
    methods
       
        function [obj] = Extension(Data)
            obj.Data = Data;
            obj.CutIncompleteScan;
        end  

        function [] = CutIncompleteScan(Me)
           
            if size(Me.Data, 1) > 0      
                EndOfRays   = find(Me.Data(:, 1) == (Me.RangeGateCount - 1));
                Me.Data     = Me.Data(1 : EndOfRays(end), :);
            end 
            
        end
             
        function [DateTimes] = get.DateTimes(Me)
            DateTimes       = Me.Data(:, 4);
        end
        
        function [TimeLineData] = TimeLineData(Me)
           TimeLineData     = reshape(Me.Data, Me.RangeGateCount, [], 8);
        end
              
        function [DateTimeBegin] = DateTimeBegin(Me)
            DateTimeBegin   = Me.Data(1, 4);
        end
        
        function [DateTimeEnd] = DateTimeEnd(Me)
            DateTimeEnd     = Me.Data(end, 4);
        end

        function [RowCount] = RowCount(Me)
            RowCount        = length(Me.Data);
        end
        
        function [RangeGateCount] = RangeGateCount(Me)
            RangeGateCount  = max(Me.Data(:, 1)) + 1;
        end
        
        function [RayCount] = RayCount(Me)
            RayCount        = Me.RowCount / Me.RangeGateCount;
        end
        
        function [DistanceValues] = DistanceValues(Me)
            DistanceValues = linspace(Galion.RangeGateDistance - (Galion.RangeGateDistance / 2), ...
                                      Me.MaximumRange - (Galion.RangeGateDistance / 2), ...
                                      Me.RangeGateCount)';
        end
        
        function [MaximumRange] = MaximumRange(Me)
            MaximumRange = Me.RangeGateCount * Galion.RangeGateDistance;
        end
        
        function [MeanWindSpeed] = MeanWindSpeed(Me)
            WindSpeedData   = Me.Data(~isnan(Me.Data(:, 2)), 2);
            MeanWindSpeed   = mean(WindSpeedData);    
        end
        
        function [SampleFrequency] = SampleFrequency(Me)
            SampleFrequency= Me.RayCount / ((Me.DateTimeEnd - Me.DateTimeBegin) * 24 * 60 * 60);
        end 
        
        function [Quality] = Quality(Me)
            Quality        = sum(~isnan(Me.Data(:, 2))) / Me.RowCount;
        end
        
%         function [TurbulenceIntensity] = TurbulenceIntensity(Me)
%                        
%             Sections        = Me.DateTimeBegin : TimeSpan(0, 0, 10, 0).ToDateTime : Me.DateTimeEnd;
%             SectionCount    = numel(Sections);
%                         
%             TurbulenceIntensity = NaN(SectionCount - 1, 1);
%             
%             if SectionCount > 1
%             
%                 for SectionNumber = 1 : SectionCount - 1
%                     
%                     DateTimeBegin   = Sections(SectionNumber);
%                     DateTimeEnd     = Sections(SectionNumber + 1);
%                     
%                     WindSpeed       = Me.Data(DateTimeBegin <= Me.Data(:, 4) & ... 
%                                               Me.Data(:, 4) <= DateTimeEnd & ...
%                                               ~isnan(Me.Data(:, 2)) & ...
%                                               Me.Data(:, 1) >= Galion.FirstTurbulenceIntensityRangeGate, 2);
%                     
%                     TurbulenceIntensity(SectionNumber) = std(WindSpeed) / mean(WindSpeed);
%                     
%                 end
%             
%             end
%             
%             TurbulenceIntensity = mean(TurbulenceIntensity, 'omitnan');
%             
%         end
                
    end
    
end