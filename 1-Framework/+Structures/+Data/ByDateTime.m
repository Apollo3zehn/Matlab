function [Structure] = ByDateTime(Structure, DateTimeFieldName, DateTimeBegin, DateTimeEnd)

Indices     = (DateTimeBegin <= Structure.(DateTimeFieldName)) & (Structure.(DateTimeFieldName) < DateTimeEnd);

FieldNames  = fieldnames(Structure);
FieldCount  = length(FieldNames);

for FieldNumber = 1 : FieldCount  
    
	FieldName = FieldNames{FieldNumber};
    
    if numel(Structure.(FieldName)) == numel(Indices)
        Structure.(FieldName) = Structure.(FieldName)(Indices, :);    
    end    
        
end

Hits        = find(Indices == 1);

if isempty(Hits);
    Structure.RowCount = 0;
else
    Structure.RowCount = length(Hits);
end

end