function [ScadaData] = ByDateTime(FilePath, DateTimeBegin, DateTimeEnd, IsAv07)

    load(FilePath, '-mat');

    ScadaData.DateTimes = ScadaData.DateTimes + TimeSpan(0, -1, -5, 0).ToDateTime;
    ScadaData           = Structures.Data.ByDateTime(ScadaData, 'DateTimes', DateTimeBegin, DateTimeEnd);     
    
    % Correction for AV07
    if IsAv07
        
        DateTimeBegin                           = datenum(2013, 05, 11, 08, 00, 00);
        DateTimeEnd                             = now;
        
        Indices                                 = DateTimeBegin < ScadaData.DateTimes & ScadaData.DateTimes < DateTimeEnd;
        ScadaData.Gondelposition_in_Grad____(Indices) = ScadaData.Gondelposition_in_Grad____(Indices) + 80;
        
        Indices                                 = ScadaData.Gondelposition_in_Grad____ > 360;        
        ScadaData.Gondelposition_in_Grad____(Indices) = 360 - ScadaData.Gondelposition_in_Grad____(Indices);
        
    end

end