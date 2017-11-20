% test: Data.HDF.Legacy.ToMat('M:\DATABASE\DB_NATIVE\2017-09\LEHE_LEHE03_GENERAL_DAQ_V26_2017-09-29T00-00-00Z.h5', 'C:\Users\vwilms\Desktop\Alex')

function ToMat(filePath, baseOutputDirectoryPath)

    totalLength                     = 8640000;
    length                          = totalLength / 144;
    fileId                          = H5F.open(filePath);
    [~, fileName, ~]                = fileparts(filePath);
    groupPathSet                    = Data.HDF.Helper.GetGroupPathSet(fileId, 4);
    dateTime                        = datenum(fileName(29 : end), 'yyyy-mm-ddThh-MM-ssZ');
    
    for i = 0 : 143
       
        startIndex                      = i * length + 1;
        currentDateTime                 = dateTime + startIndex / totalLength;
        
        for j = 1 : numel(groupPathSet)
                   
            % open objects
            groupId                         = H5G.open(fileId, groupPathSet{j, :});
%             datasetId                       = H5D.open(groupId, '100 Hz');
%             datasetId_status                = H5D.open(groupId, '100 Hz_status');
            attributeId                     = H5A.open(groupId, 'name_set');
%             spaceId                         = H5D.get_space(datasetId);
            
            % read attribute
            displayNameSet                  = H5A.read(attributeId);
                      
            % create hyperslab
%             H5S.select_hyperslab(spaceId, 'H5S_SELECT_SET', startIndex, 1, length, 1);
            
            % read data and create mat structure
            channelName                     = sprintf('CH%03.0f', j);
            channelData                     = h5read(filePath, [groupPathSet{j, :} '/100 Hz'], startIndex, length);
            channelData_status              = logical(h5read(filePath, [groupPathSet{j, :} '/100 Hz_status'], startIndex, length));
            channelData(~channelData_status)= NaN;
            
            tmp = Data.HDF.Development.CorrectVariablePrefix(displayNameSet{end, :});
            tmp = Data.HDF.Development.CorrectVariableName(tmp, dateTime);
            data.(channelName).real_name    = tmp;
            data.(channelName).values       = double(channelData);
            data.(channelName).unit         = '';
                                 
            data.info.channel_real_names.(channelName) = data.(channelName).real_name;
            data.info.starttime             = datestr(currentDateTime, 'yyyy-mm-ddThh:MM:ss');
            
            % close objects
%             H5S.close(spaceId);
            H5A.close(attributeId);
%             H5D.close(datasetId_status);
%             H5D.close(datasetId);
            H5G.close(groupId);
            
        end
           
        outputFilePath = [baseOutputDirectoryPath datestr(dateTime, '\\yyyy\\mm') '\mat\Dataset_' datestr(currentDateTime, 'yyyy-mm-ddThh-MM') '.mat'];
        Directory.CreateByFilePath(outputFilePath)           
        save(outputFilePath, 'data')
        
    end

    H5F.close(fileId);
    
end

