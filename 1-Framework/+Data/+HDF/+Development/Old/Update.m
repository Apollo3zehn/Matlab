function Update(filePath)

    [~, fileName, ~]    = fileparts(filePath);
    dateTime           	= datenum(fileName(25 : end), 'yyyy-mm-ddThh-MM-ssZ');
    
    fileId = H5F.open(filePath,'H5F_ACC_RDWR','H5P_DEFAULT');
%     Data.HDF.Development.UpdateVariableNames(fileId, dateTime)
%     Data.HDF.Development.CorrectIsChunkCompletedAttribute(filePath, fileId)
%     Data.HDF.Development.CorrectNameSetSize(filePath, fileId)
%     Data.HDF.Development.CorrectLastCompletedChunk(filePath, fileId)
    H5F.close(fileId);
    
end