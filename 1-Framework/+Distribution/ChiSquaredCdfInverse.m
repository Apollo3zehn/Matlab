function X = ChiSquaredCdfInverse(Probability, k)
      
    [Probability, k] = InputSizeCheck(Probability, k);

    X = Distribution.GammaCdfInverse(Probability, k / 2, 2);
    
end