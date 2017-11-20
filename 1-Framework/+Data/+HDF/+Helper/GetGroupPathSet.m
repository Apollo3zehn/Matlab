function groupPathSet = GetGroupPathSet(locationId, maxDepth)

    groupPathSet    = cell(0, 1);
    
    H5L.iterate(locationId, 0, 0, 0, @ProcessGroup, '');
    
    function [result, path] = ProcessGroup(groupId, name, path)
        
        result      = 0; 
        level       = numel(strsplit(path, '/'));
        objectInfo	= H5G.get_objinfo(groupId, name, 0);
               
        if objectInfo.type == 0 % is group
            if level < maxDepth           
                groupId         = H5G.open(groupId, name);
                result          = H5L.iterate(groupId, 0, 0, 0, @ProcessGroup, [path '/' name]);
                H5G.close(groupId);
            else
                groupPathSet{end + 1, :} = [path '/' name];      
            end                 
        end
                             
    end

end