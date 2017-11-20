function [HighResolutionData] = LoadChannels(FilePath, Channels)

    try % for HDF5 files
        
        for Channel = Channels'
            
            try
                HighResolutionData.(char(Channel)) = h5read(FilePath, ['/' char(Channel) '/values']); 
            catch ex
                if Strings.EndsWith(ex.message, 'unable to open file')
                    error('File is no HD5 file.')
                else
                    HighResolutionData.(char(Channel)) = NaN;
                end
            end
            
        end
         
    catch
     
        PreparedChannels    = '';
    
        for Channel = Channels'
           PreparedChannels = [PreparedChannels ', ''' char(Channel) ''''];
        end
            
        HighResolutionData  = eval(['load(''' FilePath '''' PreparedChannels ')']);
        
        if numel(fieldnames(HighResolutionData)) == 0 % File is no HD5 file.
            HighResolutionData = load(FilePath);
            HighResolutionData = HighResolutionData.data;
        end
        
        for Channel = fieldnames(HighResolutionData)'

            if any(strcmp(Channel, Channels))

                try
                    HighResolutionData.(char(Channel)) = HighResolutionData.(char(Channel)).values;
                catch
                    HighResolutionData.(char(Channel)) = [];
                end
                
            else
                try
                    HighResolutionData = rmfield(HighResolutionData, Channel);
                catch
                end
            end

        end
            
    end
    
end

