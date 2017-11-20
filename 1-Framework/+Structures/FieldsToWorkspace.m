function FieldsToWorkspace(Structure)
    for FieldName = fieldnames(Structure)'
        Name        = FieldName{1};
        Value       = Structure.(Name);
        assignin('caller', Name, Value)
    end
end

