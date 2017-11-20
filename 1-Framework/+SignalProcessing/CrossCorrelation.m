function [Correlation, Lag] = CrossCorrelation(Data1, Data2, ScalingMethod)

    % Cross correlation
    %
    % - Syntax -
    %
    % [Correlation, Lag] = CrossCorrelation(Data1, Data2, ScalingMethod)
    %
    % - Inputs -
    %
    % Data1                 - Input vector 1 for the cross correlation.
    % Data2                 - Input vector 2 for the cross correlation.
    % ScalingMethod         - Scaling method. Options are {'None', 'Biased', 'Unbiased', 'Coefficient'}.
    %
    % - Outputs -
    %
    % Correlation        	- Correlation of the input data.
    % Lag                   - Lag for each correlation value.
    %
    % - Example -
    %
    % x = rand(1, 100);
    % y = rand(1, 100);
    % [Correlation, Lag] = SignalProcessing.CrossCorrelation(x, y, 'Coefficient');

    %% Input validation
          
    if ~ischar(ScalingMethod)
        error('ScalingMethod must be a string.')
    end
        
    %% Calculation
    
    DataLength      = size(Data1, 1);
    FftLength       = size(Data1, 1) + size(Data2, 1) - 1;
    Lag             = (1 : FftLength).' - (FftLength + 1).' / 2;    
    Correlation     = fftshift(ifft(bsxfun(@times, fft(Data1, FftLength), conj(fft(Data2, FftLength)))), 1);
    
    switch ScalingMethod
        case 'None'
            ScalingFactor = 1;
        case 'Biased'
            ScalingFactor = DataLength;
        case 'Unbiased' 
            ScalingFactor = DataLength - abs(Lag);
        case 'Coefficient'
            ScalingFactor = LinearAlgebra.pNorm(Data1, 2) .* LinearAlgebra.pNorm(Data2, 2);
        otherwise
            error('Scaling method specified cannot be found.')
    end
    
    Correlation = bsxfun(@rdivide, Correlation, ScalingFactor);
               
end

