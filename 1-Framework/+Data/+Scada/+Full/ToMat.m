function [] = ToMat(FileInfo)

    try

        SensorCount = 5;
        
        Convert.FileCommaToDots(FileInfo.Path);
   
        FileID	= fopen(FileInfo.Path, 'r');

        FormatSpec  = repmat('%s', [1 SensorCount]);
        Headlines   = textscan(FileID, FormatSpec, 1, 'Delimiter', ';', 'HeaderLines', 2, 'ReturnOnError', false, 'MultipleDelimsAsOne', true);
        Headlines   = cellfun(@(x) char(x), Headlines, 'UniformOutput', false); 
        Headlines   = repmat(Headlines, 4, 1);
        Headlines   = Headlines(:).';
        Headlines   = Convert.ToProperFieldName(Headlines);

        Format      = repmat(' %f', [1 SensorCount * 4]);
        FormatSpec  = ['%2f.%2f.%4f %2f:%2f:%2f' Format];
        ScadaData  	= textscan(FileID, FormatSpec, 'Delimiter', ';', 'HeaderLines', 2, 'ReturnOnError', false);
        ScadaData 	= [datenum(ScadaData{:, 3}, ScadaData{:, 2}, ScadaData{:, 1}, ScadaData{:, 4}, ScadaData{:, 5}, ScadaData{:, 6}) ...
                       ScadaData(:, 7 : end)];

        fclose(FileID);

        for i = 1 : SensorCount
            Headlines{(i - 1) * 4 + 1} = [Headlines{(i - 1) * 4 + 1} 'avg'];
            Headlines{(i - 1) * 4 + 2} = [Headlines{(i - 1) * 4 + 2} 'min'];
            Headlines{(i - 1) * 4 + 3} = [Headlines{(i - 1) * 4 + 3} 'max'];
            Headlines{(i - 1) * 4 + 4} = [Headlines{(i - 1) * 4 + 4} 'std'];
        end
        
        ScadaData 	= cell2struct(ScadaData, ['DateTimes' Headlines], 2);
        
        Directory.CreateByFilePath(FileInfo.OutputPath)

        save([FileInfo.OutputPath '.mat'], 'ScadaData', '-mat');
        Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

    catch ex

        fclose('all');
        delete(FileInfo.OutputPath)
        warning(ex.message)

    end

end