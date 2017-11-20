function [Coherence, Frequency] = Coherence(Data1, Data2, Parameter1, Parameter2, SamplingFrequency, EstimationMethod, IsMagnitudeSquared)

    % (Magnitude Squared) Coherence
    %
    % - Syntax -
    %
    % [Coherence, Frequency] = Coherence(Data1, Data2, Parameter1, Parameter2, SamplingFrequency, EstimationMethod, IsMagnitudeSquared)
    %
    % - Inputs -
    %
    % Data1                 - Input vector for the power spectral density estimate.
    % Data2                 - Required vector when cross power spectral density shall be estimated, in other cases can be left empty [].
    % Parameter1           	- Welch's method: Window function as vector. // Multitaper method: Scalar Half time-bandwidth product.
    % Parameter2            - Welch's method: Overlapping factor. // Multitaper method: averaging method
    % SamplingFrequency     - Sampling frequency.
    % EstimationMethod      - Estimation method. Options are {'Welch', 'Multitaper'}
    % IsMagnitudeSquared    - Boolean specifying if the maginitude squared coherence shall be calculated
    %
    % - Outputs -
    %
    % Coherence             - Coherence of the input data.
    % Frequency             - Frequency vector for the resulting coherence.

    switch EstimationMethod
        case 'Welch'
            [Sxy, Frequency, ~] = SpectralAnalysis.WelchPowerSpectralDensity(Data1, Data2, Parameter1, Parameter2, SamplingFrequency, []);
            [Sxx, ~, ~]         = SpectralAnalysis.WelchPowerSpectralDensity(Data1, [], Parameter1, Parameter2, SamplingFrequency, []);
            [Syy, ~, ~]         = SpectralAnalysis.WelchPowerSpectralDensity(Data2, [], Parameter1, Parameter2, SamplingFrequency, []);
        case 'Multitaper'
            [Sxy, Frequency, ~] = SpectralAnalysis.MultitaperPowerSpectralDensity(Data1, Data2, Parameter1, Parameter2, SamplingFrequency, []);
            [Sxx, ~, ~]         = SpectralAnalysis.MultitaperPowerSpectralDensity(Data1, [], Parameter1, Parameter2, SamplingFrequency, []);
            [Syy, ~, ~]         = SpectralAnalysis.MultitaperPowerSpectralDensity(Data2, [], Parameter1, Parameter2, SamplingFrequency, []);
        otherwise
            error('Specified method cannot be found.')
    end
    
    if IsMagnitudeSquared
        Coherence = abs(Sxy).^2 ./ (Sxx .* Syy);
    else
        Coherence = abs(Sxy) ./ sqrt(Sxx .* Syy);
    end
    
end

