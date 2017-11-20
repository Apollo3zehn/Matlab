function [Data, Size] = InputSizeCheck(x, y)

    x_Size    = size(x);
    x_Numel   = numel(x);
    
    if any(x_Size ~= size(y))
        error('Inputs x and y must be the same size')
    end
    
    x       = x(:).';
    y       = y(:).';
    
    Size    = x_Size;
    Data   	= reshape([x; y; ones(1, x_Numel)], 3, 1, []);

end

