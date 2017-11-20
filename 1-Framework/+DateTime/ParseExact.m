function [DateTime] = ParseExact(CharArray, StartPosition, InputFormat)
    DateTime = datenum(CharArray(:, StartPosition : StartPosition + length(InputFormat) - 1), InputFormat);
end