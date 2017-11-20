clc
clear
close all

Fino1Data = [];

try

    FileInfoList                = FileInformation.GetFileInformations([Rave.RawDataPath '\WindDirection_WindSpeed_WindSpeedCorrected'], 'csv', true);
    FileCount                   = length(FileInfoList);

    StopWatch.Start

    for FileNumber = 1 : FileCount

        FileInfo                = FileInfoList(FileNumber);
        Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
        Fino1Data               = [Fino1Data; Data.Rave.ImportRaveFile(FileInfo.Path)];

    end

    Fino1Data           = sortrows(Fino1Data, 1);

    DateTimeBegin       = Fino1Data(1, 1);
    DateTimeEnd         = Fino1Data(end, 1);   
    FileInfo.OutputPath = FileInformation.BuildOutputFilePathByDateTime(Environment.PreparedPath, ...
                                                                        'Rave', ...
                                                                        'WindDirection_WindSpeed_WindSpeedCorrected', ...
                                                                        DateTimeBegin, DateTimeEnd);
    
    [DirectoryPath, ~, ~] = fileparts(FileInfo.OutputPath);

    if ~isdir(DirectoryPath)
        mkdir(DirectoryPath)
    end

    save([FileInfo.OutputPath '.mat'], 'Fino1Data', '-mat');
    Display.Text(['Saved file ''' FileInfo.OutputPath '.mat''.'])

catch ex

    fclose('all');
    delete(FileInfo.OutputPath)
    warning(ex.message)

end