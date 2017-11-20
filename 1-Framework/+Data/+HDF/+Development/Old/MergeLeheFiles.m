function MergeLeheFiles(filePath1, filePath2)

    fileId                          = H5F.open(filePath2, 'H5F_ACC_RDWR', 'H5P_DEFAULT');
    groupPathSet                    = Data.HDF.Helper.GetGroupPathSet(fileId, 4);
    chunkPath                       = '/TEST_BENCH/WK52/thermal_behavior/';
    
    for j = 1 : numel(groupPathSet)
                               
        variabledata1                   = h5read(filePath1, [groupPathSet{j, :} '/1 Hz']);
        variabledata2                   = h5read(filePath2, [groupPathSet{j, :} '/1 Hz']);
        variableData_status1            = logical(h5read(filePath1, [groupPathSet{j, :} '/1 Hz_status']));
        variableData_status2            = logical(h5read(filePath2, [groupPathSet{j, :} '/1 Hz_status']));

        h5write(filePath2, [groupPathSet{j, :} '/1 Hz'], int16(variabledata1 + variabledata2))
        h5write(filePath2, [groupPathSet{j, :} '/1 Hz_status'], uint8(variableData_status1 + variableData_status2))
            
    end

    chunkData1                      = h5read(filePath1, [chunkPath 'is_chunk_completed_set']);
    chunkData2                      = h5read(filePath2, [chunkPath 'is_chunk_completed_set']);
    
    h5write(filePath2, [chunkPath 'is_chunk_completed_set'], uint8(chunkData1 + chunkData2))
    
    H5F.close(fileId)
    
end