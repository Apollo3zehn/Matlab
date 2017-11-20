function [] = Automation()

    clc
    clear

    DateTimeBegin       	= datenum(2017, 01, 01, 0, 0, 0);
    DateTimeEnd             = datenum(2018, 01, 01, 0, 0, 0);
    
    ShutdownAfterCalculation= false;

    FileInformationList     = Data.Delphin.Helper.GetFileInformationList(Lehe03_MetMast.HighResolution_MetMast.RawDataPath, DateTimeBegin, DateTimeEnd, 'yyyy-mm-ddThh-MM', 'mat');
    FileCount               = length(FileInformationList);

    OverwriteExistingFiles  = false;
    
    %%
    
    Display.Headline('HighResolution_MetMast.ToMat')

    StopWatch.Start

    for FileNumber = 1 : FileCount

        FileInfo            = FileInformationList(FileNumber);
        Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);    
        FileInfo.OutputPath = [Lehe03_MetMast.HighResolution_MetMast.DataDirectory '\' FileInfo.Name '.mat'];
        
        if OverwriteExistingFiles
            Data.Delphin.ToMat(FileInfo);
        elseif ~exist(FileInfo.OutputPath, 'file')
            Data.Delphin.ToMat(FileInfo);
        end        
        
    end

    Display.Finished

    if ShutdownAfterCalculation == 1
        !shutdown -s -f
    end

end