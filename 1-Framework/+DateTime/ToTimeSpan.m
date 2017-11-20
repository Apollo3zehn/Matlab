function [Result] = ToTimeSpan(DateTime)

DateTimeVector = datevec(DateTime);

Result = TimeSpan(  DateTimeVector(3), ...
                    DateTimeVector(4), ...
                    DateTimeVector(5), ...
                    DateTimeVector(6));

end