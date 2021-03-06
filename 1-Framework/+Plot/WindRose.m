function WindRoseData = WindRose(AxisHandle, WindDirectionData, Data, WindDirectionBins, WindSpeedBins, CirclePositions, Title, varargin)

    % Wind rose of direction and frequency distribution
    %
    % - Syntax -
    %
    % WindRoseData = WindRose(AxisHandle, WindDirectionData, WindSpeedData, WindDirectionBins, WindSpeedBins, CirclePositions, Title, Parameters)
    %
    % - Inputs -
    %
    % AxisHandle            - Required when plotting is intended, in other cases can be left empty [].
    % WindDirectionData     - Vector that contains the wind direction of each element of WindSpeedData.
    % Data                  - Vector that contains the wind speed or in case of -IsEnergyRose it contains the energy. Must be the same length as WindDirectionData.
    % WindDirectionBins     - Vector that contains the center position for the wind direction bins. Must be monotonically increasing.
    % WindSpeedBins         - Vector that contains the center position for the wind speed bins. Must be monotonically increasing.
    % CyclePositions        - Vector that contains the position of the frequency cycles in percent.
    % Title                 - String that contains the title string of the wind rose. Can be left empty [].
    %
    % Parameters         
    %   -IsEnergyRose       - Specifies that instead of the wind rose the energy rose should be calculated.
    %
    %   -DisableDecorations - Specifies that the pure wind rose (without any decorations) will be drawn.
    %   -DisableNSEW        - Specifies that the NORTH, SOUTH, EAST, WEST labels will not be drawn.
    %   -DisableCross       - Specifies that the cross will not be drawn.
    %   -DisableCircles     - Specifies that the circles will not be drawn.
    %   -DisablePercentages - Specifies that the percentage labels will not be drawn.
    %   -DisableLegend      - Specifies that the legend will not not be drawn.
    %
    %   FreeWindSector      - Vector that specifies the minmum and maximum wind direction with free approaching flow.
    %
    % - Outputs -
    %
    % WindRoseData      - Optional output. Two dimensional matrix that 
    %                     contains the calculated absolute frequencies* for 
    %                     each bin. First dimension is wind direction, 
    %                     second dimension is wind speed.
    %                     * in case of -IsEnergyRose it contains the absolute energy
    %
    % - Test -
    %
    % WindRoseData = WindRose(gca, 360 * rand(1000, 1), 40 * rand(1000, 1), 0 : 30 : 330, 2.5 : 5 : 37.5, [5 10 15 20], 'My first wind rose!');
    % WindRose(gca, 360 * rand(1000, 1), 40 * rand(1000, 1), 0 : 30 : 330, 2.5 : 5 : 37.5, [5 10 15 20], 'My first wind rose!')
    % WindRose(gca, 360 * rand(1000, 1), 40 * rand(1000, 1), 0 : 30 : 330, 2.5 : 5 : 37.5, [5 10 15 20], 'My first wind rose!', 'FreeWindSector', [180 245])
    % WindRose(gca, 360 * rand(1000, 1), 1.225/2 * (40 * rand(1000, 1)).^3 * pi*135 * 10/60, 0 : 30 : 330, [0 inf], [5 10 15 20], 'My first energy rose!', '-IsEnergyRose')
    % WindRose(gca, 360 * rand(1000, 1), 40 * rand(1000, 1), 0 : 30 : 330, 2.5 : 5 : 37.5, [5 10 15 20], '', '-DisableDecorations')

    %% Verify input data and options
    
    % Default values
    IsEnergyRose            = false;
    IsNsewEnabled           = true;
    IsCrossEnabled          = true;
    IsCirclesEnabled        = true;
    IsPercentagesEnabled 	= true;
    IsLegendEnabled         = true;

    FreeWindSector          = [NaN NaN];
    
    if ~isvector(WindDirectionData)
        error('WindDirectionData must a vector.')
    end
    
    if ~isvector(Data)
        error('WindSpeedData must a vector.')
    end
    
    if numel(WindDirectionData) ~= numel(Data)
        error('WindDirectionData and WindSpeedData must be the same length.')
    end
    
    if ~isvector(WindDirectionBins)
        error('WindDirectionBins must a vector.')
    end
    
    if ~isvector(WindSpeedBins)
        error('WindSpeedBins must a vector.')
    end
    
    if ~isvector(CirclePositions)
        error('CirclePositions must a vector.')
    end
        
    if ~isempty(Title) && (~ischar(Title) || ~isvector(Title))
        error('Title must be a char array.')
    end 
    
    for ArgumentNumber = 1 : numel(varargin)
       
        Parameter = varargin{ArgumentNumber};
        
        if isnumeric(Parameter)
            
            continue
            
        elseif strcmp(Parameter, '-DisableDecorations')
            
            IsNsewEnabled       = false;
            IsCrossEnabled      = false;
            IsCirclesEnabled    = false;
            IsPercentagesEnabled= false;
            IsLegendEnabled     = false;
            
        elseif strcmp(Parameter, '-IsEnergyRose')
            
            IsEnergyRose        = true;
            IsLegendEnabled     = false;
            
        elseif strcmp(Parameter, '-DisableNSEW')
            
            IsNsewEnabled       = false;
        
        elseif strcmp(Parameter, '-DisableCross')
            
            IsCrossEnabled      = false;
            
        elseif strcmp(Parameter, '-DisableCircles')
            
            IsCirclesEnabled    = false;
            
        elseif strcmp(Parameter, '-DisablePercentages')
            
            IsPercentagesEnabled= false;
            
        elseif strcmp(Parameter, '-DisableLegend')
            
            IsLegendEnabled     = false;
                        
        elseif strcmp(Parameter, 'FreeWindSector')
                        
            FreeWindSector  = varargin{ArgumentNumber + 1};
            
            if FreeWindSector(2) < FreeWindSector(1)
                FreeWindSector(2) = FreeWindSector(2) + 360;
            end
            
        end
        
    end
    
    %% Settings and preparation

    Plot_CoreSize                   =  0.03;
    Plot_ColorAxisXOffset           =  1.40;
    Plot_ColorAxisYOffset           = -1.00;
    Plot_ColorAxisVSpace            =  0.06;
    Plot_ColorAxisHSpace            =  0.05;
    Plot_ColorAxisHeight            =  0.06;
    Plot_ColorAxisWidth             =  0.10;
       
    Data                            = Data(:);
    WindSpeedBins                   = WindSpeedBins(:)';
    WindSpeedBinCount               = numel(WindSpeedBins);
    
    WindDirectionData               = WindDirectionData(:);
    WindDirectionBins               = WindDirectionBins(:)';
    WindDirectionBinCount           = numel(WindDirectionBins);
    
    CirclePositions                 = CirclePositions(:);
    OuterCircle                     = max(CirclePositions);
    
    WindDirectionBinEdges           = Statistics.CalculateBinEdges(WindDirectionBins, false);
    WindSpeedBinEdges               = Statistics.CalculateBinEdges(WindSpeedBins, false);
    
    % Move data to correct bins in case where a bin edge is negative
    Indices                         = WindDirectionData > (360 + min(WindDirectionBinEdges));
    WindDirectionData(Indices)      = WindDirectionData(Indices) - 360;
    
    %% Calculation
    
    WindRoseData                    = zeros(WindDirectionBinCount, WindSpeedBinCount);
    
    [WindDirectionBinIndices, ~]    = Statistics.SortDataIntoBins(WindDirectionData, WindDirectionBins, false, false);
    
    % For each wind direction
    for WindDirectionBinIndex = unique(WindDirectionBinIndices)'

        if WindDirectionBinIndex == 0 
            continue
        end
        
        SubWindSpeedData            = Data(WindDirectionBinIndices == WindDirectionBinIndex, :);
        [WindSpeedBinIndices, ~]    = Statistics.SortDataIntoBins(SubWindSpeedData, WindSpeedBins, false, false);
        
        % For each wind speed
        for WindSpeedBinIndex = unique(WindSpeedBinIndices)'
            
            if WindSpeedBinIndex == 0 
                continue
            end
            
            if IsEnergyRose
                WindRoseData(WindDirectionBinIndex, WindSpeedBinIndex) = sum(SubWindSpeedData(WindSpeedBinIndices == WindSpeedBinIndex));
            else
                WindRoseData(WindDirectionBinIndex, WindSpeedBinIndex) = numel(SubWindSpeedData(WindSpeedBinIndices == WindSpeedBinIndex));
            end
                       
        end
            
    end
    
    % Normalization
    
    if IsEnergyRose
        NormalizedWindRoseData = WindRoseData / sum(Data);
    else
        NormalizedWindRoseData = WindRoseData / numel(Data);
    end
    
    % If AxisHandle is empty, return the calculated data but without plotting
    if isempty(AxisHandle)
        return
    end
    
    %% Plot
    
    AH = AxisHandle;
    
    cla(AH, 'reset')
    axis(AH, 'equal')
    axis(AH, 'off')
    set(AH, ...
        'XTick', [], ...
        'YTick', [], ...
        'XColor', 'w', ...
        'YColor', 'w', ...
        'box', 'off', ...
        'XLim', [-1.5 1.7], ...
        'YLim', [-1.2 1.4])
        
    hold(AH, 'on')
    
    % free wind sector
    if ~isnan(FreeWindSector)
        
        FreeWindSector = Statistics.NorthRelatedAngleToMathAngle(FreeWindSector / 180*pi);
        
        % light
        x         	= [0 cos(linspace(FreeWindSector(2), FreeWindSector(1), 360))];
        y         	= [0 sin(linspace(FreeWindSector(2), FreeWindSector(1), 360))];
        
        fill(x, y, [0.9 0.9 0.9], 'Parent', AH); 
        
        % dark
        x         	= [0 cos(linspace(FreeWindSector(2), -2*pi + FreeWindSector(1), 360))];
        y         	= [0 sin(linspace(FreeWindSector(2), -2*pi + FreeWindSector(1), 360))];
        
        fill(x, y, [0.55 0.55 0.55], 'Parent', AH);

    end  
    
    % fill
    MaxColorCount   = 256;    
    FillColors   	= jet(MaxColorCount);
    FillColors    	= FillColors(Colormap.ScaleIndicesToMaximumRange(WindSpeedBinCount, MaxColorCount), :);
        
    for WindDirectionBinIndex = 1 : WindDirectionBinCount

        InnerRadius = 0;
        
        for WindSpeedBinIndex = 1 : WindSpeedBinCount;

            OuterRadius = InnerRadius + NormalizedWindRoseData(WindDirectionBinIndex, WindSpeedBinIndex) / OuterCircle * 100;

            if OuterRadius == InnerRadius
                continue
            end
            
            FillSteps = Statistics.NorthRelatedAngleToMathAngle(linspace(WindDirectionBinEdges(WindDirectionBinIndex), WindDirectionBinEdges(WindDirectionBinIndex + 1), 20) / 180 * pi)';

            x = [max(InnerRadius, Plot_CoreSize) * cos(FillSteps(1)); ...
                 max(OuterRadius, Plot_CoreSize) * cos(FillSteps); ...
                 max(InnerRadius, Plot_CoreSize) * cos(flipud(FillSteps))];

            y = [max(InnerRadius, Plot_CoreSize) * sin(FillSteps(1)); ...
                 max(OuterRadius, Plot_CoreSize) * sin(FillSteps); ...
                 max(InnerRadius, Plot_CoreSize) * sin(flipud(FillSteps))];

            fill(x, y, FillColors(WindSpeedBinIndex, :), 'Parent', AH)

            InnerRadius = OuterRadius;

        end
    
    end
    
    % cross
    if IsCrossEnabled
        plot(AH, [-1 -Plot_CoreSize NaN Plot_CoreSize 1], [0 0 NaN 0 0], '--k')
        plot(AH, [0 0 NaN 0 0], [-1 -Plot_CoreSize NaN Plot_CoreSize 1], '--k')
    end
    
    % circles and percentages
    x         	= cosd(0 : 1 : 360);
    y         	= sind(0 : 1 : 360);

    fill(x * Plot_CoreSize, y * Plot_CoreSize, 'w', 'Parent', AH);
    
    for CirclePosition = CirclePositions'
        
        RelativePosition = CirclePosition / OuterCircle;
        
        if IsCirclesEnabled
            if RelativePosition == 1;
                plot(AH, x * RelativePosition, y * RelativePosition, '-k')
            else
                plot(AH, x * RelativePosition, y * RelativePosition, '--k')
            end
        end
        
        if IsPercentagesEnabled
            text(1+0.03, ...
                 RelativePosition, ...
                 sprintf('%g%%', CirclePosition), ...
                 'VerticalAlignment', 'middle', ...
                 'Parent', AH)
        end
             
    end
  
    % title
    if ~isempty(Title)
        text(0, 1.35, ['{\bf ' sprintf('%s', Title) '}'], 'HorizontalAlignment', 'center', 'Parent', AH);
    end
    
    % N S E W Labels
    if IsNsewEnabled
        text( 1+0.03,  0, '{\bf EAST}',   'HorizontalAlignment', 'left',  'VerticalAlignment', 'middle', 'Parent', AH);
        text( 0,  1+0.03, '{\bf NORTH}',  'HorizontalAlignment', 'center','VerticalAlignment', 'bottom', 'Parent', AH);
        text(-1-0.03,  0, '{\bf WEST}',   'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Parent', AH);
        text( 0, -1-0.03, '{\bf SOUTH}',  'HorizontalAlignment', 'center','VerticalAlignment', 'top',    'Parent', AH);
    end
        
    % color axis legend
    if IsLegendEnabled
        
        LowerHeight = 0;
    
        for WindSpeedBinIndex = 1 : WindSpeedBinCount

            UpperHeight = LowerHeight + Plot_ColorAxisHeight;

            x = [0 Plot_ColorAxisWidth Plot_ColorAxisWidth 0] + Plot_ColorAxisXOffset;
            y = [LowerHeight LowerHeight UpperHeight UpperHeight] + Plot_ColorAxisYOffset;

            fill(x, y, FillColors(WindSpeedBinIndex, :), 'Parent', AH);

            if any(WindSpeedBinEdges - floor(WindSpeedBinEdges));
                Format = '%4.1f-%4.1f';
            else
                Format = '%2.0f-%2.0f';
            end

            text(x(2) + Plot_ColorAxisHSpace, y(2) + (y(3) - y(2)) / 2, ...
                 sprintf(Format, ...
                 WindSpeedBinEdges(WindSpeedBinIndex), ...
                 WindSpeedBinEdges(WindSpeedBinIndex + 1)), ...
                 'VerticalAlignment', 'middle', ...
                 'FontName', 'FixedWidth', ...
                 'FontWeight', 'Bold', ...
                 'Parent', AH);

            LowerHeight = UpperHeight + Plot_ColorAxisVSpace;

        end 
        
    end
       
    hold(AH, 'off')

    if nargout == 0
        clear('WindRoseData');
    end
            
end