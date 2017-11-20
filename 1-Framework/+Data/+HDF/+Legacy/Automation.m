clc
clear
close all

%%

OverwriteExistingFiles = false;

%%

FileInformationList     = FileInformation.GetFileInformations('C:\Users\viwilms\Desktop\9h issue\Matlab', 'csv', true); 
FileCount               = length(FileInformationList);

Display.Headline('HDF Debug.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount

    FileInfo            = FileInformationList(FileNumber);
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    FileInfo.OutputPath = Directory.ReplaceExtension(FileInfo.Path, 'mat');
    %FileInfo.OutputPath = strrep(FileInfo.OutputPath, '1-Data', '2-DataPrepared');
    
    if OverwriteExistingFiles
        Data.HDF.ToMat(FileInfo);
    elseif ~exist(FileInfo.OutputPath, 'file')
        Data.HDF.ToMat(FileInfo);
    end
    
end

Display.Finished