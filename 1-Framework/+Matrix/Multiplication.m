function Result = Multiplication(A, B)

    % Vectorized multiplication of matrices. Singelton expansion is not supported.
    %
    % - Syntax -
    %
    % Result = Multiplication(A, B)
    %
    % - Inputs -
    %
    % A           	- n-by-m-by-... Matrix.
    % A            	- m-by-p-by-... Matrix.
    %
    % - Outputs -
    %
    % Result        - n-by-p-by-... Matrix.
    %
    % - Test -
    %
    % A = rand(3, 2, 3, 2, 3);
    % B = rand(2, 1, 3, 2, 3);
    % C = Matrix.Multiplication(A, B);

    %% Validation
    
    A_Size      = size(A);
    B_Size      = size(B);
    A_DimCount  = numel(A_Size);
    B_DimCount  = numel(B_Size);
    
    if A_DimCount ~= B_DimCount
        error('Order of A and B must be the same.')
    end
   
    if any(find(abs(A_Size - B_Size) > 0) > 2)
        error('Dimensions 3 to %d of A and B are not the same. Singelton expansion is not supported.', A_DimCount)
    end
    
    %% Calculation

    A           = reshape(A, A_Size(1), A_Size(2), []);
    B           = permute(reshape(B, B_Size(1), B_Size(2), []), [2 1 3:numel(B_Size)]);

    Result     	= zeros([A_Size(1) B_Size(2) A_Size(3 : end)]);

    for i = 1 : A_Size(1)    
        for j = 1 : B_Size(2)
            Result(i, j, :) = sum(A(i, :, :) .* B(j, :, :), 2);
        end
    end

end

