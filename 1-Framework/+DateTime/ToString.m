function [DateTime] = ToString(DateTime, OutputFormat)

DateTime = datestr(DateTime, OutputFormat);

end