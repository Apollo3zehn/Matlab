function UpdateVariableNames(fileId, dateTime)  
   
    groupPathSet                    = Data.HDF.Helper.GetGroupPathSet(fileId, 4);

    for i = 1 : numel(groupPathSet)

        % open objects
        groupId                         = H5G.open(fileId, groupPathSet{i, :});
        typeId                          = H5T.open(fileId, '/string_t');
        
        try
            attributeId                     = H5A.open(groupId, 'name_set');
            displayNameSet                  = H5A.read(attributeId);
            disp(displayNameSet)
            tmp                             = Data.HDF.Development.CorrectVariablePrefix(displayNameSet{end, :});
            tmp                             = Data.HDF.Development.CorrectVariableName(tmp, dateTime);
            displayNameSet{end, :}          = tmp;
            H5A.close(attributeId)
            H5A.delete(groupId, 'name_set')     
        catch
        end
        
        if ~exist('displayNameSet', 'var')
            displayNameSet = {'Test1', 'Test2'};
        end
        
        h5DataspaceId                   = H5S.create_simple(1, numel(displayNameSet), 10);
        attributeId                     = H5A.create(groupId, 'name_set', typeId, h5DataspaceId, 0);
        H5A.write(attributeId, typeId, displayNameSet);       
                
        % close objects
        H5S.close(h5DataspaceId)
        H5T.close(typeId);
        H5A.close(attributeId);
        H5G.close(groupId);

    end
    
end