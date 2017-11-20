function Logical = IndicesToLogical(StartIndices, Length)

    Logical                 = zeros(Length + 1, 1);
    Logical(StartIndices)  	= 1;
    Logical                 = Logical ~= 0;

end

