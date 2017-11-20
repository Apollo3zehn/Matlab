function Data = ReadWnd(FilePath)

    %% Open file
   
    if exist(FilePath, 'file')
        FileId = fopen(FilePath, 'r');
    else
        error('The specified file does not exist.')
    end
    
    %% Read file
    
    % Header
    Data.Format                         = fread(FileId, 1, 'int16');
    
    if Data.Format ~= -99
        error('The file is not a valid .wnd file.')
    end
    
    Data.ID                             = fread(FileId, 1, 'int16');

    switch Data.ID
        
        case 4 % Improved von Karman
            Data.ComponentCount         = fread(FileId, 1, 'int32');
            Data.Latitude               = fread(FileId, 1, 'float32');
            Data.RoughnessLength        = fread(FileId, 1, 'float32');
            Data.HubHeight              = fread(FileId, 1, 'float32');
            Data.TurbulenceIntensity_u  = fread(FileId, 1, 'float32');
            Data.TurbulenceIntensity_v  = fread(FileId, 1, 'float32');
            Data.TurbulenceIntensity_w  = fread(FileId, 1, 'float32');
            
        case {7, 8} % {Kaimal, Mann}
            Data.HeaderSize             = fread(FileId, 1, 'int32');
            Data.ComponentCount         = fread(FileId, 1, 'int32');
            
        otherwise      
            error('Model not implemented.')
            
    end

    Data.dz                             = fread(FileId, 1, 'float32');
    Data.dy                             = fread(FileId, 1, 'float32');
    Data.dx                             = fread(FileId, 1, 'float32');
    Data.FftLength                      = fread(FileId, 1, 'int32') * 2;
    Data.MeanWindSpeed                  = fread(FileId, 1, 'float32');
    Data.zLengthScale_u                 = fread(FileId, 1, 'float32');
    Data.yLengthScale_u                 = fread(FileId, 1, 'float32');
    Data.xLengthScale_u                 = fread(FileId, 1, 'float32');
                                          fread(FileId, 1, 'int32');
    Data.Seed                           = fread(FileId, 1, 'int32');
    Data.Nz                             = fread(FileId, 1, 'int32');
    Data.Ny                             = fread(FileId, 1, 'int32');
    Data.zLengthScale_v                 = fread(FileId, 1, 'float32');
    Data.yLengthScale_v                 = fread(FileId, 1, 'float32');
    Data.xLengthScale_v                 = fread(FileId, 1, 'float32');
    Data.zLengthScale_w                 = fread(FileId, 1, 'float32');
    Data.yLengthScale_w                 = fread(FileId, 1, 'float32');
    Data.xLengthScale_w                 = fread(FileId, 1, 'float32');
    
    switch Data.ID
        
        case 7 % Kaimal
            Data.CoherenceDecay         = fread(FileId, 1, 'float32');
            Data.CoherenceLengthScale   = fread(FileId, 1, 'float32');
            
        case 8 % Mann
            Data.Gamma                  = fread(FileId, 1, 'float32');
            Data.ScaleParameter         = fread(FileId, 1, 'float32');
            Data.LateralTurbulenceIntensityRatio    = fread(FileId, 1, 'float32');
            Data.VerticalTurbulenceIntensityRatio   = fread(FileId, 1, 'float32');
            Data.MaximumLateralWaveLength           = fread(FileId, 1, 'float32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
            Data.LateralVerticalFftLength=fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
                                          fread(FileId, 1, 'int32');
            
    end

    % Checks
    
	FileInfo = dir(FilePath);
    Position = ftell(FileId);
    
    if isfield(Data, 'HeaderSize')
        if Data.HeaderSize ~= Position
            error('Specified HeaderSize does not match the real HeaderSize.')
        end
    end
    
    if FileInfo.bytes - ftell(FileId) - 3 * Data.FftLength * Data.Ny * Data.Nz * 2 > 0
        error('Specified size of the wind field does not match the real size.')
    end
    
    % Time Series - Format = [y z t c]
    Data.WindField                      = permute(reshape(fread(FileId, 'int16') / 1000, [3 Data.Ny Data.Nz Data.FftLength]), [2 3 4 1]);    
        
    %% Close file
    fclose(FileId);
    
end