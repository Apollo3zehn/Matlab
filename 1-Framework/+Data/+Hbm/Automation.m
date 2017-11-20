function [] = Automation()

clc
clear

ShutdownAfterCalculation    = false;

FileInfoList                = FileInformation.GetFileInformations(AV07.Hbm.RawDataPath, 'csv', false);
FileCount                   = length(FileInfoList);

Display.Headline('Hbm.ToMat')

StopWatch.Start

for FileNumber = 1 : FileCount
       
    FileInfo            = FileInfoList(FileNumber);
    
    Display.ProgressStatus('file', FileNumber, FileCount, StopWatch.ElapsedTime, 0);
    
    FileInfo.OutputPath = [AV07.Hbm.DataDirectory '\' FileInfo.Name '.mat'];
    	
    Data.Hbm.ToMat(FileInfo);
    
end

Display.Finished

if ShutdownAfterCalculation == 1
	!shutdown -s -f
end

end