function J = Jacobian(Delegate, PartialDerivationWidth, x, y)

    x               = x(:);
    VariableCount   = numel(x);
    
    J = NaN(size(y, 1), VariableCount);
    
    for i = 0 : VariableCount - 1
                
        y2          = Delegate(x + PartialDerivationWidth * circshift([1; zeros(VariableCount - 1, 1)], i));
        J(:, i + 1) = (y2(:)-y(:)) / PartialDerivationWidth;
        
    end
        
end