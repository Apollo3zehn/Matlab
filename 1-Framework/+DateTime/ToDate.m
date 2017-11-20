function DateTime = ToDate(DateTime)
    DateElements    = arrayfun(@(x) datevec(x), DateTime, 'UniformOutput', false);
    DateTime        = cellfun(@(x) datenum(x(1), x(2), x(3)), DateElements);
end