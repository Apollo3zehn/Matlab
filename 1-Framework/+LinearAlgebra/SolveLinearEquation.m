% Solves the linear equation A * x = b
% A must be a vector
% b must be a vector or matrix, where each column represents b

function [Slope, Offset] = SolveLinearEquation(A, b)
 
    A = A(:);
    
    Factors = [ones(numel(A), 1), A] \ b;

    Offset  = Factors(1, :)';
    Slope   = Factors(2, :)';
    
end

