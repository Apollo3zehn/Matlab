clc
clear

FileInfoList                = FileInformation.GetFileInformations('M:\Data Analysis\Testumgebung_VWI\Aufgaben\34-Leistungsmessung BW33 an Peter\3-Traces', 'csv', true);
FileCount                   = length(FileInfoList);

Display.Headline('Scada.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = [AV07.Scada.DataDirectory '\' FileInfo.Name];
    
    Data.Scada.Trace.ToMat(FileInfo);
    
end

Display.Finished