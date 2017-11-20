function [x, y] = Transform(Data, Size, TransformationMatrix)

    TransformationMatrix    = repmat(TransformationMatrix, [1 1 prod(Size)]);
    Result                  = Matrix.Multiplication(TransformationMatrix, Data);
    
    x                       = reshape(Result(1, 1, :), Size);
    y                       = reshape(Result(2, 1, :), Size);

end

