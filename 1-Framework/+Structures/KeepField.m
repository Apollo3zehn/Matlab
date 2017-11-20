function [Structure] = KeepField(Structure, FieldName, KeepFirstFieldName)

    FieldNames          = fieldnames(Structure);
    FieldsToKeep        = logical(strcmp(FieldNames, FieldName));
   
    if KeepFirstFieldName
        FieldsToKeep(1) = 1;
    end

    Structure           = rmfield(Structure, FieldNames(~FieldsToKeep));

end