function Result = CumulativeMean(Data, IndicesToIgnore)

    Data(IndicesToIgnore)       = 0;
    Result                      = cumsum(Data) ./ cumsum(~IndicesToIgnore);
    Result(IndicesToIgnore)     = NaN;
    
end

