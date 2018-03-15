function ScadaData10Minute = To10MinuteValues(ScadaData)

	BinEdges            = ScadaData.DateTimeBegin(1) : 1/144 : ScadaData.DateTimeBegin(end);
    BinIndicesBegin     = Statistics.SortDataIntoBins(ScadaData.DateTimeBegin, BinEdges, true, false);
    BinIndicesEnd       = Statistics.SortDataIntoBins(ScadaData.DateTimeEnd, BinEdges, true, false);
     
    ScadaData.StartDate                     = [];
    ScadaData.StartTime                 	= [];
    ScadaData.DateTimeBegin                	= [];
    
    ScadaData.EndDate                       = [];
    ScadaData.EndTime                       = [];
    ScadaData.DateTimeEnd                	= [];
    
    ScadaData10Minute                       = ScadaData;
    ScadaData10Minute(2 : end, :)           = [];
    ScadaData10Minute(numel(BinEdges) + 2, :)	= ScadaData(1, :);
    ScadaData10Minute(1, :)                 = [];
    ScadaData10Minute(end, :)               = [];
    
    for i = 1 : numel(BinEdges)
        
        RowIndices = find(i == BinIndicesBegin | i == BinIndicesEnd);
              
        if ~isempty(RowIndices)
            
            LastEntry = ScadaData(RowIndices(end), :);   
            
            if numel(RowIndices) == 1
                ScadaData10Minute(i, :) = ScadaData(RowIndices, :);
            end
            
        else
            ScadaData10Minute(i, :) = LastEntry;
        end
        
        if (mod(i, 1000) == 0)
            disp(i)
        end
        
    end
    
    ScadaData10Minute.Date = datestr(BinEdges, 'yyyy-mm-dd');
    ScadaData10Minute.Time = datestr(BinEdges, 'HH:MM:ss');
    ScadaData10Minute = [ScadaData10Minute(:, end - 1 : end) ScadaData10Minute(:, 1 : end - 2)];
    
end