function VirtualDatasetTest(filePath)

    % P/invoke
    assemblyInfo    = NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
    H5P_DEFAULT     = HDF.PInvoke.H5P.DEFAULT;
    H5S_UNLIMITED   = HDF.PInvoke.H5S.UNLIMITED;
   
    sampleRate      = 100;
    lengthPerDay    = 86400 * sampleRate;
    datasetLength   = lengthPerDay * 10;
    buffer          = System.Runtime.InteropServices.Marshal.AllocHGlobal(86400*100*8*2);
    buffer_NET      = NET.createArray('System.Int16', 86400*100*8);
    
    %
%     epoch           = datenum(2017, 03, 04);
%     vdsLength    	= (DateTime.ToDate(now) - epoch) * lengthPerDay;
    
    fileId          = HDF.PInvoke.H5F.open(filePath, HDF.PInvoke.H5F.ACC_RDONLY, H5P_DEFAULT);
    groupId         = HDF.PInvoke.H5G.open(fileId, '/LEHE/LEHE03/GENERAL_DAQ/e5d628c9-3592-4245-92a5-deb3e678b788');
    datasetId       = HDF.PInvoke.H5D.open(groupId, '100 Hz', H5P_DEFAULT);
    typeId          = HDF.PInvoke.H5D.get_type(datasetId);
%     spaceId         = HDF.PInvoke.H5S.create_simple(1, vdsLength, vdsLength);
%     spaceId_mem     = HDF.PInvoke.H5S.create_simple(1, datasetLength, datasetLength);
    
%     start           = uint64((datenum(2017, 03, 04) - epoch) * lengthPerDay);
%     stride          = uint64(datasetLength);
%     count           = uint64(1);
%     block           = uint64(datasetLength);
    
%     result          = HDF.PInvoke.H5S.select_hyperslab(spaceId, HDF.PInvoke.seloper_t.SET, start, stride, count, block);
    result          = HDF.PInvoke.H5D.read(datasetId, typeId, 0, 0, H5P_DEFAULT, buffer);
    
    System.Runtime.InteropServices.Marshal.Copy(buffer, buffer_NET, 0, 86400*100 * 8);
    buffer_NET      = uint16(buffer_NET).';
    
    plot(buffer_NET);
    
    %
    System.Runtime.InteropServices.Marshal.FreeHGlobal(buffer);
    HDF.PInvoke.H5G.close(groupId);
    HDF.PInvoke.H5D.close(datasetId);
    HDF.PInvoke.H5F.close(fileId);
    
end

