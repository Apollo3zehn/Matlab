function WriteWnd(FilePath, Data)

    %% Open file

    Directory.CreateByFilePath(FilePath)

    FileId = fopen([FilePath '.wnd'], 'w');
    
    %% Write file
    
    % Header
    fwrite(FileId, Data.Format, 'int16');
    fwrite(FileId, Data.ID, 'int16');

    switch Data.ID
            
        case 4 % Improved von Karman
            fwrite(FileId, Data.ComponentCount, 'int32');
            fwrite(FileId, Data.Latitude, 'float32');
            fwrite(FileId, Data.RoughnessLength, 'float32');
            fwrite(FileId, Data.HubHeight, 'float32');
            fwrite(FileId, Data.TurbulenceIntensity_u, 'float32');
            fwrite(FileId, Data.TurbulenceIntensity_v, 'float32');
            fwrite(FileId, Data.TurbulenceIntensity_w, 'float32');
            
        case {7, 8} % {Kaimal, Mann}
            fwrite(FileId, Data.HeaderSize, 'int32');
            fwrite(FileId, Data.ComponentCount, 'int32');
            
        otherwise      
            error('Model not implemented.')
            
    end

    fwrite(FileId, Data.dz, 'float32');
    fwrite(FileId, Data.dy, 'float32');
    fwrite(FileId, Data.dx, 'float32');
    fwrite(FileId, Data.FftLength / 2, 'int32');
    fwrite(FileId, Data.MeanWindSpeed, 'float32');
    fwrite(FileId, Data.zLengthScale_u, 'float32');
    fwrite(FileId, Data.yLengthScale_u, 'float32');
    fwrite(FileId, Data.xLengthScale_u, 'float32');
    fwrite(FileId, Data.Unused, 'int32');
    fwrite(FileId, Data.Seed, 'int32');
    fwrite(FileId, Data.Nz, 'int32');
    fwrite(FileId, Data.Ny, 'int32');
    fwrite(FileId, Data.zLengthScale_v, 'float32');
    fwrite(FileId, Data.yLengthScale_v, 'float32');
    fwrite(FileId, Data.xLengthScale_v, 'float32');
    fwrite(FileId, Data.zLengthScale_w, 'float32');
    fwrite(FileId, Data.yLengthScale_w, 'float32');
    fwrite(FileId, Data.xLengthScale_w, 'float32');
    
    switch Data.ID
        
        case 7 % Kaimal
            fwrite(FileId, Data.CoherenceDecay, 'float32');
            fwrite(FileId, Data.CoherenceLengthScale, 'float32');
            
        case 8 % Mann
            fwrite(FileId, Data.Gamma, 'float32');
            fwrite(FileId, Data.ScaleParameter, 'float32');
            fwrite(FileId, Data.LateralTurbulenceIntensityRatio, 'float32');
            fwrite(FileId, Data.VerticalTurbulenceIntensityRatio, 'float32');
            fwrite(FileId, Data.MaximumLateralWaveLength, 'float32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.LateralVerticalFftLength, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            fwrite(FileId, Data.Unused, 'int32');
            
    end

    % Time Series
    BinaryData = permute(Data.WindField, [4 1 2 3]) * 1000;
    fwrite(FileId, BinaryData(:), 'int16');
        
    %% Close file
    fclose(FileId);
    Display.Text(['Saved file ''' FilePath '.wnd''.'])
    
end