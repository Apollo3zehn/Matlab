% GuessedChannels is optional to increase speed significantly

function Channels = SensorToChannel(FileName, Sensors, GuessedChannels)
    
    %% Try to use the fast h5read to prove the guess

    if ~isempty(GuessedChannels)

        for GuessedChannelNumber = 1 : numel(GuessedChannels)
            
            try
                
                if ~strcmp( ...
                            char(h5read(FileName, ['/info/channel_real_names/' GuessedChannels{GuessedChannelNumber, 1}])), ...
                            Sensors(GuessedChannelNumber) ...
                          )
                    break
                end
                
            catch
                break
            end

            if GuessedChannelNumber == numel(GuessedChannels)
                Channels = GuessedChannels;
                return
            end
        
        end
        
    end

    %% If the guess is wrong perform a full investigation to determine the channel names
    
    load(FileName, 'info')

    if ~exist('info', 'var') % fallback to not converted .mat files
        load(FileName)
        info = data.info;
    end
            
    ChannelNames	= fieldnames(info.channel_real_names);
    SensorNames     = struct2cell(info.channel_real_names);

    Channels        = cell(0, 1);

    for SensorNumber = 1 : numel(Sensors)

        SensorName = Sensors{SensorNumber};

        try
            Channels{SensorNumber, 1} = ChannelNames{strcmp(SensorName, SensorNames)}; 
        catch ex
            Channels{SensorNumber, 1} = 'Undefined';
        end

    end
                  
end

