function [FromToMatrix] = RainflowCounting(Data, Bins)

    Display.TextWithoutBreaks('Executing RainflowCounting ... ')

    BinData             = Statistics.NormalizeDataToBins(Data, Bins);

    [Positions, Types]  = Calculation.Extrema(BinData);
    BinData             = BinData(Positions);
    PositionCount       = length(Positions);
    
    FromValues          = NaN(PositionCount - 1, 1);
    ToValues            = NaN(1, PositionCount - 1);
        
    IsIncomingWayClear  = ones(PositionCount, 1);
    
    %                To
    %          x  x  x  x  x 
    %          x  x  x  x  x 
    %    From  x  x  x  x  x 
    %          x  x  x  x  x 
    %          x  x  x  x  x 
    
    for MainPosition = 1 : PositionCount - 1

        From = BinData(MainPosition);
        FromValues(MainPosition) = From;

        switch(Types(MainPosition))

            % Tensile peak
            case 1

                for SubPosition = MainPosition + 1 : PositionCount

                    MinValue = min(BinData(MainPosition : SubPosition));

                    switch Types(SubPosition)

                        % Compressive valley
                        case -1

                            % It crosses a previous rain flow
                            if SubPosition - MainPosition == 1 && ~IsIncomingWayClear(SubPosition)

                                MinValue                = BinData(SubPosition - 2);
                                ToValues(MainPosition)  = MinValue;

                                break

                            % It reaches the end of time history
                            elseif SubPosition == PositionCount

                                ToValues(MainPosition)  = MinValue;

                                break

                            end          

                        % Tensile peak

                        case 1

                            % It flows opposite a tensile peak of greater magnitude:
                            if BinData(SubPosition) > From

                                ToValues(MainPosition)  = MinValue;

                                break

                            % It reaches the end of time history 
                            elseif SubPosition == PositionCount

                                ToValues(MainPosition)  = MinValue;

                                break

                            % It drops on the pagoda roof:
                            elseif BinData(SubPosition + 1) < MinValue

                                IsIncomingWayClear(SubPosition + 1) = false;

                            end        

                    end               

                end

            % Compressive valley
            case -1

                for SubPosition = MainPosition + 1 : PositionCount

                    MaxValue = max(BinData(MainPosition : SubPosition));

                    switch Types(SubPosition)

                        % Tensile peak
                        case 1

                            % It crosses a previous rain flow
                            if SubPosition - MainPosition == 1 && ~IsIncomingWayClear(SubPosition)

                                MaxValue                = BinData(SubPosition - 2);
                                ToValues(MainPosition)  = MaxValue;

                                break

                            % It reaches the end of time history
                            elseif SubPosition == PositionCount

                                ToValues(MainPosition)  = MaxValue;

                                break

                            end          

                        % Compressive valley

                        case -1

                            % It flows opposite a tensile peak of greater magnitude:
                            if BinData(SubPosition) < From

                                ToValues(MainPosition)  = MaxValue;

                                break

                            % It reaches the end of time history 
                            elseif SubPosition == PositionCount

                                ToValues(MainPosition)  = MaxValue;

                                break

                            % It drops on the pagoda roof:
                            elseif BinData(SubPosition + 1) > MaxValue

                                IsIncomingWayClear(SubPosition + 1) = false;

                            end        

                    end               

                end

        end

    end
   
    MatrixEdge      = max(abs([FromValues' ToValues]));
    
    FromValues      = FromValues + MatrixEdge + 1;
    ToValues        = ToValues + MatrixEdge + 1;
    
	FromToMatrix    = sparse(FromValues, ToValues, ones(length(FromValues), 1), MatrixEdge * 2 + 1, MatrixEdge * 2 + 1);
    
    Display.Done
    
end

