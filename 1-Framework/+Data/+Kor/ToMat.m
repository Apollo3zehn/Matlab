function ToMat(FileInfo)

    FileID          	= fopen(FileInfo.Path, 'r');

    while true
        tmp             = fgets(FileID);
        if ~strcmp(tmp(1), '#')
            fseek(FileID, -numel(tmp), 'cof');
            break
        end
        Header      = tmp;
    end
        
    Header              = strsplit(Header, ' ');
    Placeholder         = repmat(' %f', 1, length(Header) - 2);
%     FormatSpec          = ['%4f-%2f-%2f %2f:%2f:%2f.%3f' Placeholder];
    FormatSpec          = ['%4f-%2f-%2f %2f:%2f:%2f' Placeholder];

    Dataset            	= textscan(FileID, FormatSpec, 'HeaderLines', 0, 'Delimiter', ' ', 'ReturnOnError', true);
    DateTime            = datenum(Dataset{:, 1}, Dataset{:, 2}, Dataset{:, 3}, Dataset{:, 4}, Dataset{:, 5}, Dataset{:, 6});
    Dataset            	= array2table(cell2mat(Dataset));
%     Dataset.Properties.VariableNames = [{'Year' 'Month' 'Day' 'Hours' 'Minutes' 'Seconds' 'Milliseconds'} Header(:, 3 : end)];
    Dataset.Properties.VariableNames = [{'Year' 'Month' 'Day' 'Hours' 'Minutes' 'Seconds'} Header(:, 3 : end)];
    Dataset.DateTime    = DateTime;

    save(FileInfo.OutputPath, 'Dataset', '-v7.3')

    fclose(FileID);

end

