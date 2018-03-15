function CreateVirtualDataset(baseDirectoryPath)

    % P/invoke
    assemblyInfo    = NET.addAssembly([pwd '\1-Framework\External\HDF.PInvoke.1.10.0.3\HDF.PInvoke.dll']);
    H5P_DEFAULT     = HDF.PInvoke.H5P.DEFAULT;
    H5S_UNLIMITED   = HDF.PInvoke.H5S.UNLIMITED;
    
    %
    vdsFilePath     = [baseDirectoryPath '\VDS\VDS.h5'];
    epoch           = datenum(2017, 03, 01);

    if exist(vdsFilePath, 'file')
        vdsFileId       = HDF.PInvoke.H5F.open(vdsFilePath, HDF.PInvoke.H5F.ACC_RDWR, H5P_DEFAULT);
    else
        vdsFileId       = HDF.PInvoke.H5F.create(vdsFilePath, HDF.PInvoke.H5F.ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
    end
    
    finishup        = onCleanup(@() HDF.PInvoke.H5F.close(vdsFileId));
    filePathSet     = Directory.GetFileNames(baseDirectoryPath, 'h5', false);
       
    for filePath = filePathSet.'
                
        filePath        = char(filePath);
        
        Display.TextWithoutBreaks(sprintf('Processing file %s ... ', strrep(filePath, '\', '\\')))
        
        sourceFileId    = HDF.PInvoke.H5F.open(filePath, HDF.PInvoke.H5F.ACC_RDONLY, H5P_DEFAULT);

        % old Matlab lib start
        sourceFileId_tmp = H5F.open(filePath);
        groupPathSet	= Data.HDF.Helper.GetGroupPathSet(sourceFileId_tmp, 4);
        H5F.close(sourceFileId_tmp)
        % old Matlab lib end
        
        for groupPath = groupPathSet.'
            
            groupPath           = char(groupPath);           
            groupPath_splitted 	= strsplit(groupPath, '/');
            fieldName           = ['guid_' strrep(groupPath_splitted{1, 5}, '-', '_')];

            % group path
            index.(fieldName).HdfPath              	= groupPath;    

            % file path
            if ~isfield(index.(fieldName), 'FilePath')
                index.(fieldName).FilePath               = cell(0, 1);               
            end

            index.(fieldName).FilePath{end + 1, :} 	= filePath;
            
            % sample rate
            srcGroupId = HDF.PInvoke.H5G.open(sourceFileId, groupPath);

            switch(true)
                case HDF.PInvoke.H5L.exists(srcGroupId, '1 Hz', H5P_DEFAULT) > 0
                    sampleRate = 1;
                case HDF.PInvoke.H5L.exists(srcGroupId, '25 Hz', H5P_DEFAULT) > 0
                    sampleRate = 25;
                case HDF.PInvoke.H5L.exists(srcGroupId, '50 Hz', H5P_DEFAULT) > 0
                    sampleRate = 50;
                case HDF.PInvoke.H5L.exists(srcGroupId, '100 Hz', H5P_DEFAULT) > 0
                    sampleRate = 100;
                otherwise
                    error('no dataset available')
            end
            
            index.(fieldName).SampleRate = sampleRate;
            
            % name set
            
            
            
        end
       
        HDF.PInvoke.H5F.close(sourceFileId);
        
        Display.Done
               
    end
        
    for variableName = fieldnames(index).'
               
        variableName = char(variableName);
        
        Display.TextWithoutBreaks(sprintf('Processing variable %s ... ', variableName))
        
        vdsLength               = (datenum(2017, 03, 06) - epoch) * 86400 * sampleRate;
        vdsSpaceId              = HDF.PInvoke.H5S.create_simple(1, vdsLength, H5S_UNLIMITED);
        vdsPropertyId           = HDF.PInvoke.H5P.create(HDF.PInvoke.H5P.DATASET_CREATE);     

        for filePath = index.(variableName).FilePath.'
            
            filePath = char(filePath);
            
            % old Matlab lib start
            date = datenum(char(h5readatt(filePath, '/', 'date')), 'yyyy-mm-ddThh-MM-ss');
            % old Matlab lib end
            
            vdsGroupPath            = index.(variableName).HdfPath;           
            vdsGroupPath_splitted   = strsplit(vdsGroupPath, '/');
            vdsSampleRate           = index.(variableName).SampleRate;
            
            vdsGroupId1             = -1;
            vdsGroupId2             = -1;
            vdsGroupId3             = -1;
            vdsGroupId4             = -1;
            
            % level 1
            if HDF.PInvoke.H5L.exists(vdsFileId, vdsGroupPath_splitted{1, 2}, H5P_DEFAULT) > 0
                vdsGroupId1             = HDF.PInvoke.H5G.open(vdsFileId, vdsGroupPath_splitted{1, 2}, H5P_DEFAULT);
            else
                vdsGroupId1             = HDF.PInvoke.H5G.create(vdsFileId, vdsGroupPath_splitted{1, 2}, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
            end
          
            if vdsGroupId1 < 0
                error(['Could not create group. ' 'Group name: ' vdsGroupPath_splitted{1, 2} '.'])
            end
            
            % level 2
            if HDF.PInvoke.H5L.exists(vdsGroupId1, vdsGroupPath_splitted{1, 3}, H5P_DEFAULT) > 0
                vdsGroupId2             = HDF.PInvoke.H5G.open(vdsGroupId1, vdsGroupPath_splitted{1, 3});
            else
                vdsGroupId2             = HDF.PInvoke.H5G.create(vdsGroupId1, vdsGroupPath_splitted{1, 3}, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT');
            end
            
            if vdsGroupId2 < 0
                error(['Could not create group. ' 'Group name: ' vdsGroupPath_splitted{1, 3} '.'])
            end
            
            % level 3
            if HDF.PInvoke.H5L.exists(vdsGroupId2, vdsGroupPath_splitted{1, 4}, H5P_DEFAULT) > 0
                vdsGroupId3             = HDF.PInvoke.H5G.open(vdsGroupId2, vdsGroupPath_splitted{1, 4});
            else
                vdsGroupId3             = HDF.PInvoke.H5G.create(vdsGroupId2, vdsGroupPath_splitted{1, 4}, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
            end
            
            if vdsGroupId3 < 0
                error(['Could not create group. ' 'Group name: ' vdsGroupPath_splitted{1, 4} '.'])
            end
            
            % level 4
            if HDF.PInvoke.H5L.exists(vdsGroupId3, vdsGroupPath_splitted{1, 5}, H5P_DEFAULT) > 0
                vdsGroupId4             = HDF.PInvoke.H5G.open(vdsGroupId3, vdsGroupPath_splitted{1, 5});
            else
                vdsGroupId4             = HDF.PInvoke.H5G.create(vdsGroupId3, vdsGroupPath_splitted{1, 5}, H5P_DEFAULT, H5P_DEFAULT, H5P_DEFAULT);
            end
            
            if vdsGroupId4 < 0
                error(['Could not create group. ' 'Group name: ' vdsGroupPath_splitted{1, 5} '.'])
            end
                        
            % virtual dataset
            datasetName             = sprintf('%d Hz', vdsSampleRate);
            
            %
            srcSpaceId              = HDF.PInvoke.H5S.create_simple(1, 86400 * vdsSampleRate, 86400 * vdsSampleRate);
            srcDatasetId            = HDF.PInvoke.H5D.open(srcGroupId, datasetName);
            srcTypeId               = HDF.PInvoke.H5D.get_type(srcDatasetId);
            
            %
            start                   = uint64((date - epoch) * 86400 * vdsSampleRate);
            stride                  = uint64(86400 * vdsSampleRate);
            count                   = 1;
            block                   = uint64(86400 * vdsSampleRate);
            
            result                  = HDF.PInvoke.H5S.select_hyperslab(vdsSpaceId, HDF.PInvoke.seloper_t.SET, start, stride, count, block);
            result                  = HDF.PInvoke.H5P.set_virtual(vdsPropertyId, vdsSpaceId, filePath, [vdsGroupPath '/' datasetName], srcSpaceId);
                         
            % close           
            HDF.PInvoke.H5D.close(srcTypeId);
            HDF.PInvoke.H5T.close(srcDatasetId);
            HDF.PInvoke.H5S.close(srcSpaceId);
            
        end

        result = HDF.PInvoke.H5D.create(vdsGroupId4, datasetName, srcTypeId, vdsSpaceId, H5P_DEFAULT, vdsPropertyId, H5P_DEFAULT);
        
        HDF.PInvoke.H5P.close(vdsPropertyId);
        HDF.PInvoke.H5S.close(vdsSpaceId);
        
        Display.Done
        
    end
    
    HDF.PInvoke.H5F.flush(vdsFileId, HDF.PInvoke.scope_t.GLOBAL);
    HDF.PInvoke.H5F.close(vdsFileId);
    
    Display.Finished
    
end