function OutputData = Kaimal(MeanWindSpeed, Seed, HubHeight, Duration, FftLength, GridWidth, Ny, GridHeight, Nz, ReportProgress)
   
    %% Additional Settings
    
    % Frequency
    FrequencyStep               = 1 / Duration;
    FrequencySet                = (1 : FftLength / 2) * FrequencyStep;
    FrequencySetCount       	= numel(FrequencySet);
   
    % Misc
    CoordinateCount             = Ny * Nz;
    
    % Grid
    yCoordinates                = linspace(-GridWidth /2, GridWidth /2, Ny);
    zCoordinates                = linspace(-GridHeight/2, GridHeight/2, Nz);
    [Y, Z]                      = ndgrid(yCoordinates, zCoordinates + HubHeight);
    Y                           = Y';
    Z                           = Z';
    
    dx                          = Duration * MeanWindSpeed / FftLength;
    dy                          = GridWidth / (Ny - 1);
    dz                          = GridHeight / (Nz - 1);         
    
    Distances                   = LinearAlgebra.EuclideanDistanceMatrix([Y(:) Z(:)], [Y(:) Z(:)]);
               
    % Turbulent Length Scales according to IEC 2005
    LongitudinalTurbulenceScale = min(42, 0.70 * HubHeight);
    xLengthScale_u              = 8.10 * LongitudinalTurbulenceScale;
    xLengthScale_v              = 2.70 * LongitudinalTurbulenceScale;
    xLengthScale_w              = 0.66 * LongitudinalTurbulenceScale;
    
    % Coherency Parameters
    CoherenceLengthScale        = xLengthScale_u;
    CoherenceDecay              = 12;
           
    % Power spectral density (divided by variance) 
    % and conversion from specific wind speed in m²/(s²*Hz) to absolute
    % wind speed in m²/s² from one-sided spectrum to the correct amplitude of
    % the later calculated two-sided spectrum
    PowerSpectralDensity        = TurbulentWindField.Spectrum.Kaimal(MeanWindSpeed, FrequencySet, ...
                                                                     xLengthScale_u, xLengthScale_v, xLengthScale_w) * FrequencyStep / 2;
        
    % Random phase
    rng(Seed, 'twister');
    Phase_u                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
    Phase_v                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
    Phase_w                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
      
    % Coherence and spectrum calculation (Sandia Method)
    ComplexSpectrum_u           = zeros(size(Phase_u));
    ComplexSpectrum_v           = zeros(size(Phase_v));
    ComplexSpectrum_w           = zeros(size(Phase_w));
        
    for Index = 1 : numel(FrequencySet)
        
        if ReportProgress
            fprintf('%d of %d ...', Index, FrequencySetCount)
        end
        
        Size                        = size(Distances);
        
        Coherence_u                 = reshape(TurbulentWindField.Coherence.Kaimal(MeanWindSpeed, FrequencySet(Index), Distances, CoherenceDecay, CoherenceLengthScale, 'u'), Size);
        Coherence_v                 = reshape(TurbulentWindField.Coherence.Kaimal(MeanWindSpeed, FrequencySet(Index), Distances, CoherenceDecay, CoherenceLengthScale, 'v'), Size);
        Coherence_w                 = reshape(TurbulentWindField.Coherence.Kaimal(MeanWindSpeed, FrequencySet(Index), Distances, CoherenceDecay, CoherenceLengthScale, 'w'), Size);
        
        % |Sxx(f)| = Coherence(f) * sqrt(Sxx(f) * Syy(f)) = Coherence * PowerSpectralDensity
        CrossPowerSpectralDensity_u = Coherence_u .* PowerSpectralDensity(1, Index);
        CrossPowerSpectralDensity_v = Coherence_v .* PowerSpectralDensity(2, Index);
        CrossPowerSpectralDensity_w	= Coherence_w .* PowerSpectralDensity(3, Index);
        
        % Cholesky factorization
        % see: http://blogs.sas.com/content/iml/2012/02/08/use-the-cholesky-transformation-to-correlate-and-uncorrelate-variables/
        RealSpectrum_u              = full(chol(sparse(CrossPowerSpectralDensity_u), 'lower'));
        RealSpectrum_v              = full(chol(sparse(CrossPowerSpectralDensity_v), 'lower'));
        RealSpectrum_w              = full(chol(sparse(CrossPowerSpectralDensity_w), 'lower'));
        
        ComplexSpectrum_u(:, Index)	= RealSpectrum_u * Phase_u(:, Index);
        ComplexSpectrum_v(:, Index)	= RealSpectrum_v * Phase_v(:, Index);
        ComplexSpectrum_w(:, Index)	= RealSpectrum_w * Phase_w(:, Index);
        
        if ReportProgress
            fprintf(' Done.\n')
        end
        
    end

    % Create two-sided spectrum
    ComplexSpectrum_u           = [zeros(CoordinateCount,1) ComplexSpectrum_u fliplr(conj(ComplexSpectrum_u(:, 1 : end-1)))];
    ComplexSpectrum_u(:, FftLength/2 + 1) = real(ComplexSpectrum_u(:, FftLength/2 + 1));
    
    ComplexSpectrum_v          	= [zeros(CoordinateCount,1) ComplexSpectrum_v fliplr(conj(ComplexSpectrum_v(:, 1 : end-1)))];
    ComplexSpectrum_v(:, FftLength/2 + 1) = real(ComplexSpectrum_v(:, FftLength/2 + 1));
    
    ComplexSpectrum_w           = [zeros(CoordinateCount,1) ComplexSpectrum_w fliplr(conj(ComplexSpectrum_w(:, 1 : end-1)))];
    ComplexSpectrum_w(:, FftLength/2 + 1) = real(ComplexSpectrum_w(:, FftLength/2 + 1));
        
    % Inverse Fourier Transform
    WindField(:, :, 1)          = real(fft(ComplexSpectrum_u, FftLength, 2));
    WindField(:, :, 2)          = real(fft(ComplexSpectrum_v, FftLength, 2));
    WindField(:, :, 3)          = real(fft(ComplexSpectrum_w, FftLength, 2));

    % Create 4D Matrix
    WindField                   = reshape(WindField, Ny, Nz, [], 3);
    
    %% Create structure with necessary fields for Bladed
    
    % For all Spectra
    OutputData.ID            	= 7;
    OutputData.Format         	= -99;
    OutputData.ComponentCount  	= 3;
    OutputData.Unused         	= 0;   
    OutputData.Seed            	= Seed;
    OutputData.FftLength       	= FftLength;
    OutputData.MeanWindSpeed   	= MeanWindSpeed;
    OutputData.WindField       	= WindField;
    
    OutputData.dx           	= dx;
    OutputData.dy               = dy; 
    OutputData.dz               = dz;
    OutputData.Ny               = Ny;
    OutputData.Nz               = Nz;   
    
    OutputData.xLengthScale_u 	= xLengthScale_u;
    OutputData.xLengthScale_v  	= xLengthScale_v;
    OutputData.xLengthScale_w 	= xLengthScale_w;
    OutputData.yLengthScale_u  	= 0;
    OutputData.yLengthScale_v 	= 0;
    OutputData.yLengthScale_w  	= 0;
    OutputData.zLengthScale_u 	= 0;    
    OutputData.zLengthScale_v  	= 0;    
    OutputData.zLengthScale_w  	= 0;
    
    % For Kaimal Model
    OutputData.HeaderSize      	= 92;
    OutputData.CoherenceDecay  	= CoherenceDecay;
    OutputData.CoherenceLengthScale = CoherenceLengthScale;   
    
end