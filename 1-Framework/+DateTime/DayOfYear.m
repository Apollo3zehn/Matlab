function DayOfYear = DayOfYear(Date)
    Date = Date(:);
    Datevec = datevec(Date); 
    DayOfYear = floor(Date - datenum(Datevec(:, 1), 1, 1)) + 1;
end
