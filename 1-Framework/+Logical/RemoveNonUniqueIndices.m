% Finds the first occurrence of '1' per row and sets all other entries to zero

function [LogicalArray] = RemoveNonUniqueIndices(LogicalArray, RightToLeft)

    ColumnIndices = 2 : size(LogicalArray, 2);

    if ~RightToLeft
       ColumnIndices = fliplr(ColumnIndices) - 1; 
    end

    Mask = LogicalArray(:, end);
    
    for ColumnIndex = ColumnIndices
      
        NewMask         = or(Mask, LogicalArray(:, ColumnIndex));
        NewColumn       = and(~Mask, LogicalArray(:, ColumnIndex));
        
        Mask            = NewMask;
    	LogicalArray(:, ColumnIndex) = NewColumn;
        
    end

end

