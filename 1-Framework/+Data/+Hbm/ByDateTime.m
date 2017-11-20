function [ContinuousHbmData] = ByDateTime(DataDirectory, FieldNames, DateTimeBegin, DateTimeEnd, TimeSpanPerMean)

% Preparation

FieldNames      = ['DateTimes'; FieldNames];
FieldNames      = Convert.ToProperFieldName(FieldNames);

FieldCount      = length(FieldNames);

Display.TextWithoutBreaks('Creating file list ... ')

FileInfoList    = FileInformation.GetFileInformations(DataDirectory, 'mat', 1);

for FileInfoNumber = 1 : numel(FileInfoList)
	
    try
        FileInfoList(FileInfoNumber).DateTime = DateTime.ParseExact(FileInfoList(FileInfoNumber).Name, 1, 'yyyy-mm-dd-hh-MM-ss');
    catch
        FileInfoList(FileInfoNumber).DateTime = DateTime.ParseExact(FileInfoList(FileInfoNumber).Name, 6, 'yyyy-mm-dd hh-MM-ss');
    end
  
end

FileInfoList            = FileInformation.FilterListByDateTime(FileInfoList, DateTimeBegin, DateTimeEnd, 0);
FileInformationCount    = numel(FileInfoList);

Display.Done

for FieldNumber = 1 : FieldCount    
    ContinuousHbmData.(FieldNames{FieldNumber})	= [];
end

StopWatch.Start
MessageLength = 0;

for FileInfoNumber = 1 : FileInformationCount
        
    MessageLength 	= Display.ProgressStatus('file', FileInfoNumber, FileInformationCount, StopWatch.ElapsedTime, MessageLength);
    
    FileInfo        = FileInfoList(FileInfoNumber);
    
    load(FileInfo.Path);
    
    if exist('P4Data', 'var')
        HbmData = P4Data;
        clear('P4Data')
    end
    
    if exist('HBMData', 'var')
        HbmData = HBMData;
        clear('HBMData')
    end
    
    FieldData	= Structures.GetFieldData(HbmData, FieldNames);
    
    if numel(fieldnames(FieldData)) <= 1 
        continue
    end
    
    % Bin data

    if TimeSpanPerMean.ToDateTime == 0

        for FieldNumber = 1 : FieldCount
            FieldName                       = FieldNames{FieldNumber};       
            ContinuousHbmData.(FieldName)	= [ContinuousHbmData.(FieldName); HbmData.(FieldName)];
        end
              
    else
        
        Bins        = HbmData.DateTimes(1) : TimeSpanPerMean.ToDateTime : HbmData.DateTimes(end);
        BinIndices  = Statistics.SortDataIntoBins(HbmData.DateTimes, Bins, false, false);

        for FieldNumber = 1 : FieldCount

            FieldName               = FieldNames{FieldNumber};
            FieldData.(FieldName)   = Statistics.ProcessBinSortedData(HbmData.(FieldName), BinIndices, length(Bins), @(x) mean(x, 'omitnan'));

        end  
        
        for FieldNumber = 1 : FieldCount
            FieldName                       = FieldNames{FieldNumber};       
            ContinuousHbmData.(FieldName)	= [ContinuousHbmData.(FieldName); FieldData.(FieldName)];
        end
        
    end
                  
end

ContinuousHbmData.RowCount  = length(ContinuousHbmData.DateTimes);

ContinuousHbmData           = Structures.Data.ByDateTime(...
                                                        ContinuousHbmData, ...
                                                        'DateTimes', ...
                                                        DateTimeBegin, DateTimeEnd);
                                    
end