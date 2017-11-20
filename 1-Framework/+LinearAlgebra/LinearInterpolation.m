function [Interpolation] = LinearInterpolation(x, x1, x2, y1, y2)
    
    x   = x(:);
    x1  = x1(:);
    x2  = x2(:);
    y1  = y1(:);
    y2  = y2(:);

    Interpolation = (y2-y1) ./ (x2-x1) .* (x-x1) + y1;
    
end

