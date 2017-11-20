function [ExtractedData] = ByDateTime(Data, DateTimeColumn, DateTimeBegin, DateTimeEnd)

ExtractedData   = Data(Data(:, DateTimeColumn) >= DateTimeBegin & ...
                       Data(:, DateTimeColumn) <= DateTimeEnd, :);
                   
% filter wrong dates
if ~isempty(ExtractedData)
   [~, MaximumIndex]    = max(ExtractedData(:, DateTimeColumn));
   ExtractedData        = ExtractedData(1 : MaximumIndex, :);
end      

end
