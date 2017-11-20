function [] = ToMat(FileInfo)

    try
      
        Convert.FileCommaToDots(FileInfo.Path);
   
        FileID      = fopen(FileInfo.Path, 'r');

        FormatSpec  = repmat('%s', [1 7]);
        Headlines   = textscan(FileID, FormatSpec, 1, 'Delimiter', ';', 'HeaderLines', 2, 'ReturnOnError', false, 'MultipleDelimsAsOne', true);
        Headlines   = cellfun(@(x) char(x), Headlines, 'UniformOutput', false); 
        Headlines   = Convert.ToProperFieldName(Headlines);

        FormatSpec  = '%2f.%2f.%4f %2f:%2f:%2f %s %s %f %f %s';
        ScadaData  	= textscan(FileID, FormatSpec, 'Delimiter', ';', 'HeaderLines', 2, 'ReturnOnError', false);
        ScadaData 	= [datenum(ScadaData{:, 3}, ScadaData{:, 2}, ScadaData{:, 1}, ScadaData{:, 4}, ScadaData{:, 5}, ScadaData{:, 6}) ...
                       ScadaData(:, 7 : end)];
        Headlines   = {Headlines{1} Headlines{3 : end}};
                   
        fclose(FileID);

        ScadaData 	= cell2struct(ScadaData, Headlines, 2);
        
        Directory.CreateByFilePath(FileInfo.OutputPath)

        save([FileInfo.OutputPath '.mat'], 'ScadaData', '-mat');
        Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

    catch ex

        fclose('all');
        delete(FileInfo.OutputPath)
        warning(ex.message)

    end

end