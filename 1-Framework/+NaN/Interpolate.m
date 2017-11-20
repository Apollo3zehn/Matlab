% Interpolates NaN in data column wise

function [InterpolatedData] = Interpolate(Data, Method, InterpolateNaNEdges)

    Size = size(Data);

    if InterpolateNaNEdges
        
    	[~, IndicesPrefix] = max(~isnan(Data));    
        [~, IndicesSuffix] = max(~isnan(flipdim(Data, 1)));    
        Data = [Data(sub2ind(Size, IndicesPrefix, 1 : Size(2))); Data; Data(sub2ind(Size, Size(1) - IndicesSuffix + 1, 1 : Size(2)))];    
        Size = size(Data);
        
    end
    
    Indices                                 = isnan(Data); 
    Indices(1 : Size(1) : numel(Data))    	= 0; % Prevents the Data(:) effect
    Indices(Size(1) : Size(1) : numel(Data))= 0; % Prevents the Data(:) effect
    Indices                                 = logical(Indices);
    Data(Indices)                           = interp1(find(~Indices), Data(~Indices), find(Indices), Method);
    
    if InterpolateNaNEdges
        InterpolatedData                   	= Data(2 : end - 1, :);
    else
        InterpolatedData                    = Data;
    end
    
end