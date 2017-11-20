function CorrectLastCompletedChunk(filePath, fileId)

    try
        attributeData = h5readatt(filePath, '/', 'last_completed_chunk');
        h5writeatt(filePath, '/LEHE/LEHE03/GENERAL_DAQ', 'last_completed_chunk', uint64(attributeData))       
        H5A.delete(fileId, 'last_completed_chunk')
    catch
    end    
    
end

