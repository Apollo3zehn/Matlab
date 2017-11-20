function Result = BitwiseMin(Data)

    if ~isvector(Data) || ~numel(Data >= 2)
        error('Data must be a vector with length >= 2.')
    end

    Result = Data(1);
    
    for i = 2 : length(Data)
        Result = bitand(Result, Data(i));
    end
    
end