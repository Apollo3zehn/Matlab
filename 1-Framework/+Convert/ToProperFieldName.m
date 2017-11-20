function [NewFieldNames] = ToProperFieldName(FieldNames)

    NewFieldNames = regexprep(FieldNames, '[^a-zA-Z0-9]', '_');
    
end