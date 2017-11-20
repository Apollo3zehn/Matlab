function [SumPerGroup, GroupSize] = CumulateGroups(Logical, Data)

    %% Verify input data
    
    if ~islogical(Logical)
        error('Input Logical must be of type logical.')
    end
    
    if isempty(Data)
        Data = Logical;
    end
    
    if isvector(Logical) && ismatrix(Data) && size(Logical, 1) == size(Data, 1)
        Logical = Logical(:);
    else
        error('All inputs must be vectors of the same length.')
    end
    
    %% Calculation
    
    Indices             = diff([Logical; 0]) == -1;
    Data(~Logical, :)   = 0;

    SumPerGroup         = cumsum(Data);
    SumPerGroup         = [SumPerGroup(find(Indices, 1, 'first'), :); diff(SumPerGroup(Indices, :))];
    
    GroupSize           = cumsum(Logical);
    GroupSize           = diff([0; GroupSize(Indices)]);

end

