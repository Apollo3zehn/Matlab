function [Structure] = RenameField(Structure, OldFieldName, NewFieldName)

    if isfield(Structure, OldFieldName) && ~strcmp(OldFieldName, NewFieldName)

        Structure.(NewFieldName) = Structure.(OldFieldName);
        Structure = rmfield(Structure, OldFieldName);
    
    end

end

