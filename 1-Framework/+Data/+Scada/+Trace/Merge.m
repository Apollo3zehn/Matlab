clc
clear

SampleRate                  = datetime(0, 0, 0, 0, 0, 1);

FileInfoList                = FileInformation.GetFileInformations('M:\Data Analysis\Testumgebung_VWI\Aufgaben\34-Leistungsmessung BW33 an Peter\3-Traces\Matlab', 'mat', true);
FileCount                   = length(FileInfoList);

StopWatch.Start

for FileNumber = 1 : FileCount
    FileInfo            = FileInfoList(FileNumber);  
    Data                = load(FileInfo.Path);
    DataSet(FileNumber) = Data.ScadaData;
end

MergedScadaData         = DataSet(1);
FieldNames            	= fieldnames(MergedScadaData);
ReferenceDateTime       = DataSet(1).DateTimes(1);

if FileNumber > 1
    
    for FieldNumber = 1 : numel(FieldNames)

        Container 	= NaN(numel(DataSet(1).DateTimes(1) : 1/86400 : DataSet(end).DateTimes(end)), 1);
        FieldName   = char(FieldNames(FieldNumber));
        
        for FileNumber = 1 : FileCount  
        
            DateTimes = DataSet(FileNumber).DateTimes;
            StartIndex = round((DateTimes(1) - ReferenceDateTime) * 86400) + 1;
            
            Container(StartIndex : StartIndex + numel(DateTimes) - 1, 1) = DataSet(FileNumber).(FieldName);
                       
        end       
        
        MergedScadaData.(FieldName) = Container;
        
    end
    
end

OutputPath = [AV07.Scada.DataDirectory '\MergedScadaData'];
Directory.CreateByFilePath(OutputPath)

save([OutputPath '.mat'], 'MergedScadaData', '-mat');
Display.Text(['Saved file ''' OutputPath '.mat''.'])