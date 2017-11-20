function [Fino1Data] = ByDateTime(FilePath, DateTimeBegin, DateTimeEnd)

    load(FilePath, '-mat');

    Fino1Data(:, 1) = Fino1Data(:, 1) + TimeSpan(0, 0, -5, 0).ToDateTime;
    Fino1Data       = Matrix.Data.ByDateTime(Fino1Data, 1, DateTimeBegin, DateTimeEnd);     
    
end