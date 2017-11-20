function Logical = StartAndStopIndicesToLogical(StartIndices, StopIndices, Length)

    if ~(islogical(StartIndices) && islogical(StopIndices)) || (~islogical(StartIndices) && ~islogical(StopIndices))
        error('StartIndices and StopIndices must be of the same type (logical or numerical array)')
    end   

    if islogical(StopIndices)
        StopIndices = logical([0; StopIndices(1 : end - 1)]);
    else
        StopIndices = StopIndices + 1;
    end
        
    Logical                 = zeros(Length + 1, 1);
    Logical(StartIndices)  	= 1;
    Logical(StopIndices)    = -1;
    Logical                 = cumsum(Logical(1 : end - 1)) ~= 0;

end

