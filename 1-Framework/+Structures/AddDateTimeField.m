function [Structure] = AddDateTimeField(Structure, RowCount, StartDate, Timespan)

    Structure.DateTime  = linspace(StartDate, StartDate + Timespan.ToDateTime, RowCount)';  

end