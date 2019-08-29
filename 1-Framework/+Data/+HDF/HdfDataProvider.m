classdef HdfDataProvider < handle

    properties
        sourceFileId        = -1;
        vdsMetaFileId       = -1;
    end
    
    methods
        
        function this = HdfDataProvider(baseDirectoryPath)
            
            NET.addAssembly(fullfile(pwd, '2-ThirdParty\OneDas.Hdf.Types\', 'OneDas.Hdf.Types.dll'));
            NET.addAssembly(fullfile(pwd, '2-ThirdParty\OneDas.Hdf.Types\', 'HDF.PInvoke.dll'));
           
            import HDF.*
            import HDF.PInvoke.*
                       
            if ~exist(baseDirectoryPath, 'dir')
                error('directory does not exist')
            end
                           
            this.sourceFileId    = PInvoke.H5F.open(fullfile(baseDirectoryPath, 'VDS.h5'), H5F.ACC_RDONLY);
           
            if this.sourceFileId == -1 
                error('could not open source file')
            end

            this.vdsMetaFileId   = PInvoke.H5F.open(fullfile(baseDirectoryPath, 'VDS_META.h5'), H5F.ACC_RDONLY);
            
            if this.vdsMetaFileId == -1 
                PInvoke.H5F.close(this.sourceFileId); % improve
                error('could not open meta file')
            end
            
        end
        
        function delete(this)
            
            import HDF.*
            import HDF.PInvoke.*
            
            PInvoke.H5F.close(this.sourceFileId);
            PInvoke.H5F.close(this.vdsMetaFileId);
            
        end
        
        function datasetInfo = LoadDataset(this, datasetGroupPath, datasetName, variableName, dateTimeBegin, dateTimeEnd, varargin)

            import HDF.*
            import HDF.PInvoke.*
            import OneDas.Hdf.IO.*
            
            % settings
            datasetNamePartSet  = strsplit(datasetName, '_');
            sampleRate          = Data.HDF.Helper.GetSampleRate(datasetName);
            datasetName_status  = [datasetNamePartSet{1} '_status'];
            returnRawData       = false;
            filterData          = true;
            
            datasetInfo.Dataset = [];
            datasetInfo.RawDataSet = [];
            datasetInfo.NameSet = [];
            datasetInfo.Unit = [];
            datasetInfo.TransferFunctionSet = [];
            
            % analyze options

            for i = 1 : numel(varargin)

                parameter = varargin{i};

                if isnumeric(parameter)

                    continue

                elseif strcmp(parameter, '-Raw')
                    returnRawData = true;
                elseif strcmp(parameter, '-Unfiltered')
                    filterData = false;
                end

            end 

            %
            [start, stride, block, count]   = Data.HDF.Helper.GetHyperslab(datetime(2000, 01, 01, 'TimeZone', 'UTC'), datetime(2030, 01, 01, 'TimeZone', 'UTC'), dateTimeBegin, dateTimeEnd, sampleRate);
           
            if ~IOHelper.CheckLinkExists(this.sourceFileId, [datasetGroupPath '/' datasetName])
                error(['Dataset ' [datasetGroupPath '/' datasetName] ' does not exist.'])
            end   
            
            rawData                         = IOHelper.ReadDataset(this.sourceFileId, [datasetGroupPath '/' datasetName], start, stride, block, count);          
            datasetInfo.Dataset             = double(rawData).';
           
            if returnRawData
                datasetInfo.RawDataset      = datasetInfo.Dataset;
            end

            if (IOHelper.CheckLinkExists(this.sourceFileId, [datasetGroupPath '/' datasetName_status]))
                
                rawData_status              = IOHelper.ReadDataset(this.sourceFileId, [datasetGroupPath '/' datasetName_status], start, stride, block, count);
                
                if filterData
                    datasetInfo.Dataset(~logical(rawData_status)) = NaN;
                end
                
            end
            
            % name set
            groupId                         = PInvoke.H5G.open(this.sourceFileId, datasetGroupPath);
            datasetInfo.NameSet             = NET.Convert(IOHelper.ReadAttribute(groupId, 'name_set'));
            PInvoke.H5D.close(groupId);
            
            % unit
            if this.vdsMetaFileId > -1

                try
                    groupId                             = PInvoke.H5G.open(this.vdsMetaFileId, datasetGroupPath);
                    datasetInfo.Unit                    = NET.Convert(IOHelper.ReadAttribute(groupId, 'unit'));
                    PInvoke.H5G.close(groupId);
                catch ex
                    this.ShowWarning(ex)
                end

            end
            
            % transfer function set
            if this.vdsMetaFileId > -1

                try
                    groupId                             = PInvoke.H5G.open(this.vdsMetaFileId, datasetGroupPath);
                    datasetInfo.TransferFunctionSet     = NET.Convert(IOHelper.ReadAttribute(groupId, 'transfer_function_set'));
                    
                    for i = numel(datasetInfo.TransferFunctionSet)

                        transfer_function   = datasetInfo.TransferFunctionSet(i);

                        switch char(transfer_function.type)

                            case 'polynomial'

                                argumentSet = strsplit(char(transfer_function.argument), ';');
                                datasetInfo.Dataset = datasetInfo.Dataset * eval(argumentSet{1}) + eval(argumentSet{2});

                            case 'function'
                                error('not implemented')
                        end

                    end

                    PInvoke.H5G.close(groupId);
                
                catch ex
                    this.ShowWarning(ex)
                end

            end

        end
        
        function [data, map, info] = LoadDatasets(this, campaignPath, variableNameSet, datasetNameSet, dateTimeBegin, dateTimeEnd, varargin)

            import OneDas.Hdf.Core.*
            import HDF.*
            import HDF.PInvoke.*
            
            persistent campaignInfoSet;
            
            fieldName = ['m' strrep(campaignPath, '/', '_')];
            
            if isfield(campaignInfoSet, fieldName)
                campaignInfo = campaignInfoSet.(fieldName);
            else
                
                groupId = PInvoke.H5G.open(this.sourceFileId, campaignPath);
                
                if groupId == -1
                    error('could not open group')
                end
     
                campaignInfo = GeneralHelper.GetCampaignInfo(this.sourceFileId, false, campaignPath);               
                campaignInfoSet.(fieldName) = campaignInfo;    
                
                PInvoke.H5G.close(groupId);
                
            end           
            
            info.CampaignPath = campaignPath;
            info.DateTimeBegin = dateTimeBegin;
            info.DateTimeEnd = dateTimeEnd;
            
            if isscalar(datasetNameSet)
                datasetNameSet = repmat(datasetNameSet, size(variableNameSet, 1), 1);
            end
            
            for i = size(variableNameSet, 1) : -1 : 1
                
                [name, index]   = this.SplitVariableName(variableNameSet{i});
                guidSet         = NET.Convert(GeneralHelper.GetVariableGuids(campaignInfo, name));
               
                if isempty(guidSet)
                    error('Variable ''%s'' does not exist.', variableNameSet{i});
                elseif numel(guidSet) > 1                  
                                      
                    if (index == 0)
                        error('Variable ''%s'' is not unique. Consider adding a selector to the variable name. Example: ''%s(2)''.', variableNameSet{i}, variableNameSet{i});
                    end
                    
                    guid = char(guidSet{index});
                    
                else
                    guid = char(guidSet);
                end
                                   
                data(i) = this.LoadDataset([campaignPath '/' guid], datasetNameSet{i}, variableNameSet{i}, dateTimeBegin, dateTimeEnd, varargin);
                
            end
            
            map = containers.Map(variableNameSet, 1 : numel(variableNameSet));
            
        end
        
        function guid = GetGuid(~, campaignInfo, variableName)
                                  
            for variableInfo = campaignInfo.VariableInfoSet
                if sum(strcmp(variableInfo.VariableNameSet, variableName)) > 0
                  guid = variableInfo.Name;
                  return
                end
            end
                   
            error('no variable named ''%s'' found', variableName);
            
        end
        
        function [name, index] = SplitVariableName(~, variableInfo)
            
            index   = 0;
            parts   = strsplit(variableInfo, {'(', ')'});
            name    = char(parts(1));
            
            if numel(parts) == 3
                index = str2double(parts(2));
            end
            
        end
        
        function ShowWarning(~, message)
            
            if isa(message, 'NET.NetException')
                message = char(message.ExceptionObject.Message);
            elseif isa(message, 'MException')
                message = message.message;
            elseif ischar(class(message))
                message = message;
            else
                error('wrong input type')
            end
            
            fprintf('WARNING: %s\n', message)
            
        end
        
    end 
    
end