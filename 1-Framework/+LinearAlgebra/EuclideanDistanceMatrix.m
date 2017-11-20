function Distance = EuclideanDistanceMatrix(X, Y)

    RowCount    = size(X, 1);
    ColumnCount = size(Y, 1);
    
    Distance   	= ones(RowCount, ColumnCount);
    
    for i = 1 : RowCount
        Distance(i, :) = LinearAlgebra.pNorm(bsxfun(@minus, X(i, :), Y).', 2).';
    end

end