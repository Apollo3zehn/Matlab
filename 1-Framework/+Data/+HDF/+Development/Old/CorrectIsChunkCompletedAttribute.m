function CorrectIsChunkCompletedAttribute(filePath, fileId)

    try
        source = '/LEHE/LEHE03/GENERAL_DAQ';
%         source = '/WIKINGER/WK34/AIR_CONDITIONING';
        attributeData = h5readatt(filePath, source, 'is_chunk_completed_set');       
        locationId = H5G.open(fileId, source);       
        datasetName = 'is_chunk_completed_set';
        
        propertyId = H5P.create('H5P_DATASET_CREATE');
        H5P.set_shuffle(propertyId);
        H5P.set_deflate(propertyId, 7);
        H5P.set_chunk(propertyId, 1440);
        
        dataspaceId = H5S.create_simple(1, 1440, 1440);
        datasetId = H5D.create(locationId, datasetName, 'H5T_NATIVE_B8', dataspaceId, 0, propertyId, 0);
        
        H5D.write(datasetId, 'H5T_NATIVE_B8', 'H5S_ALL', 'H5S_ALL', 0, attributeData);
        H5A.delete(locationId, 'is_chunk_completed_set')
        
    catch ex
        
    end    
    
end


