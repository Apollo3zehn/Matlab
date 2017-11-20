function VirtualDatasetTest2(filePath)

    % P/invoke
    assemblyInfo    = NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
    H5P_DEFAULT     = HDF.PInvoke.H5P.DEFAULT;
    H5S_UNLIMITED   = HDF.PInvoke.H5S.UNLIMITED;
   
    length          = 15779520; %40640; %1440;%15779520;
    buffer          = System.Runtime.InteropServices.Marshal.AllocHGlobal(length);
    buffer_NET      = NET.createArray('System.Byte', length);
       
    fileId          = HDF.PInvoke.H5F.open(filePath, HDF.PInvoke.H5F.ACC_RDONLY, H5P_DEFAULT);
    groupId         = HDF.PInvoke.H5G.open(fileId, '/LEHE/LEHE03/GENERAL_DAQ');
    datasetId       = HDF.PInvoke.H5D.open(groupId, 'is_chunk_completed_set', H5P_DEFAULT);
    typeId          = HDF.PInvoke.H5D.get_type(datasetId);
    
    spaceId         = HDF.PInvoke.H5D.get_space(datasetId);  
    
    
    start           = uint64(0);
    stride          = uint64(length);
    count           = uint64(1);
    block           = uint64(length);
    
    % important to reset previous hyperslabs
    result          = HDF.PInvoke.H5S.select_hyperslab(spaceId, HDF.PInvoke.seloper_t.SET, start, stride, count, block);
    result          = HDF.PInvoke.H5D.read(datasetId, typeId, 0, spaceId, H5P_DEFAULT, buffer);
    
    System.Runtime.InteropServices.Marshal.Copy(buffer, buffer_NET, 0, length);
    buffer_NET      = uint8(buffer_NET).';
    
    plot(buffer_NET);
    xlim([9.025e6 9.045e6])
    ylim([-0.1 1.1])
    
    %
    System.Runtime.InteropServices.Marshal.FreeHGlobal(buffer);
    HDF.PInvoke.H5G.close(groupId);
    HDF.PInvoke.H5D.close(datasetId);
    HDF.PInvoke.H5F.close(fileId);
    
end

