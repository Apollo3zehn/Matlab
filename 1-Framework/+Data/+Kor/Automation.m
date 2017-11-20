clc
clear
close all

%%

OverwriteExistingFiles = true;

%%

FileInformationList     = FileInformation.GetFileInformations('D:\RAW\LEHE\LEHE03\MET_MAST_DWG\10 min', 'kor', false); 
FileCount               = length(FileInformationList);

Display.Headline('Kor.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount

    FileInfo            = FileInformationList(FileNumber);
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    FileInfo.OutputPath = Directory.ReplaceExtension(FileInfo.Path, 'mat');
    FileInfo.OutputPath = strrep(FileInfo.OutputPath, 'RAW', 'PREPARED');
    
    if OverwriteExistingFiles
        Data.Kor.ToMat(FileInfo);
    elseif ~exist(FileInfo.OutputPath, 'file')
        Data.Kor.ToMat(FileInfo);
    end
    
end

Display.Finished