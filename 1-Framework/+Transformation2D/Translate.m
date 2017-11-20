function [x, y] = Translate(x, y, dx, dy)

    [Data, Size]            = InputSizeCheck(x, y);
    
    TransformationMatrix    = [ 1 0 dx; 
                                0 1 dy;
                                0 0 1 ];

	[x, y]                  = Transform(Data, Size, TransformationMatrix);
                            
end

