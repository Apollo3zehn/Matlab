function [] = Automation()

clc
clear

FileInfoList                = FileInformation.GetFileInformations('C:\Users\vwilms\Desktop\Neuer Ordner', 'csv', true);
FileCount                   = length(FileInfoList);

Display.Headline('Scada.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = ['C:\Users\vwilms\Desktop\' FileInfo.Name];
    Data.Scada.OperationalStatusProtocol.ToMat(FileInfo);
    
end

Display.Finished

end