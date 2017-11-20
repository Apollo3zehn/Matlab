function [Power, Frequency, ConfidenceIntervals] = WelchPowerSpectralDensity(Data1, Data2, Window, OverlapFactor, SamplingFrequency, ConfidenceLevel)

    % Power Spectral Density Estimate
    % see also:
    % http://en.wikipedia.org/wiki/Wiener%E2%80%93Khinchin_theorem
    % http://de.mathworks.com/help/signal/ug/spectral-analysis.html
    % http://de.mathworks.com/help/signal/ref/cpsd.html
    % http://dsp.stackexchange.com/questions/2096/why-so-many-methods-of-computing-psd
    % http://de.mathworks.com/help/signal/ug/bias-and-variability-in-the-periodogram.html
    % detrend?
    %
    % - Syntax -
    %
    % [Frequency, Power, ConfidenceIntervals] = WelchPowerSpectralDensity(Data1, Data2, Window, OverlapFactor, SamplingFrequency, ConfidenceLevel)
    %
    % - Inputs -
    %
    % Data1                 - Input vector for the power spectral density estimate.
    % Data2                 - Required vector when cross power spectral density shall be estimated, in other cases can be left empty [].
    % Window                - Window function as vector for Welch's method.
    % OverlapFactor         - Overlapping factor for Welch's method. 
    % SamplingFrequency     - Sampling frequency.
    % ConfidenceLevel       - Confidence level for the power spectral density estimate. Can be left empty [] if output ConfidenceIntervals is ommited.
    %
    % - Outputs -
    %
    % Power                 - Complex power estimate.
    % Frequency             - Frequency vector for the resulting power estimate.
    % ConfidenceIntervals   - Matrix which contains the conficence intervals for the power spectrum estimate.
    %
    % - Example -
    %
    % fs    = 10;
    % t     = 0 : 1/fs : 40; 
    % x     = sin(2*pi*3*t) + rand(1, length(t))*10; 
    % y     = sin(2*pi*3*t) + sin(2*pi*1*t) + rand(1, length(t))*10; 
    % 
    % [Power, Frequency, ~] = SpectralAnalysis.WelchPowerSpectralDensity(x, y, SpectralAnalysis.WindowFunction.Hann(round(length(t) / 4)), 0.5, fs, []); 
    % plot(gca, Frequency, 10*log10(abs(Power)))
    % title(gca, 'Welch Cross Power Spectral Density Estimate') 
    % xlabel(gca, 'Frequency (Hz)')
    % ylabel(gca, 'Power / Frequency (db/Hz)')
    % grid(gca, 'on')

    %%
    
    if ~isvector(Data1) || (~isempty(Data2) && ~isvector(Data2)) || ~isvector(Window)
        error('Data1, Data2 and Window must be vectors.')
    end
    
    if ~isempty(Data2) && (length(Data1) ~= length(Data2))
        error('Data1 and Data2 must be the same length.')
    end
    
    if length(Window)~=1 && length(Window) > length(Data1)
        error('Length of Data1 must be 1 or equal/greater than lenght of Window.')
    end
        
    if ~isscalar(SamplingFrequency) || ~isscalar(OverlapFactor) || (~isempty(ConfidenceLevel) && ~isscalar(ConfidenceLevel))
        error('SamplingFrequency, OverlapFactor and ConfidenceLevel must be scalars.')
    end
    
    Data1                   = Data1(:);
    Data2                   = Data2(:);
	Window                  = Window(:);
    DataLength              = numel(Data1);
    
    %% Welch's method
    
    WindowCompensation      = Window' * Window;
    SegmentLength           = length(Window);
    SegmentOverlapLength    = round(SegmentLength * OverlapFactor);
    SegmentIndices          = (1 : SegmentLength)';
    FftLength               = 2^nextpow2(SegmentLength);
    Power                   = 0;
    SegmentCounter          = 0;
    
    while true
                          
        if isempty(Data2)
            Segment1      	= fft(Data1(SegmentIndices) .* Window, FftLength);
            Power           = Power + Segment1 .* conj(Segment1);
        else
            Segment1    	= fft(Data1(SegmentIndices) .* Window, FftLength);
            Segment2       	= fft(Data2(SegmentIndices) .* Window, FftLength);
            Power           = Power + Segment1 .* conj(Segment2);
        end
        
        SegmentCounter    	= SegmentCounter + 1;
        SegmentIndices     	= SegmentIndices + (SegmentLength - SegmentOverlapLength);
                
        if SegmentIndices(end) > DataLength
            break
        end
        
    end
    
    % Parseval's Law: PSD / df = PSD * N / fs
    Power                   = Power / (SegmentCounter * WindowCompensation);
    Power                   = Power(1 : end/2 + 1) / SamplingFrequency;
    Power(2 : end - 1)  	= Power(2 : end - 1) * 2;
    
    Frequency             	= SamplingFrequency / 2 * linspace(0, 1, FftLength / 2 + 1).';

    %% Confidence Intervals
    
    ConfidenceIntervals   	= [];
    
    if ~isempty(ConfidenceLevel)    
        
        ConfidenceBounds                = Statistics.ConfidenceInterval(ConfidenceLevel, SegmentCounter);
        ConfidenceBoundsSpecial         = Statistics.ConfidenceInterval(ConfidenceLevel, SegmentCounter / 2);

        ConfidenceIntervals             = [Power * ConfidenceBounds(1) Power * ConfidenceBounds(2)];
        ConfidenceIntervals([1 end], :) = [Power(1)   * ConfidenceBoundsSpecial(1) Power(1)   * ConfidenceBoundsSpecial(2);
                                           Power(end) * ConfidenceBoundsSpecial(1) Power(end) * ConfidenceBoundsSpecial(2)];
    end
                                   
end