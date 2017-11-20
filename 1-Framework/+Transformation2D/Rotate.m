function [x, y] = Rotate(x, y, Angle)
    
    [Data, Size]            = InputSizeCheck(x, y);
    
    TransformationMatrix    = [ cos(Angle) -sin(Angle) 0; 
                                sin(Angle)  cos(Angle) 0;
                                0           0          0];

	[x, y]                  = Transform(Data, Size, TransformationMatrix);
    
end

