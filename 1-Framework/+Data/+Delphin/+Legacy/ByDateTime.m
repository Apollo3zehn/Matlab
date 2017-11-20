function [ContinuousHighResolutionData] = ByDateTime(DataDirectory, FieldNames, DateTimeBegin, DateTimeEnd, TimeSpanPerMean)

    %% Get files to load

    Display.TextWithoutBreaks('Creating file list ... ')
    
    FieldNames              = ['DateTime'; FieldNames];
    FieldNames              = Convert.ToProperFieldName(FieldNames);

    FieldCount              = length(FieldNames);

    FileInformationList     = FileInformation.GetFileInformations(DataDirectory, 'mat', 1);

    for FileInfoNumber = 1 : numel(FileInformationList)

        FileInformationList(FileInfoNumber).DateTime = DateTime.ParseExact(FileInformationList(FileInfoNumber).Name, 1, 'yyyy-mm-dd_hh-MM-ss');

    end
   
    FileInformationList    = FileInformation.FilterListByDateTime(FileInformationList, DateTimeBegin, DateTimeEnd, 0);

    Display.Done
    
    %% Guess array size and preallocate the variable to increase performance significantly
    
    FileInformationCount = length(FileInformationList);
    
    load(FileInformationList(Math.Round(length(FileInformationList) / 2, 0, Math.RoundUp)).Path);
      
    % Preallocate the resulting matrix   
    for FieldNumber = 1 : FieldCount    
        ContinuousHighResolutionData.(FieldNames{FieldNumber})= NaN(HighResolutionData.RowCount * FileInformationCount, 1);
    end
    
    %% Load files
    
    LastRow       = 0;
    MessageLength = 0;

    for FileInfoNumber = 1 : FileInformationCount

        FileInfo = FileInformationList(FileInfoNumber);
        
        MessageLength = Display.ProgressStatus('file', FileInfoNumber, FileInformationCount, StopWatch.ElapsedTime, MessageLength);

        load(FileInfo.Path);
       
        FieldData   = Structures.GetFieldData(HighResolutionData, FieldNames);

        if numel(fieldnames(FieldData)) <= 1 
            continue
        end

        % Bin data

        if TimeSpanPerMean.ToDateTime == 0

            RowCount    = size(HighResolutionData.DateTime, 1);
            
            for FieldNumber = 1 : FieldCount
                FieldName                                   = FieldNames{FieldNumber};       
                ContinuousHighResolutionData.(FieldName)(LastRow + 1 : LastRow + RowCount, :) = HighResolutionData.(FieldName);
            end

        else

            Bins        = HighResolutionData.DateTime(1) : TimeSpanPerMean.ToDateTime : HighResolutionData.DateTime(end);
            BinIndices  = Statistics.SortDataIntoBins(HighResolutionData.DateTime, Bins, false, false);

            RowCount    = length(Bins);
            
            for FieldNumber = 1 : FieldCount

                FieldName               = FieldNames{FieldNumber};
                FieldData.(FieldName)   = Statistics.ProcessBinSortedData(HighResolutionData.(FieldName), BinIndices, length(Bins), @(x) mean(x, 'omitnan'));

            end  

            for FieldNumber = 1 : FieldCount
                FieldName = FieldNames{FieldNumber};       
                ContinuousHighResolutionData.(FieldName)(LastRow + 1 : LastRow + RowCount, :) = FieldData.(FieldName);
            end

        end

        LastRow = LastRow + RowCount;
        
    end

    ContinuousHighResolutionData.RowCount  = length(ContinuousHighResolutionData.DateTime);

    ContinuousHighResolutionData           = Structures.Data.ByDateTime(...
                                                            ContinuousHighResolutionData, ...
                                                            'DateTime', ...
                                                            DateTimeBegin, DateTimeEnd);

end