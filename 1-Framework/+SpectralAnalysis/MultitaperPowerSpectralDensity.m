function [Power, Frequency, ConfidenceIntervals] = MultitaperPowerSpectralDensity(Data1, Data2, HalfTimeBandWidthProduct, AveragingMethod, SamplingFrequency, ConfidenceLevel)
  
    %% Description missing
    
    %% Preparation
    
    Data1           = Data1(:);
    Data2           = Data2(:);
    DataLength      = numel(Data1);
    FftLength    = 2^nextpow2(DataLength);
    
    %% DataTaper (DPSS - Discrete Prolate Spheroidal Sequences) and Concentration of DPSS
 
    if HalfTimeBandWidthProduct < 1.25
        error('Insufficient Time-Bandwidth product.');
    end 
    
    [DataTaper, Concentration] = LinearAlgebra.DiscreteProlateSpheroidalSequences(DataLength, HalfTimeBandWidthProduct); 
    
    TaperCount = numel(Concentration);
    
    if TaperCount > 2
       DataTaper        = DataTaper(:, 1 : TaperCount-1);
       Concentration    = Concentration(1 : TaperCount-1);
    else
       error('Too few number of tapers.');
    end

    TaperCount = numel(Concentration);
    
    %% Thomson Multitaper Method 
        
    if isempty(Data2)
        SpectralEstimates = abs(fft(DataTaper .* repmat(Data1, 1, TaperCount), FftLength)).^2;
    else
        SpectralEstimates = abs(fft(DataTaper .* repmat(Data1, 1, TaperCount), FftLength) .* ...
                                conj(fft(DataTaper .* repmat(Data2, 1, TaperCount), FftLength)));
    end
    
    switch AveragingMethod

    case 'Adaptive'

        Power             	= Data1' * Data1 / DataLength; 
        NewSpectralEstimate = (SpectralEstimates(:,1) + SpectralEstimates(:,2)) / 2;
        OldSpectralEstimate = 0;

        Concentration       = Concentration.';
        Tolerance           = 0.0005 * Power;
        a                	= Power * (1 - Concentration);
        b                   = repmat(Concentration, FftLength, 1);

        while sum(abs(NewSpectralEstimate - OldSpectralEstimate)) > Tolerance

            Weight  = repmat(NewSpectralEstimate, 1, TaperCount) ./ (NewSpectralEstimate * Concentration + repmat(a, FftLength, 1)); 
            Weight  = Weight.^2 .* b;
            
            OldSpectralEstimate = NewSpectralEstimate;
            NewSpectralEstimate = (sum(Weight' .* SpectralEstimates') ./ sum(Weight, 2)')';
            
        end
        
    case {'Unity'}
       NewSpectralEstimate  = SpectralEstimates * ones(TaperCount,1) / TaperCount;
    case {'Concentration'}
       NewSpectralEstimate  = SpectralEstimates * Concentration(:) / TaperCount;
    otherwise
       error('The specified averaging method cannot be found.') 
    end
    
    Power                   = NewSpectralEstimate(1 : end / 2 + 1) / SamplingFrequency;
    Power(2 : end - 1)  	= Power(2 : end - 1) * 2;
    
    Frequency             	= SamplingFrequency / 2 * linspace(0, 1, FftLength / 2 + 1).';
    
    %% Confidence Intervals
    
    ConfidenceIntervals   	= [];
    
    if ~isempty(ConfidenceLevel)    
        ConfidenceBounds  	= Statistics.ConfidenceInterval(ConfidenceLevel, TaperCount);
        ConfidenceIntervals = [Power * ConfidenceBounds(1) Power * ConfidenceBounds(2)];    
    end
    
end