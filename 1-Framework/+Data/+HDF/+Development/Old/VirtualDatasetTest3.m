function VirtualDatasetTest3(filePath)

    % P/invoke
    assemblyInfo    = NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
    import HDF.PInvoke.*
    H5P_DEFAULT     = H5P.DEFAULT;
    H5S_UNLIMITED   = H5S.UNLIMITED;
    groupPath       = '/LEHE/LEHE03/GENERAL_DAQ/e5d628c9-3592-4245-92a5-deb3e678b788';
    
    length          = 8640000; %40640; %1440;%15779520;
    buffer          = System.Runtime.InteropServices.Marshal.AllocHGlobal(length * 2);
    buffer_NET      = NET.createArray('System.Int16', length);
       
    fileId          = H5F.open(filePath, HDF.PInvoke.H5F.ACC_RDONLY, H5P_DEFAULT);
    groupId         = H5G.open(fileId, groupPath);
    datasetId       = H5D.open(groupId, '100 Hz', H5P_DEFAULT);
    typeId          = H5D.get_type(datasetId);
    spaceId         = H5D.get_space(datasetId);     
    
    start           = uint64(0);
    stride          = uint64(length);
    count           = uint64(1);
    block           = uint64(length);
    
    % important to reset previous hyperslabs
    result          = H5S.select_hyperslab(spaceId, HDF.PInvoke.seloper_t.SET, start, stride, count, block);
    result          = H5D.read(datasetId, typeId, 0, spaceId, H5P_DEFAULT, buffer);
    
    System.Runtime.InteropServices.Marshal.Copy(buffer, buffer_NET, 0, length);
    buffer_NET      = uint16(buffer_NET).';
    
    % scale factor / offset
    scale_factor = h5readatt('M:\DATA\VDS_META.h5', groupPath, 'scale_factor');
    offset = h5readatt('M:\DATA\VDS_META.h5', groupPath, 'offset');
    
    plot(double(buffer_NET) * scale_factor + offset);
%     xlim([9.025e6 9.045e6])
%     ylim([-0.1 1.1])
    
    %
    System.Runtime.InteropServices.Marshal.FreeHGlobal(buffer);
    HDF.PInvoke.H5G.close(groupId);
    HDF.PInvoke.H5D.close(datasetId);
    HDF.PInvoke.H5F.close(fileId);
    
end

