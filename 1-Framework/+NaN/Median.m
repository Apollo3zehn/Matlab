function MedianValues = Median(Data)

    try
        MedianValues = nanmedian(Data);
    catch
        error ('Not implemented.')
    end
    
end

