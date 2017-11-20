% Exported file from data explorer must be opened and resaved in excel once
% to make the script working (maybe the newline character is different)

function [] = Automation()

clc
clear

ShutdownAfterCalculation    = false;

FileInfoList                = FileInformation.GetFileInformations('M:\Data Analysis\Testumgebung_VWI\Aufgaben\55-Windstatistik an Alberto', 'csv', true);
FileCount                   = length(FileInfoList);

Display.Headline('Scada.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = [AV07.Scada.DataDirectory '\' FileInfo.Name];
    
    Data.Scada.General.ToMat(FileInfo);
    
end

Display.Finished

if ShutdownAfterCalculation == 1
	!shutdown -s -f
end

end