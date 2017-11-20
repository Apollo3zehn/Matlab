function [GroupedData] = Group(Data, RowCountPerGroup)
            
    Size        = size(Data);
    
    NewRowCount = Size(1) - rem(Size(1), RowCountPerGroup);
    
    Data        = Data(1 : NewRowCount, :);
    
    GroupedData = reshape(Data, RowCountPerGroup, Size(2), []);
    GroupedData = squeeze(GroupedData);
        
end