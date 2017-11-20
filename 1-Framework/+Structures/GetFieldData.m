function Data = GetFieldData(SourceStructure, RequestedFieldNames)

RequestedFieldCount = length(RequestedFieldNames);

for RequestedFieldNumber = 1 : RequestedFieldCount
    
    RequestedFieldName  = RequestedFieldNames{RequestedFieldNumber};
    
    ExistingFieldNames = fieldnames(SourceStructure);
    ExistingFieldCount = length(ExistingFieldNames);
    
    for ExistingFieldNumber = 1 : ExistingFieldCount
        
        ExistingFieldName = ExistingFieldNames{ExistingFieldNumber};
        
        if strcmp(ExistingFieldName, RequestedFieldName)
             Data.(RequestedFieldName) = SourceStructure.(ExistingFieldName);
        end
        
    end  
    
end