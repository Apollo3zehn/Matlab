function CorrectNameSetSize(filePath, fileId)

    try
        a = Data.HDF.Helper.GetGroupPathSet(fileId, 4);
        
        for VariablePath = a.'           
            try
                variablePath_splitted = strsplit(char(VariablePath), '/');
                groupId = H5G.open(fileId, ['/' variablePath_splitted{2} '/' variablePath_splitted{3} '/' variablePath_splitted{4} '/' variablePath_splitted{5}]);
                attributeId = H5A.open(groupId, 'name_set');
                spaceId = H5A.get_space(attributeId);
                [numdims,h5_dims,h5_maxdims] = H5S.get_simple_extent_dims(spaceId);
                
                data = H5A.read(attributeId);
                
                typeId = H5T.open(fileId, 'string_t');
                H5S.set_extent_simple(spaceId, 1, h5_dims, -1);
                
                H5A.close(attributeId);
                H5A.delete(groupId, 'name_set');
                
                attributeId = H5A.create(groupId, 'name_set', typeId, spaceId, 'H5P_DEFAULT');
                H5A.write(attributeId, typeId, data);
                
                H5S.close(spaceId)
                H5A.close(attributeId)
                H5G.close(groupId)                
            catch ex 
            end
        end
        
    catch ex
        
    end    
    
end

