function [] = Automation()

    clc
    clear

    ShutdownAfterCalculation    = false;

    FileInfoList                = FileInformation.GetFileInformations([Lehe03_MetMast.HighResolution_MetMast.RawDataPath '/03'], 'mat', true);
    FileCount                   = length(FileInfoList);

    Display.Headline('HighResolution.ToMat')

    StopWatch.Start

    for FileNumber = 1 : FileCount

        FileInfo            = FileInfoList(FileNumber);

        Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);

        FileInfo.OutputPath = [Lehe03_MetMast.HighResolution_MetMast.DataDirectory '\' FileInfo.Name '.mat'];

        Data.Delphin.ToMat(FileInfo);

    end

    Display.Finished

    if ShutdownAfterCalculation == 1
        !shutdown -s -f
    end

end