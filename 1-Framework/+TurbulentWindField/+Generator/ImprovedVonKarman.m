function OutputData = ImprovedVonKarman(MeanWindSpeed, Seed, HubHeight, TurbulenceIntensity, Latitude, Duration, FftLength, GridWidth, Ny, GridHeight, Nz)
    %  Main sources: Bladed Theory Manual chapter "The improved von Karman model", ESDU 85020 and ESDU 86010

    % Frequency
    FrequencyStep               = 1 / Duration;
    FrequencySet                = (1 : FftLength) * FrequencyStep;
    FrequencySetCount           = numel(FrequencySet);
    
    % Misc
    CoordinateCount             = Ny * Nz;
    
    % Grid
    yCoordinates                = linspace(-GridWidth/2, GridWidth/2, Ny);
    zCoordinates                = linspace(-GridHeight/2, GridHeight/2, Nz);
       
    [Y, Z]                      = meshgrid(yCoordinates, zCoordinates + HubHeight);
    Y                           = Y';
    Z                           = Z';
    
    dx                          = Duration * MeanWindSpeed / FftLength;
    dy                          = GridWidth / (Ny - 1);
    dz                          = GridHeight / (Nz - 1);
                            
    Distances                   = LinearAlgebra.EuclideanDistanceMatrix([Y(:) Z(:)], [Y(:) Z(:)]);
        
    % RoughnessLength
    EarthAngularSpeed           = 72.92115E-06;
    CoriolisParameter           = 2*EarthAngularSpeed * sind(abs(Latitude));
    RoughnessLength             = WindHelper.TurbulenceIntensityToRoughnessLength(TurbulenceIntensity, CoriolisParameter, MeanWindSpeed, HubHeight);
    
    % Sigma_u
    KarmanConstant            	= 0.4;
    u_star                      = (KarmanConstant * MeanWindSpeed - 34.5 * CoriolisParameter * HubHeight) / log(HubHeight / RoughnessLength);
    eta                         = 1 - 6 * CoriolisParameter * HubHeight / u_star;
    p                           = eta^16;
    Sigma_u                     = (7.5 * eta * (0.538 + 0.09 * log(HubHeight / RoughnessLength))^p * u_star) / ...
                                  (1.0 + 0.156 * log(u_star / (CoriolisParameter * RoughnessLength)));

    % BoundaryLayerHeight
    BoundaryLayerHeight        	= u_star / (6 * CoriolisParameter);  

    % TurbulenceIntensity
    TurbulenceIntensity_u       = Sigma_u / MeanWindSpeed * 100;
    TurbulenceIntensity_v       = TurbulenceIntensity_u * (1 - 0.22 * cos(pi * HubHeight / (2*BoundaryLayerHeight))^4);
    TurbulenceIntensity_w       = TurbulenceIntensity_u * (1 - 0.45 * cos(pi * HubHeight / (2*BoundaryLayerHeight))^4);
    Sigma_v                     = TurbulenceIntensity_v / 100 * MeanWindSpeed;
    Sigma_w                     = TurbulenceIntensity_w / 100 * MeanWindSpeed;

    % Calculation of the surface Rossby number Ro and Kolmogorov parameter K_z; z = Height above ground
    Ro                          = u_star / (CoriolisParameter * RoughnessLength);
    N                           = 1.24 * Ro^.008;
    B                           = 24.0 * Ro^0.155;
    K_0                         = 0.39 / Ro^0.11;
    K_z                         = 0.19 - (0.19 - K_0) * exp(-B * (HubHeight / BoundaryLayerHeight)^N);
    
    % xLengthScale_u (ESDU 85020, p.22 & p.33 / ESDU 86010, p.10)
    A                       	= 0.115 * (1 + 0.315 * (1 - HubHeight / BoundaryLayerHeight)^6)^(2/3);
    xLengthScale_u              = (A^(3/2) * (Sigma_u / u_star)^3 * HubHeight) / ...
                                  (2.5 * K_z^(3/2) * (1 - HubHeight / BoundaryLayerHeight)^2 * (1 + 5.75 * HubHeight / BoundaryLayerHeight));
    
    yLengthScale_u              = (1.0 - 0.46 * exp(-35*(HubHeight / BoundaryLayerHeight)^1.7)) * xLengthScale_u / 2;
    zLengthScale_u              = (1.0 - 0.68 * exp(-35*(HubHeight / BoundaryLayerHeight)^1.7)) * xLengthScale_u / 2;
    
    xLengthScale_v              = (Sigma_v / Sigma_u)^3 * xLengthScale_u / 2;
    xLengthScale_w              = (Sigma_w / Sigma_u)^3 * xLengthScale_u / 2;
    
    yLengthScale_v              = 2*yLengthScale_u * (Sigma_v/Sigma_u)^3;
    zLengthScale_w              = 2*zLengthScale_u * (Sigma_w/Sigma_u)^3;
    
    zLengthScale_v             	= zLengthScale_u * (Sigma_v/Sigma_u)^3;
    yLengthScale_w              = yLengthScale_u * (Sigma_w/Sigma_u)^3;
      
    % Power spectral density (divided by variance) 
    % and conversion from specific wind speed in m²/(s²*Hz) to absolute
    % wind speed in m/s from one-sided spectrum to two-sided spectrum
    PowerSpectralDensity        = TurbulentWindField.Spectrum.ImprovedVonKarman(MeanWindSpeed, FrequencySet, HubHeight, BoundaryLayerHeight, ...
                                                                                xLengthScale_u, xLengthScale_v, xLengthScale_w) * FrequencyStep / 2;

    % Compound / Local length scales (ESDU 86010, p.11)
    L_u                         = sqrt((yLengthScale_u * dy)^2 + (zLengthScale_u * dz)^2) / sqrt(dy^2 + dz^2);
    L_v                         = sqrt((xLengthScale_v * dx)^2 + (zLengthScale_v * dz)^2) / sqrt(dx^2 + dz^2);
    L_w                         = sqrt((xLengthScale_w * dx)^2 + (yLengthScale_w * dy)^2) / sqrt(dx^2 + dy^2);             

    % Random phase
    rng(Seed, 'twister');
    Phase_u                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
    Phase_v                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
    Phase_w                     = exp(1i*2*pi * rand(CoordinateCount, FftLength / 2));
          
    % Coherence and spectrum calculation (Sandia Method?) (ESDU 86010, p.14)
    dr_2L_u                     = Distances / (2*L_u);
    dr_2L_v                     = Distances / (2*L_v);
    dr_2L_w                     = Distances / (2*L_w);
    
    b_u                         = 0.35 .* dr_2L_u .^0.2;
    b_v                         = 0.35 .* dr_2L_v .^0.2;
    b_w                         = 0.35 .* dr_2L_w .^0.2;
    
    WaveNumberSet               = 2*pi*(FrequencySet / MeanWindSpeed);
    
    ComplexSpectrum_u           = zeros(size(Phase_u));
    ComplexSpectrum_v           = zeros(size(Phase_v));
    ComplexSpectrum_w           = zeros(size(Phase_w));
    
    for Index = 1 : FrequencySetCount

        fprintf('%d of %d ...', Index, FrequencySetCount)
        
        % Calculation of eta
        eta_0                       = sqrt((0.747 * dr_2L_u).^2 + (WaveNumberSet(Index) * Distances).^2 );
        c_u                         = max(1.0, 1.6 * dr_2L_u.^0.13 ./ (eta_0.^(b_u)));
        eta_u                       = sqrt((0.747 * dr_2L_u).^2 + (c_u .* WaveNumberSet(Index) .* Distances).^2);
        
        eta_0                       = sqrt((0.747 * dr_2L_v).^2 + (WaveNumberSet(Index) * Distances).^2 );
        c_v                         = max(1.0, 1.6 * dr_2L_v.^0.13 ./ (eta_0.^(b_v)));
        eta_v                       = sqrt((0.747 * dr_2L_v).^2 + (c_v .* WaveNumberSet(Index) .* Distances).^2);
        
        eta_0                       = sqrt((0.747 * dr_2L_w).^2 + (WaveNumberSet(Index) * Distances).^2 );
        c_w                         = max(1.0, 1.6 * dr_2L_w.^0.13 ./ (eta_0.^(b_w)));
        eta_w                       = sqrt((0.747 * dr_2L_w).^2 + (c_w .* WaveNumberSet(Index) .* Distances).^2);
        
        % Square root of coherence: ESDU 86010, p. 21 (Approximation to avoid Bessel)
        RootCoherence_u             = exp(-1.15 * eta_u.^1.5);
        RootCoherence_v           	= exp(-0.65 * eta_v.^1.3);
        RootCoherence_w           	= exp(-0.65 * eta_w.^1.3);
        
        % |Sxx(f)| = Coherence(f) * sqrt(Sxx(f) * Syy(f)) = Coherence * PowerSpectralDensity
        CrossPowerSpectralDensity_u = RootCoherence_u.^2 .* PowerSpectralDensity(1, Index);
        CrossPowerSpectralDensity_v = RootCoherence_v.^2 .* PowerSpectralDensity(2, Index);
        CrossPowerSpectralDensity_w	= RootCoherence_w.^2 .* PowerSpectralDensity(3, Index);
        
        % Cholesky factorization
        % see: http://blogs.sas.com/content/iml/2012/02/08/use-the-cholesky-transformation-to-correlate-and-uncorrelate-variables/
        RealSpectrum_u              = chol(CrossPowerSpectralDensity_u, 'lower');
        RealSpectrum_v              = chol(CrossPowerSpectralDensity_v, 'lower');
        RealSpectrum_w              = chol(CrossPowerSpectralDensity_w, 'lower');
        
        ComplexSpectrum_u(:, Index)	= RealSpectrum_u * Phase_u(:, Index);
        ComplexSpectrum_v(:, Index)	= RealSpectrum_v * Phase_v(:, Index);
        ComplexSpectrum_w(:, Index)	= RealSpectrum_w * Phase_w(:, Index);

        fprintf(' Done.\n')
        
    end
    
    % Create two-sided spectrum
    ComplexSpectrum_u               = [zeros(CoordinateCount,1) ComplexSpectrum_u fliplr(conj(ComplexSpectrum_u(:, 1 : end-1)))];
    ComplexSpectrum_u(:, FftLength/2 + 1) = real(ComplexSpectrum_u(:, FftLength/2 + 1));
    
    ComplexSpectrum_v               = [zeros(CoordinateCount,1) ComplexSpectrum_v fliplr(conj(ComplexSpectrum_v(:, 1 : end-1)))];
    ComplexSpectrum_v(:, FftLength/2 + 1) = real(ComplexSpectrum_v(:, FftLength/2 + 1));
    
    ComplexSpectrum_w               = [zeros(CoordinateCount,1) ComplexSpectrum_w fliplr(conj(ComplexSpectrum_w(:, 1 : end-1)))];
    ComplexSpectrum_w(:, FftLength/2 + 1) = real(ComplexSpectrum_w(:, FftLength/2 + 1));
        
    % Inverse Fourier Transform
    WindField(:, :, 1)              = real(fft(ComplexSpectrum_u, [], 2));
    WindField(:, :, 2)              = real(fft(ComplexSpectrum_v, [], 2));
    WindField(:, :, 3)              = real(fft(ComplexSpectrum_w, [], 2));

    % Create 4D Matrix
    WindField                       = reshape(WindField, Ny, Nz, [], 3);
    
    %% Create structure with necessary fields for Bladed
       
    % For all Spectra
    OutputData.ID                   = 4;
    OutputData.Format               = -99;
    OutputData.ComponentCount       = 3;
    OutputData.Unused               = 0;   
    OutputData.Seed                 = Seed;
    OutputData.FftLength            = FftLength;
    OutputData.MeanWindSpeed        = MeanWindSpeed;
    OutputData.WindField            = WindField;
    
    OutputData.dx                   = dx;
    OutputData.dy                   = dy;
    OutputData.dz                   = dz;
    OutputData.Ny                   = Ny;
    OutputData.Nz                   = Nz;
      
    OutputData.xLengthScale_u       = xLengthScale_u;
    OutputData.xLengthScale_v       = xLengthScale_v;
    OutputData.xLengthScale_w       = xLengthScale_w;
    OutputData.yLengthScale_u       = yLengthScale_u;
    OutputData.yLengthScale_v       = yLengthScale_v;
    OutputData.yLengthScale_w       = yLengthScale_w;
    OutputData.zLengthScale_u       = zLengthScale_u;    
    OutputData.zLengthScale_v       = zLengthScale_v;    
    OutputData.zLengthScale_w       = zLengthScale_w;
    
    % For Improved von Karman Model
    OutputData.Latitude                 = Latitude;
    OutputData.RoughnessLength          = RoughnessLength;
    OutputData.HubHeight                = HubHeight;
    OutputData.TurbulenceIntensity_u    = TurbulenceIntensity_u;
    OutputData.TurbulenceIntensity_v    = TurbulenceIntensity_v; 
    OutputData.TurbulenceIntensity_w    = TurbulenceIntensity_w;
    
end