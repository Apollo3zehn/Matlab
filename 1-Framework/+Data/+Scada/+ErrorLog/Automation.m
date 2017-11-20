function [] = Automation()

clc
clear

FileInfoList                = FileInformation.GetFileInformations('M:\Data Analysis\Testumgebung_VWI\Aufgaben\41-IPC an Björn', 'csv', true);
FileCount                   = length(FileInfoList);

Display.Headline('Scada.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = [AV07.Scada.DataDirectory '\' FileInfo.Name];
    
    Data.Scada.ErrorLog.ToMat(FileInfo);
    
end

Display.Finished

end