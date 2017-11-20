function OutputData = Mann(MeanWindSpeed, Seed, HubHeight, Duration, Nx, GridWidth, Ny, GridHeight, Nz)
    % IEC 61400-1 Ed. 3: 6.3, 6.3.1.2, 6.3.1.3 and B.1 / Mann p. 276
        
    % Grid
    GridLength                  = MeanWindSpeed * Duration;
    dx                          = GridLength / (Nx - 1);
    dy                          = GridWidth  / (Ny - 1);
    dz                          = GridHeight / (Nz - 1);  
        
    % Additional parameters   
    LongitudinalTurbulenceScale = min(42, 0.70 * HubHeight);
    Gamma                       = 3.9;
    ScaleParameter              = 0.80 * LongitudinalTurbulenceScale;
    
    % Two-sided wave number vector
    [m_x, m_y, m_z]             = ndgrid([0 : Nx/2, -Nx/2+1 : -1], ...
                                         [0 : Ny/2, -Ny/2+1 : -1], ...
                                         [0 : Nz/2, -Nz/2+1 : -1]);

 	k_1                         = 2*pi * m_x / GridLength * ScaleParameter;
    k_2                         = 2*pi * m_y / GridWidth  * ScaleParameter;
    k_3                         = 2*pi * m_z / GridHeight * ScaleParameter;
    
    % Additional parameters
    k_abs                       = sqrt(k_1.^2 + k_2.^2 + k_3.^2);
    
    EddyLifeTime                = Gamma ./ (k_abs.^(2/3) .* sqrt(SpecialFunction.HyperGeometric2F1([1/3 17/6], 4/3, -k_abs.^-2)));
    EddyLifeTime(isnan(EddyLifeTime)) = 0;
    k_30                        = k_3 + EddyLifeTime .* k_1;    
	k_0_abs                     = sqrt(k_1.^2 + ...
                                       k_2.^2 + ...
                                       k_30.^2);
                                                                                                   
    C_1                        	= (EddyLifeTime .* k_1.^2 .* ...
                                  (k_0_abs.^2 - 2*k_30.^2 + EddyLifeTime .* k_1 .* k_30)) ./ ...
                                  (k_abs.^2 .* (k_1.^2 + k_2.^2));
                              
    C_2                        	= (k_2 .* k_0_abs.^2) ./ ...
                                  (k_1.^2 + k_2.^2).^(3/2) .* ...
                                   atan2((EddyLifeTime .* k_1 .* sqrt(k_1.^2 + k_2.^2)), ...
                                        (k_0_abs.^2 - k_30 .* k_1 .* EddyLifeTime));
    
    Zeta_1                      = C_1 - k_2 ./ k_1 .* C_2;
    Zeta_2                      = k_2 ./ k_1 .* C_1 + C_2;
    Zeta_3                      = k_0_abs.^2 ./ k_abs.^2;
    
    % Corrections according to http://vbn.aau.dk/files/18503179/TuGen p.7
    Indices                     = k_abs == 0;
    Zeta_1(Indices)             = 0;
    Zeta_2(Indices)             = 0;
    Zeta_3(Indices)             = 1;
    
    Indices                     = ~Indices & k_1 == 0;
    Zeta_1(Indices)             = -EddyLifeTime(Indices);
    Zeta_2(Indices)             = 0;
    Zeta_3(Indices)             = 1;
    
    % Energy Spectrum
    IsotropicEnergySpectrum_0   = (1.453 * k_0_abs.^4) ./ ...
                                  (1 + k_0_abs.^2).^(17/6);  
                              
    % Coefficient matrix (IEC B.13 / Mann p. 278, equation 46)
    RealSpectrum                = zeros(3, 3, Nx, Ny, Nz);
    
    a                           = sqrt((2*pi^2 * ScaleParameter.^3 * IsotropicEnergySpectrum_0) ./ ...
                                       (GridLength * GridWidth * GridHeight * k_0_abs.^4));

	RealSpectrum(1, 1, :, :, :)	= a .* ( k_2 .* Zeta_1);
    RealSpectrum(1, 2, :, :, :)	= a .* ( k_3 - k_1 .* Zeta_1 + EddyLifeTime .* k_1);
    RealSpectrum(1, 3, :, :, :)	= a .* (-k_2);
        
    RealSpectrum(2, 1, :, :, :)	= a .* (-k_3 + k_2 .* Zeta_2 - EddyLifeTime .* k_1);
    RealSpectrum(2, 2, :, :, :)	= a .* (-k_1 .* Zeta_2);
    RealSpectrum(2, 3, :, :, :)	= a .* ( k_1);
    
    RealSpectrum(3, 1, :, :, :)	= a .* ( k_2 .* Zeta_3);
    RealSpectrum(3, 2, :, :, :)	= a .* (-k_1 .* Zeta_3);
    RealSpectrum(3, 3, :, :, :)	= a .* ( 0);
    
    RealSpectrum(isnan(RealSpectrum)) = 0; % Correct?
       
    %
    
%     SpectralTensor                  = zeros(3, 3, Nx, Ny, Nz);
%     
%     a1                              = IsotropicEnergySpectrum_0 ./ (4*pi * k_0_abs.^4);
%     a2                              = IsotropicEnergySpectrum_0 ./ (4*pi * k_abs.^4);
%     a3                              = IsotropicEnergySpectrum_0 ./ (4*pi * k_0_abs.^2 .* k_abs.^2);
% 
%     SpectralTensor(1, 1, :, :, :)	= a1 .* ( k_0_abs.^2 - k_1.^2 - 2*k_1 .* k_30 .* Zeta_1 + (k_1.^2 + k_2.^2) .* Zeta_1.^2);
%     SpectralTensor(2, 2, :, :, :)	= a1 .* ( k_0_abs.^2 - k_2.^2 - 2*k_2 .* k_30 .* Zeta_2 + (k_1.^2 + k_2.^2) .* Zeta_2.^2);
%     SpectralTensor(3, 3, :, :, :)	= a2 .* ( k_1.^2 + k_2.^2);
% 
%     SpectralTensor(1, 2, :, :, :)	= a1 .* (-k_1 .* k_2 - k_1 .* k_30 .* Zeta_2 - k_2 .* k_30 .* Zeta_1 + (k_1.^2 + k_2.^2) .* Zeta_1 .* Zeta_2);
%     SpectralTensor(1, 3, :, :, :)	= a3 .* (-k_1 .* k_30 + (k_1.^2 + k_2.^2) .* Zeta_1);
%     SpectralTensor(2, 3, :, :, :)	= a3 .* (-k_2 .* k_30 + (k_1.^2 + k_2.^2) .* Zeta_2);
% 
%     SpectralTensor(2, 1, :, :, :)	= conj(SpectralTensor(1, 2, :, :, :));
%     SpectralTensor(3, 1, :, :, :)	= conj(SpectralTensor(1, 3, :, :, :));
%     SpectralTensor(3, 2, :, :, :)	= conj(SpectralTensor(2, 3, :, :, :));
%     
%     SpectralTensor(isnan(SpectralTensor)) = 0;
%     
%     dk_1                            = 2*pi / GridLength * ScaleParameter;
%     dk_2                            = 2*pi / GridWidth  * ScaleParameter;
%     dk_3                            = 2*pi / GridHeight * ScaleParameter;
%     
%     for i = 1 : 3
%         for j = 1 : 3
%             RealSpectrum(i, j, :, :, :) = SpectralTensor(i, j, :, :, :)                                                         .* dk_1;
%             %RealSpectrum(i, j, :, :, :) = cat(3, zeros(1, 1, 1, Ny, Nz), diff(cumtrapz(SpectralTensor(i, j, :, :, :), 3), [], 3)) .* dk_1;
%             RealSpectrum(i, j, :, :, :) = cat(4, zeros(1, 1, Nx, 1, Nz), diff(cumtrapz(RealSpectrum(i, j, :, :, :), 4), [], 4)) .* dk_2;
%             RealSpectrum(i, j, :, :, :) = cat(5, zeros(1, 1, Nx, Ny, 1), diff(cumtrapz(RealSpectrum(i, j, :, :, :), 5), [], 5)) .* dk_3;
%         end
%     end
%     
%     for x = 1 : Nx
%         for y = 1 : Ny
%             for z = 1 : Nz
%                 try
%                     RealSpectrum(:, :, x, y, z) = chol(RealSpectrum(:, :, x, y, z));
%                 catch ex
%                     
%                 end
%             end
%         end
%         fprintf('x: %d\n', x)
%     end
    
    %
    
    % Phase
    rng(Seed, 'Twister')
    Phase                       = complex(SignalGeneration.RandomNormal(0, 1, [3 1 Nx Ny Nz]), ...
                                          SignalGeneration.RandomNormal(0, 1, [3 1 Nx Ny Nz]));
% 	Phase(:, :, 1, :, :)        = 0;
% 	Phase(:, :, :, 1, :)        = 0;
% 	Phase(:, :, :, :, 1)        = 0;
	Phase(:, :, 1, :, :)        = real(Phase(:, :, 1, :, :));
	Phase(:, :, :, 1, :)        = real(Phase(:, :, :, 1, :));
	Phase(:, :, :, :, 1)        = real(Phase(:, :, :, :, 1));
    Phase(:, :, Nx/2 + 1, :, :) = real(Phase(:, :, Nx/2 + 1, :, :));
    Phase(:, :, :, Ny/2 + 1, :) = real(Phase(:, :, :, Ny/2 + 1, :));
    Phase(:, :, :, :, Nz/2 + 1) = real(Phase(:, :, :, :, Nz/2 + 1));                                
    
    % IEC eq. B13: [C(k1, k2, k3)] * [n(k1, k2, k3)]
    ComplexSpectrum             = squeeze(permute(Matrix.Multiplication(RealSpectrum, Phase), [2 4 5 3 1]));
    
    % Create symmetric spectrum, 
    % -> If this step is skipped, the complex result represents two independent wind fields
%     ComplexSpectrum(Ny/2 + 2 : end, :, :, 1)  = flipdim(conj(ComplexSpectrum(2 : Ny/2, :, :, 1)), 1);
%     ComplexSpectrum(:, Nz/2 + 2 : end, :, 1)  = flipdim(conj(ComplexSpectrum(:, 2 : Nz/2, :, 1)), 2);
%     ComplexSpectrum(:, :, Nx/2 + 2 : end, 1)  = flipdim(conj(ComplexSpectrum(:, :, 2 : Nx/2, 1)), 3);
%     
%     ComplexSpectrum(Ny/2 + 2 : end, :, :, 2)  = flipdim(conj(ComplexSpectrum(2 : Ny/2, :, :, 2)), 1);
%     ComplexSpectrum(:, Nz/2 + 2 : end, :, 2)  = flipdim(conj(ComplexSpectrum(:, 2 : Nz/2, :, 2)), 2);
%     ComplexSpectrum(:, :, Nx/2 + 2 : end, 2)  = flipdim(conj(ComplexSpectrum(:, :, 2 : Nx/2, 2)), 3);
%     
%     ComplexSpectrum(Ny/2 + 2 : end, :, :, 3)  = flipdim(conj(ComplexSpectrum(2 : Ny/2, :, :, 3)), 1);
%     ComplexSpectrum(:, Nz/2 + 2 : end, :, 3)  = flipdim(conj(ComplexSpectrum(:, 2 : Nz/2, :, 3)), 2);
%     ComplexSpectrum(:, :, Nx/2 + 2 : end, 3)  = flipdim(conj(ComplexSpectrum(:, :, 2 : Nx/2, 3)), 3);
%         
    % Inverse Fourier Transform
    WindField                   = zeros(size(ComplexSpectrum));
%     WindField(:, :, :, 1)       = real(fftn(ComplexSpectrum(:, :, :, 1)));
%     WindField(:, :, :, 2)       = real(fftn(ComplexSpectrum(:, :, :, 2)));
%     WindField(:, :, :, 3)       = real(fftn(ComplexSpectrum(:, :, :, 3)));


% hier weitermachen, IEC gibt Formel vor
%     for k1 = 1 : size(k_1, 1)
%         for k2 = 1 : size(k_2, 2)
%             for k3 = 1 : size(k_3, 3)
%                 
%                WindField(k1, k2, k3, 1) = exp(1j*(k_1(k1, k2, k3) + k_2(k1, k2, k3) + k_3(k1, k2, k3)) / ScaleParameter) * ComplexSpectrum(k1, k2, k3, 1);
%                 
%             end
%         end
%     end

    %% Create structure with necessary fields for Bladed
       
    % For all Spectra
    OutputData.ID            	= 8;
    OutputData.Format         	= -99;
    OutputData.ComponentCount  	= 3;
    OutputData.Unused         	= 0;   
	OutputData.Seed            	= Seed;
    OutputData.FftLength       	= Nx;
    OutputData.MeanWindSpeed   	= MeanWindSpeed;
    OutputData.WindField       	= WindField;
    
    OutputData.dx           	= dx;
    OutputData.dy               = dy;
    OutputData.dz               = dz;
    OutputData.Ny               = Ny;
    OutputData.Nz               = Nz;
      
    OutputData.xLengthScale_u 	= 0;
    OutputData.xLengthScale_v  	= 0;
    OutputData.xLengthScale_w 	= 0;
    OutputData.yLengthScale_u  	= 0;
    OutputData.yLengthScale_v 	= 0;
    OutputData.yLengthScale_w  	= 0;
    OutputData.zLengthScale_u 	= 0;    
    OutputData.zLengthScale_v  	= 0;    
    OutputData.zLengthScale_w  	= 0;
    
    % For Mann Model
    OutputData.HeaderSize      	= 148;
    OutputData.Gamma            = Gamma;
    OutputData.ScaleParameter   = ScaleParameter;
    OutputData.LateralVerticalFftLength         = Ny; % for .wnd file
    OutputData.LateralTurbulenceIntensityRatio  = 0.7; % Muss richtig berechnet werden
    OutputData.VerticalTurbulenceIntensityRatio = 0.5; % Muss richtig berechnet werden
    OutputData.MaximumLateralWaveLength         = max(GridWidth, GridHeight); % for .wnd file
        
end

