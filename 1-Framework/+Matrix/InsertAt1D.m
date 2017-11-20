function Result = InsertAt1D(Data, InsertPositions, InsertValues, PositionMode)

    % Insert data into vector at specific positions
    %
    % - Syntax -
    %
    % [Result] = InsertAt(Data, InsertPositions, NewValue, IsRelativePositions)
    %
    % - Inputs -
    %
    % Data                  - Original vector
    % InsertPositions       - Positions where new data should be inserted
    % InsertValues          - Values to insert
    % PositionMode          - 1: Relative positions
    %                         2: Absolute positions relative to input data size
	%                         3: Absolute positions relative to output data size
    %
    % - Outputs -
    %
    % Result                - New vector with inserted data. 
    %
    % - Test -
    %
    % Result = Matrix.InsertAt1D([0 1 2 3 4 5], [1 2 5 7 9], [10 15 20 30 40], false)
    % Result = Matrix.InsertAt1D([0 1 2 3 4 5], [1 2 1 2 1], [10 15 20 30 40], true)
    %
    % - Index definition -
    %
    % Value:     a b c d e f
    % Position: 1 2 3 4 5 6 7  

    %% Check input data
    
    if ~isvector(Data)
        error('Data must a vector.')
    end
    
    if ~isvector(InsertPositions)
        error('InsertPositions must a vector.')
    end
    
    if ~isvector(InsertValues)
        error('InsertValues must a vector.')
    end
    
    if numel(InsertValues) > 1 && numel(InsertPositions) ~= numel(InsertValues)
        error('InsertPositions and InsertValues must be the same length.')
    end
    
    %% Preparation
    
    Data            = Data(:);
    InsertPositions = InsertPositions(:);
    InsertValues    = InsertValues(:);

    switch PositionMode
        case 1
            InsertPositions             = cumsum(InsertPositions + 1) - 1;
        case 2
            InsertPositions             = cumsum([InsertPositions(1, 1); diff(InsertPositions) + 1]);
        case 3
            
        otherwise
            error('Specified position mode not supported.')
    end
       
    NewLength                       = length(Data) + length(InsertPositions);
    
    if min(InsertPositions) < 1 || max(InsertPositions) > NewLength
        error('At least one insert position exceeds the range from 0 to data length + 2.')
    end
    
    Result(NewLength, 1)            = NaN;   
    Result(InsertPositions)         = InsertValues;
    
    DataPositions                   = 1 : length(Result); 
    DataPositions(InsertPositions)  = [];
    
    Result(DataPositions)           = Data;
        
end

