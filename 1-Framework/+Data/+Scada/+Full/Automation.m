% Exported file from data explorer must be opened and resaved in excel once
% to make the script working (maybe the newline character is different)

function [] = Automation()

clc
clear

ShutdownAfterCalculation    = false;

FileInfoList                = FileInformation.GetFileInformations('M:\Data Analysis\Testumgebung_VWI\1-Data\Lehe Scada', 'csv', true);
FileCount                   = length(FileInfoList);

Display.Headline('Scada.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = [FileInfo.DirectoryPath '\' FileInfo.Name];
    
    Data.Scada.Full.ToMat(FileInfo);
    
end

Display.Finished

if ShutdownAfterCalculation == 1
	!shutdown -s -f
end

end