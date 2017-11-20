function Indices = FindArrayIndicesInArray(Matrix, ReferenceMatrix)

    Indices = arrayfun(@(x) find(ReferenceMatrix == x, 1), Matrix);

end

