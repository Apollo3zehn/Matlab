% Data files with constant range gates are required.

function [GalionExtension] = ByDateTime(DirectoryPath, DateTimeBegin, DateTimeEnd, MaximumRangeGate)

    Display.TextWithoutBreaks('Creating file list ... ')
    FileInformationList = Data.Galion.Helper.GetFileInformationList(DirectoryPath, DateTimeBegin, DateTimeEnd, 'yyyy-mm-dd', 'ddmmyyhh', 'mat');
    Display.Done
    
    FileInformationCount = length(FileInformationList);
          
    % Preallocate the resulting matrix
    CummulatedGalionData = NaN(1, 8);
    
    %%
    
    LastRow         = 0;
    MessageLength   = 0;
    StopWatch.Start
    
    for FileInfoNumber = 1 : FileInformationCount 
        
        MessageLength       = Display.ProgressStatus('file', FileInfoNumber, FileInformationCount, StopWatch.ElapsedTime, MessageLength);

        load(FileInformationList(FileInfoNumber).Path);
               
        GalionData          = Data.Galion.Helper.CutDataAfterChangeOfDay(GalionData);
        
        RowCount            = size(GalionData, 1);
        MaxRowCount         = size(CummulatedGalionData, 1);
        
        if LastRow + RowCount > MaxRowCount
            CummulatedGalionData(LastRow + RowCount + 1 : MaxRowCount * 2, :) = NaN; 
        end
        
        CummulatedGalionData(LastRow + 1 : LastRow + RowCount, :) = GalionData;

        LastRow             = LastRow + RowCount;
        
    end
      
    if MaximumRangeGate < Inf
        CummulatedGalionData= CummulatedGalionData(CummulatedGalionData(:, 1) <= MaximumRangeGate, :);
    end
    
    CummulatedGalionData    = Matrix.Data.ByDateTime(CummulatedGalionData, 4, DateTimeBegin, DateTimeEnd);
    
    GalionExtension         = Galion.Extension(CummulatedGalionData);
    
end