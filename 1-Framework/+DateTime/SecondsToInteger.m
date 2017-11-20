function [DateTime] = CutSecondParts(DateTime)

DateElements    = arrayfun(@(x) datevec(x), DateTime, 'UniformOutput', false);
DateTime        = cellfun(@(x) datenum(x(1), x(2), x(3), x(4), x(5), round(x(6))), DateElements);

end