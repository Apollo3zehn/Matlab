function [] = ToMat(FileInfo)

    try

        SensorCount = 5;
        
        Convert.FileCommaToDots(FileInfo.Path);
   
        FileID	= fopen(FileInfo.Path, 'r');

        FormatSpec  = repmat('%s', [1 SensorCount + 1]);
        Headlines   = textscan(FileID, FormatSpec, 1, 'Delimiter', ';', 'HeaderLines', 4, 'ReturnOnError', false, 'MultipleDelimsAsOne', true);
        Headlines   = cellfun(@(x) char(x), Headlines, 'UniformOutput', false); 
        Headlines   = Convert.ToProperFieldName(Headlines);

        Format      = repmat(' %f', [1 SensorCount]);
        FormatSpec  = ['%2f.%2f.%4f %2f:%2f:%2f:%1f' Format];
        ScadaData  	= textscan(FileID, FormatSpec, 'Delimiter', ';', 'HeaderLines', 2, 'ReturnOnError', false);
        ScadaData 	= [datenum(ScadaData{:, 3}, ScadaData{:, 2}, ScadaData{:, 1}, ScadaData{:, 4}, ScadaData{:, 5}, ScadaData{:, 6} + ScadaData{:, 7} / 1000) ...
                       ScadaData(:, 8 : end)];

        fclose(FileID);

        ScadaData 	= cell2struct(ScadaData, ['DateTimes' Headlines(:, 2 : end)], 2);
        
        Directory.CreateByFilePath(FileInfo.OutputPath)

        save([FileInfo.OutputPath '.mat'], 'ScadaData', '-mat');
        Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

    catch ex

        fclose('all');
        warning(ex.message)
        delete(FileInfo.OutputPath)

    end

end