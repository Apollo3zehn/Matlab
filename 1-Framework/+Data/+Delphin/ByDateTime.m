function CumulatedHighResolutionData = ByDateTime(DataDirectory, Sensors, DateTimeBegin, DateTimeEnd, TimeSpanPerMean)

    %% Get files to load

    Display.TextWithoutBreaks('Creating file list ... ') 
    
    Sensors                 = ['DateTime'; Sensors];
    ConvertedSensors        = Convert.ToProperFieldName(Sensors);
    SensorCount             = length(Sensors);

    FileInformationList     = Data.Delphin.Helper.GetFileInformationList(DataDirectory, DateTimeBegin, DateTimeEnd, 'yyyy-mm-ddThh-MM', 'mat');
    FileInformationCount    = numel(FileInformationList);
    
    if FileInformationCount == 0
        error('No files found.')
    end
    
    Display.Done
    
    %% Load files
       
    MessageLength           = 0;
    
    LastRowNumber           = 0;
    LastWrittenRowNumber    = 0;
    LastAveragedRowNumber   = 0;
    
    StopWatch.Start
    
    for FileInformationNumber = 1 : FileInformationCount
        
        FileInfo            = FileInformationList(FileInformationNumber);
        MessageLength       = Display.ProgressStatus('file', FileInformationNumber, FileInformationCount, StopWatch.ElapsedTime, MessageLength);
        
        %% Fetch data
        
        if ~exist('Channels', 'var')
            Channels      	= ['DateTime'; Data.Delphin.Helper.SensorToChannel(FileInfo.Path, Sensors(2 : end, 1), [])];
        else
            Channels     	= ['DateTime'; Data.Delphin.Helper.SensorToChannel(FileInfo.Path, Sensors(2 : end, 1), Channels(2 : end, 1))];
        end
        
        HighResolutionData  = Data.Delphin.Helper.LoadChannels(FileInfo.Path, Channels);
        
        HighResolutionData.DateTime = linspace(FileInfo.DateTime, ...
                                               FileInfo.DateTime + Lehe03_MetMast.HighResolution_MetMast.FullTimeSpan.ToDateTime - TimeSpan(0, 0, 0, Lehe03_MetMast.HighResolution_MetMast.SamplingTime).ToDateTime, ...
                                               size(HighResolutionData.(Channels{end, :}), 1))';
                                                                                                                 
        %HighResolutionData.DateTime     = datenum(HighResolutionData.info.record_times, 'yyyy-mm-ddThh:MM:ss.fff');
                
        %% Process data
        
        CurrentRowCount = numel(HighResolutionData.DateTime);
        
        % Double size if necessary
        if LastWrittenRowNumber + CurrentRowCount > LastRowNumber
        
            NewRowCount = LastWrittenRowNumber * 2;
            
            if NewRowCount - LastRowNumber < CurrentRowCount
                NewRowCount = LastRowNumber + CurrentRowCount;
            end
            
            for SensorNumber = 1 : SensorCount
                CumulatedHighResolutionData.(ConvertedSensors{SensorNumber})(LastWrittenRowNumber + 1 : NewRowCount, :) = NaN; 
            end
        
            LastRowNumber = NewRowCount;
            
        end
        
        % Append new data
        for SensorNumber = 1 : SensorCount
            CumulatedHighResolutionData.(ConvertedSensors{SensorNumber})(LastWrittenRowNumber + 1 : LastWrittenRowNumber + CurrentRowCount, :) = HighResolutionData.(Channels{SensorNumber});
        end
        
        LastWrittenRowNumber = LastWrittenRowNumber + CurrentRowCount;
                
        % Bin data
        if TimeSpanPerMean.ToDateTime > 0 && (mod(FileInformationNumber, 100) == 0 || FileInformationNumber == FileInformationCount)
           
            Bins        = CumulatedHighResolutionData.DateTime(LastAveragedRowNumber + 1, 1) : TimeSpanPerMean.ToDateTime : CumulatedHighResolutionData.DateTime(LastWrittenRowNumber, 1);
            
            BinIndices  = Statistics.SortDataIntoBins(CumulatedHighResolutionData.DateTime(LastAveragedRowNumber + 1 : LastWrittenRowNumber, 1), Bins, false, false);
            BinCount    = numel(Bins);       
            
            for Sensor = ConvertedSensors'
                
                TemporaryData = Statistics.ProcessBinSortedData(CumulatedHighResolutionData.(char(Sensor))(LastAveragedRowNumber + 1 : LastWrittenRowNumber, 1), BinIndices, length(Bins), @(x) mean(x, 'omitnan'));

                CumulatedHighResolutionData.(char(Sensor))(LastAveragedRowNumber + 1              : LastAveragedRowNumber + BinCount, 1) = TemporaryData;
                CumulatedHighResolutionData.(char(Sensor))(LastAveragedRowNumber + BinCount + 1   : LastRowNumber, 1) = NaN;
                
            end
            
            LastAveragedRowNumber   = LastAveragedRowNumber + BinCount;
            LastWrittenRowNumber    = LastAveragedRowNumber;
            
        end
        
    end

    CumulatedHighResolutionData.RowCount    = length(CumulatedHighResolutionData.DateTime);
    CumulatedHighResolutionData             = Structures.Data.ByDateTime(...
                                                            CumulatedHighResolutionData, ...
                                                            'DateTime', ...
                                                            DateTimeBegin, DateTimeEnd);

end