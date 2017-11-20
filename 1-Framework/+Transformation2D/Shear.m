function [x, y] = Shear(x, y, Shear_x, Shear_y)

    [Data, Size]            = InputSizeCheck(x, y);
    
    TransformationMatrix    = [ 1       Shear_x 0; 
                                Shear_y 1       0;
                                0       0        1 ];

	[x, y]                  = Transform(Data, Size, TransformationMatrix);
                            
end

