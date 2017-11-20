function p = ChiSquaredPdf(X, k)

    [X, k] = InputSizeCheck(X, k);
    
    p = Distribution.GammaPdf(X, k/2, 2);
    
end

