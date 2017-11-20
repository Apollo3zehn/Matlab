function [Time] = ToTime(DateTime)
    DateElements    = arrayfun(@(x) datevec(x), DateTime, 'UniformOutput', false);
    Time            = cellfun(@(x) datenum(0, 0, 0, x(4), x(5), x(6)), DateElements);
end