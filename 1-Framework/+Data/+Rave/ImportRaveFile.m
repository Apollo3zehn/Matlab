function Data = ImportRaveFile(FileName)
   
    NumberOfHeadlines = 1;

    FileID	= fopen(FileName, 'r');
    FormatSpec  = ['%4f-%2f-%2f %2f:%2f:%2f.%3f' repmat(' %f', 1, 14) ' %s' repmat(' %f', 1, 14) ' %s' repmat(' %f', 1, 14) ' %s'];
    
    Data        = textscan(FileID, FormatSpec, 'HeaderLines', NumberOfHeadlines, 'Delimiter', ';', 'ReturnOnError', true);
    Data        = [datenum(Data{:, 1}, Data{:, 2}, Data{:, 3}, Data{:, 4}, Data{:, 5}, Data{:, 6}) ...
                   Data{:, 10} Data{:, 11} Data{:, 25} Data{:, 26} Data{:, 40} Data{:, 41}];
               
    fclose(FileID);
    
end

