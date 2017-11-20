function CumulatedKorData = ByDateTime(DataDirectory, ChannelSet, DateTimeBegin, DateTimeEnd)

    %% Get files to load

    Display.TextWithoutBreaks('Creating file list ... ') 
    
    FileInformationList     = FileInformation.GetFileInformations(DataDirectory, 'mat', false); 
    FileInformationCount    = numel(FileInformationList);
    
    if FileInformationCount == 0
        error('No files found.')
    end
    
    Display.Done
    
    ChannelSet              = ['DateTime'; ChannelSet];
    
    %% Load files
       
    MessageLength           = 0;
    LastRowNumber           = 0;
    LastWrittenRowNumber    = 0;
        
    StopWatch.Start
    
    for FileInformationNumber = 1 : FileInformationCount
        
        FileInfo            = FileInformationList(FileInformationNumber);
        MessageLength       = Display.ProgressStatus('file', FileInformationNumber, FileInformationCount, StopWatch.ElapsedTime, MessageLength);
        
        %% Process data
        
        load(FileInfo.Path)
        
        if ~exist('CumulatedKorData', 'var')
            Indices = ismember(fieldnames(Dataset), ChannelSet);
            Indices = Indices(1 : end - 1);
            CumulatedKorData = Dataset(:, Indices);
        end
        
        CurrentRowCount = size(Dataset, 1);
        
        % Double size if necessary
        if LastWrittenRowNumber + CurrentRowCount > LastRowNumber
        
            NewRowCount = LastWrittenRowNumber * 2;
            
            if NewRowCount - LastRowNumber < CurrentRowCount
                NewRowCount = LastRowNumber + CurrentRowCount;
            end
            
            CumulatedKorData{LastWrittenRowNumber + 1 : NewRowCount, :} = NaN; 
        
            LastRowNumber = NewRowCount;
            
        end
        
        % Append new data
        CumulatedKorData(LastWrittenRowNumber + 1 : LastWrittenRowNumber + CurrentRowCount, :) = Dataset(:, Indices);
        
        LastWrittenRowNumber = LastWrittenRowNumber + CurrentRowCount;
                        
    end

    Indices                     = DateTimeBegin <= CumulatedKorData.DateTime & CumulatedKorData.DateTime <= DateTimeEnd;
    CumulatedKorData            = CumulatedKorData(Indices, :);

end