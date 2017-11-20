function [] = ToMat (FileInfo)

    % start import
    FileInfo.Data   = importdata(FileInfo.Path, ';', 1);

    % Create new variables in the base workspace from those fields.
    FieldNames = FileInfo.Data.colheaders;
    FieldCount = length(FieldNames);

    for FieldNumber = 1 : FieldCount

        FieldName = FieldNames{FieldNumber};
        FieldName = Convert.ToProperFieldName(FieldName);

        HbmData.(FieldName) = FileInfo.Data.data(:, FieldNumber);

    end

    DateTimeBegin           = DateTime.ParseExact(FileInfo.Name, 1, 'yyyy-mm-dd-hh-MM-ss');
    %DateTimeBegin           = DateTime.ParseExact(FileInfo.Name, 6, 'yyyy-mm-dd hh-MM-ss');
    DateTimeEnd             = DateTimeBegin + AV07.Hbm.FullTimeSpan.ToDateTime;

    HbmData.RowCount        = size(FileInfo.Data.data, 1);
    HbmData.DateTimes       = linspace(DateTimeBegin, DateTimeEnd, HbmData.RowCount)';

    Directory.CreateByFilePath(FileInfo.OutputPath)

    save(FileInfo.OutputPath, 'HbmData', '-mat');
    display(['Saved file ''' FileInfo.OutputPath '''.'])
    Display.NewLine

end