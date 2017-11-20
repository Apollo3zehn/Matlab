function MergeSassnitzCampaigns(filePath)

    fileId                          = H5F.open(filePath, 'H5F_ACC_RDWR', 'H5P_DEFAULT');    
    finishup                        = onCleanup(@() H5F.close(fileId));
    
    groupPathSet                    = Data.HDF.Helper.GetGroupPathSet(fileId, 4);
    groupPathSet_splitted           = cell(0, 5);
    variableNameSet                 = cell(0, 1);
    
    for i = 1 : numel(groupPathSet)
        groupPathSet_splitted(i, :) = strsplit(groupPathSet{i, 1}, '/');
    end
    
    for i = 1 : size(groupPathSet_splitted, 1)
        variableNameSet(i, :)       = h5readatt(filePath, ['/' groupPathSet_splitted{i, 2} '/' groupPathSet_splitted{i, 3} '/' groupPathSet_splitted{i, 4} '/' groupPathSet_splitted{i, 5}], 'name_set');
    end
    
    variableNameSet_unique          = unique(variableNameSet);
    
    for j = 1 : numel(variableNameSet_unique)
         
        indices                         = strcmp(variableNameSet, variableNameSet_unique{j, :});
        data                            = int16(zeros(86400 * 25, 1));
        status                          = uint8(zeros(86400 * 25, 1));
        
        for groupPath = groupPathSet(indices, :).'
            data                            = data + h5read(filePath, [char(strrep(groupPath, '\n', '')) '/25 Hz']);
            status                        	= status + h5read(filePath, [char(strrep(groupPath, '\n', '')) '/25 Hz_status']);
        end
              
        targetGroupPath                     = groupPathSet{find(indices, 1, 'first'), :};
        
        h5write(filePath, [char(strrep(targetGroupPath, '\n', '')) '/25 Hz'], data)
        h5write(filePath, [char(strrep(targetGroupPath, '\n', '')) '/25 Hz_status'], status)
               
    end
  
    indices                             = zeros(numel(groupPathSet), 1);
    
    for k = 1 : numel(groupPathSet)
        groupPath       = groupPathSet{k, :};
        indices(k, 1)   = strcmp(groupPath(:, 1 : 22), '/WIKINGER/WIK34/Test2/');
    end
    
    groupPathSet_splitted_filtered      = groupPathSet_splitted(~indices, :);

    for k = 1 : numel(variableNameSet_unique) : size(groupPathSet_splitted_filtered, 1)
        groupPath = ['/' groupPathSet_splitted_filtered{k, 2} '/' groupPathSet_splitted_filtered{k, 3} '/' groupPathSet_splitted_filtered{k, 4}];
        H5L.delete(fileId, char(groupPath), 0)
    end
        
end