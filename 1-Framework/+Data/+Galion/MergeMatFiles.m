clc
clear
close all

DateTimeBegin           = datenum(2016, 12, 12, 23, 45, 0);
DateTimeEnd             = datenum(2013, 12, 14,  0,  0, 0);

Display.TextWithoutBreaks('Creating file list ... ')
FileInformationList     = Data.Galion.Helper.GetFileInformationList(Galion.PreparedScanModePath, DateTimeBegin, DateTimeEnd, 'yyyy-mm-dd', 'ddmmyyhh', 'mat');
Display.Done

FileInformationCount  	= length(FileInformationList);

StopWatch.Start

LastRowNumber           = 0;
LastWrittenRowNumber    = 0;

for FileInformationNumber = 1 : FileInformationCount

    % Fetch data

    FileInformation     = FileInformationList(FileInformationNumber);
    Data                = load(FileInformation.Path);
    CurrentRowCount  	= size(Data.GalionData, 1);

    % Double size if necessary

    if LastWrittenRowNumber + CurrentRowCount > LastRowNumber

        NewRowCount = LastWrittenRowNumber * 2;

        if NewRowCount - LastRowNumber < CurrentRowCount
            NewRowCount = LastRowNumber + CurrentRowCount;
        end

        MergedData(LastWrittenRowNumber + 1 : NewRowCount, 8) = NaN;

        LastRowNumber = NewRowCount;

    end

    MergedData(LastWrittenRowNumber + 1 : LastWrittenRowNumber + CurrentRowCount, :) = Data.GalionData;
    LastWrittenRowNumber = LastWrittenRowNumber + CurrentRowCount;

    Display.ProgressStatus('file', FileInformationNumber, FileInformationCount, StopWatch.ElapsedTime, 0);

end

MergedData = MergedData(DateTimeBegin <= MergedData(:, 4) & MergedData(:, 4) <= DateTimeEnd, :);

%% Save

OutputPath = FileInformation.BuildOutputFilePathByDateTime(Environment.PreparedPath, ['AV07 G' Galion.Number], 'Temporary', DateTimeBegin, DateTimeEnd);

[DirectoryPath, ~, ~] = fileparts(OutputPath);

if ~isdir(DirectoryPath)
    mkdir(DirectoryPath)
end

save(OutputPath, 'MergedData', '-v7.3')