function [RangeValues, NumberOfCycles] = StressRangeHistogram(FromToMatrix)
    
    FullCyclesMatrix        = min(FromToMatrix, FromToMatrix');
    
    SizeOfMatrix            = length(FullCyclesMatrix);
    [FromIndices, ToIndices]= ind2sub(SizeOfMatrix, find(FullCyclesMatrix > 0));
    NumberOfEntries         = length(FromIndices);
    
    FromValues              = FromIndices - ceil(SizeOfMatrix / 2);
    ToValues                = ToIndices - ceil(SizeOfMatrix / 2);
    RangeValues             = NaN(NumberOfEntries, 1);
    MeanValues              = NaN(1, NumberOfEntries);
    NumberOfCycles          = NaN(NumberOfEntries, 1);
    
    for i = 1 : NumberOfEntries
        
        From    = FromValues(i);
        To      = ToValues(i);

        if To >= From
            continue
        end

        RangeValues(i)    = From - To;
        MeanValues(i)     = round((From + To) / 2);
        NumberOfCycles(i) = FullCyclesMatrix(FromIndices(i), ToIndices(i));

    end
    
    RangeValues         = RangeValues(~isnan(RangeValues));
    MeanValues          = MeanValues(~isnan(MeanValues));
    NumberOfCycles      = NumberOfCycles(~isnan(NumberOfCycles));
    
    % Achtung, MeanValues wird positiv gesetzt, damit die sparse Matrix
    % richtig indiziert wird. MeanValues ist in dieser Form nicht korrekt.
    RangeMeanMatrix     = sparse(RangeValues, abs(MeanValues), NumberOfCycles);
    
    RangeValues         = flipdim((1 : size(RangeMeanMatrix, 1))', 1);
    NumberOfCycles      = cumsum(flipdim(full(sum(RangeMeanMatrix, 2)'), 2));
    
end

