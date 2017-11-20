function GalionData = CutDataAfterChangeOfDay(GalionData)

    Length          = size(GalionData(:, 4), 1);
    StartIndices    = find(diff(GalionData(:, 4)) < 0) + 1;
    StopIndices     = find(diff(GalionData(:, 4)) > 0.5);
    
    if numel(StartIndices) < numel(StopIndices)
        StartIndices = [1; StartIndices];
    elseif numel(StopIndices) < numel(StartIndices)
        StopIndices = [StopIndices; Length];
    end
    
    Indices = Logical.StartAndStopIndicesToLogical(StartIndices, StopIndices, Length);
    
    GalionData = GalionData(~Indices, :);
        
end

