function [x, y] = Scale(x, y, Factor_x, Factor_y)
    
    [Data, Size]            = InputSizeCheck(x, y);
    
    TransformationMatrix    = [ Factor_x    0        0; 
                                0           Factor_y 0;
                                0           0        0];

	[x, y]                  = Transform(Data, Size, TransformationMatrix);
    
end

