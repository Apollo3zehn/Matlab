clc
clear
close all

%%

% Mann
% ----
%
Data                        = TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\ByMatlab\Mann_Seed_01_V_100.wnd');
% Data                        = TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\Mann Test Windfeld\mann_1L.wnd');
% Data                        = TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\Mann Test Windfeld\mann.wnd');
LongitudinalTurbulenceScale = min(42, 0.70 * 130);
Data.xLengthScale_u         = 8.10 * LongitudinalTurbulenceScale;
Data.xLengthScale_v         = 2.70 * LongitudinalTurbulenceScale;
Data.xLengthScale_w         = 0.66 * LongitudinalTurbulenceScale;

% Kaimal
% ------
%
%Data                    = TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\ByMatlab\Kaimal_Seed_01_V_050.wnd');
%Data                    = TurbulentWindField.Data.ReadWnd('C:\Users\vwilms\Desktop\ByMatlab\Kaimal_Seed_01_V_110_2_optim.wnd');
% Data                    = TurbulentWindField.Data.ReadWnd('C:\Users\Vincent\Desktop\1-Data\Bladed\ByMatlab\Kaimal_Seed_01_V_100.wnd');

% Karman
% ------
%
% Data                    = TurbulentWindField.Data.ReadWnd('M:\Data Analysis\Testumgebung_VWI\1-Data\Bladed\ByMatlab\ImprovedVonKarman_Seed_01_V_104.wnd');

%% PSD

WindowWidth             = 256;

WindField_Size          = size(Data.WindField);

Data_1                  = squeeze(permute(Data.WindField(:, :, :, 1), [3 1 2 4]));
Data_2                 	= squeeze(permute(Data.WindField(:, :, :, 2), [3 1 2 4]));
Data_3                  = squeeze(permute(Data.WindField(:, :, :, 3), [3 1 2 4]));

SamplingFrequency       = (Data.FftLength - 1) * Data.MeanWindSpeed / Data.FftLength / Data.dx;
[PSD_u, Frequency, ~] 	= SpectralAnalysis.WelchPowerSpectralDensity(Data_1(:), [], SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, []); 
[PSD_v, ~, ~]           = SpectralAnalysis.WelchPowerSpectralDensity(Data_2(:), [], SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, []); 
[PSD_w, ~, ~]           = SpectralAnalysis.WelchPowerSpectralDensity(Data_3(:), [], SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, []); 

switch Data.ID

    case 4 % Improved von Karman
        HubHeight           = 130;
        KarmanConstant      = 0.4;
        EarthAngularSpeed  	= 72.92115E-06;
        CoriolisParameter  	= 2*EarthAngularSpeed * sind(abs(Data.Latitude));
        u_star            	= (KarmanConstant * Data.MeanWindSpeed - 34.5 * CoriolisParameter * HubHeight) / log(HubHeight / Data.RoughnessLength);
        BoundaryLayerHeight = u_star / (6 * CoriolisParameter);  
        PSD_Ref             = TurbulentWindField.Spectrum.ImprovedVonKarman(Data.MeanWindSpeed, Frequency, HubHeight, BoundaryLayerHeight, Data.xLengthScale_u, Data.xLengthScale_v, Data.xLengthScale_w);

    case 7 % Kaimal
        PSD_Ref             = TurbulentWindField.Spectrum.Kaimal(Data.MeanWindSpeed, Frequency, Data.xLengthScale_u, Data.xLengthScale_v, Data.xLengthScale_w);

    case 8 % Mann
        if Math.Round(Data.Gamma, -2, Math.RoundNearest) ~= 3.90
            warning('Reference Kaimal spectrum may not fit to the simulated Mann wind field. To fit the Kaimal spectrum it is required that Gamma = 3.9, but Gamma = %f.', Data.Gamma)
        end
        
        PSD_Ref             = TurbulentWindField.Spectrum.Kaimal(Data.MeanWindSpeed, Frequency, Data.xLengthScale_u, Data.xLengthScale_v, Data.xLengthScale_w);
    
    otherwise
        error('Model not implemented.')
        
end

% Plot

subplot(3, 1, 1)
semilogy(Frequency, flipdim(PSD_u, 1), 'LineWidth', 2)
hold on
semilogy(Frequency, PSD_Ref(1, :), 'k--', 'LineWidth', 2)
hold off
%ylabel('Wind speed (m/(s*Hz))')
title('Longitudinal Spectrum')
xlim([0 SamplingFrequency / 2])
ylim([1e-2 1e2])

subplot(3, 1, 2)
semilogy(Frequency, flipdim(PSD_v, 1), 'LineWidth', 2)
hold on
semilogy(Frequency, PSD_Ref(2, :), 'k--', 'LineWidth', 2)
hold off
ylabel('Power Spectral Density')
title('Lateral Spectrum')
xlim([0 SamplingFrequency / 2])
ylim([1e-2 1e2])

subplot(3, 1, 3)
semilogy(Frequency, flipdim(PSD_w, 1), 'LineWidth', 2)
hold on
semilogy(Frequency, PSD_Ref(3, :), 'k--', 'LineWidth', 2)
hold off
xlabel('Frequency (Hz)')
%ylabel('Wind speed (m/(s*Hz))')
title('Vertical Spectrum')
xlim([0 SamplingFrequency / 2])
ylim([1e-2 1e2])

%% Statistics

df = Data.MeanWindSpeed / Data.FftLength / Data.dx;

switch Data.ID

    case 4 % Improved von Karman
        
        error('Model not implemented.')

    case 7 % Kaimal
        
        % Dick Veldkamp S. 282
        ds_u = 1 - (1 + 3 * df * Data.xLengthScale_u / Data.MeanWindSpeed)^(-2/3) + (1 + 3*(Data.FftLength + 1) * df * Data.xLengthScale_u / Data.MeanWindSpeed)^(-2/3);
        ds_u = sqrt(1 - ds_u);
        ds_v = 1 - (1 + 3 * df * Data.xLengthScale_v / Data.MeanWindSpeed)^(-2/3) + (1 + 3*(Data.FftLength + 1) * df * Data.xLengthScale_v / Data.MeanWindSpeed)^(-2/3);
        ds_v = sqrt(1 - ds_v);
        ds_w = 1 - (1 + 3 * df * Data.xLengthScale_w / Data.MeanWindSpeed)^(-2/3) + (1 + 3*(Data.FftLength + 1) * df * Data.xLengthScale_w / Data.MeanWindSpeed)^(-2/3);
        ds_w = sqrt(1 - ds_w);

    case 8 % Mann
        
        error('Model not implemented.')
    
    otherwise
        
        error('Model not implemented.')
        
end

fprintf('Mean u-component: %.4f m/s\n', mean(Data_1(:)))
fprintf('Mean v-component: %.4f m/s\n', mean(Data_2(:)))
fprintf('Mean w-component: %.4f m/s\n', mean(Data_3(:)))
fprintf('\n')
fprintf('Min/Max u-component: %.4f / %.4f m/s\n', min(Data_1(:)), max(Data_1(:)))
fprintf('Min/Max v-component: %.4f / %.4f m/s\n', min(Data_2(:)), max(Data_2(:)))
fprintf('Min/Max w-component: %.4f / %.4f m/s\n', min(Data_3(:)), max(Data_3(:)))
fprintf('\n')
fprintf('Ideal Std u-component: %.4f m/s\n', ds_u)
fprintf('Ideal Std v-component: %.4f m/s\n', ds_v)
fprintf('Ideal Std w-component: %.4f m/s\n', ds_w)
fprintf('\n')
fprintf('Std u-component: %.4f m/s\n', mean(mean(std(Data_1, [], 1))))
fprintf('Std v-component: %.4f m/s\n', mean(mean(std(Data_2, [], 1))))
fprintf('Std w-component: %.4f m/s\n', mean(mean(std(Data_3, [], 1))))

%% Coherence

figure

WindowWidth             = 64;
FrequencySet            = SamplingFrequency / 2 * linspace(0, 1, WindowWidth / 2 + 1); 

switch Data.ID

    case 4 % Improved von Karman
        
        error('Model not implemented.')

    case 7 % Kaimal
        
        Coherence_Ideal_uy      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
        Coherence_Ideal_uz      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
        Coherence_Ideal_vy      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
        Coherence_Ideal_vz      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
        Coherence_Ideal_wy      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');
        Coherence_Ideal_wz      = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');

    case 8 % Mann
        
        if Math.Round(Data.Gamma, -2, Math.RoundNearest) ~= 3.90
            warning('Reference Kaimal spectrum may not fit to the simulated Mann wind field. To fit the Kaimal spectrum it is required that Gamma = 3.9, but Gamma = %f.', Data.Gamma)
        end
        
        Coherence_Ideal_uy  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
        Coherence_Ideal_uz  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
        Coherence_Ideal_vy  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
        Coherence_Ideal_vz  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
        Coherence_Ideal_wy  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dy, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');
        Coherence_Ideal_wz  = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, Data.dz, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');
    
    otherwise
        
        error('Model not implemented.')
        
end
        
Coherence_uy        	= zeros(WindowWidth / 2 + 1, 1);
Coherence_uz        	= zeros(WindowWidth / 2 + 1, 1);
Coherence_vy         	= zeros(WindowWidth / 2 + 1, 1);
Coherence_vz         	= zeros(WindowWidth / 2 + 1, 1);
Coherence_wy         	= zeros(WindowWidth / 2 + 1, 1);
Coherence_wz         	= zeros(WindowWidth / 2 + 1, 1);

% u y
for i = 1 : Data.Ny - 1      
    for j = 1 : Data.Nz 
        Coherence_uy    = Coherence_uy + SpectralAnalysis.Coherence(Data_1(:, i, j), Data_1(:, i + 1,  j), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_uy = Coherence_uy / ((Data.Ny - 1) * Data.Nz);

% u z
for i = 1 : Data.Ny     
    for j = 1 : Data.Nz - 1
        Coherence_uz    = Coherence_uz + SpectralAnalysis.Coherence(Data_1(:, i, j), Data_1(:, i,  j + 1), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_uz = Coherence_uz / (Data.Ny * (Data.Nz - 1));

% v y
for i = 1 : Data.Ny - 1      
    for j = 1 : Data.Nz 
        Coherence_vy    = Coherence_vy + SpectralAnalysis.Coherence(Data_2(:, i, j), Data_2(:, i + 1,  j), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_vy = Coherence_vy / ((Data.Ny - 1) * Data.Nz);

% v z
for i = 1 : Data.Ny     
    for j = 1 : Data.Nz - 1
        Coherence_vz    = Coherence_vz + SpectralAnalysis.Coherence(Data_2(:, i, j), Data_2(:, i,  j + 1), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_vz = Coherence_vz / (Data.Ny * (Data.Nz - 1));

% w y
for i = 1 : Data.Ny - 1      
    for j = 1 : Data.Nz 
        Coherence_wy    = Coherence_wy + SpectralAnalysis.Coherence(Data_3(:, i, j), Data_3(:, i + 1,  j), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_wy = Coherence_wy / ((Data.Ny - 1) * Data.Nz);

% w z
for i = 1 : Data.Ny     
    for j = 1 : Data.Nz - 1
        Coherence_wz    = Coherence_wz + SpectralAnalysis.Coherence(Data_3(:, i, j), Data_3(:, i,  j + 1), SpectralAnalysis.WindowFunction.Hann(WindowWidth), 0.5, SamplingFrequency, 'Welch', false);    
    end
end

Coherence_wz = Coherence_wz / (Data.Ny * (Data.Nz - 1));

% Plot

% plot(FrequencySet, Coherence_uy, 'k')
% hold on  
% plot(FrequencySet, Coherence_Ideal_uy)
% ylim([0 1])
% xlim([0 SamplingFrequency / 2])
% xlabel('Frequency (u-component) in Hz')
% ylabel('Coherence (y-direction)')
% pbaspect([3 1 1])
% grid on

subplot(2, 3, 1)
plot(FrequencySet, Coherence_uy, 'k')
hold on  
plot(FrequencySet, Coherence_Ideal_uy)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence u-y')
grid on

subplot(2, 3, 4)
plot(FrequencySet, Coherence_uz, 'k')
hold on  
plot(FrequencySet, Coherence_Ideal_uz)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence u-z')
grid on

subplot(2, 3, 2)
plot(FrequencySet, Coherence_vy, 'k')
hold on  
plot(FrequencySet, Coherence_Ideal_vy)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence v-y')
grid on

subplot(2, 3, 5)
plot(FrequencySet, Coherence_vz, 'k')
hold on  
loglog(FrequencySet, Coherence_Ideal_vz)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence v-z')
grid on

subplot(2, 3, 3)
plot(FrequencySet, Coherence_wy, 'k')
hold on  
plot(FrequencySet, Coherence_Ideal_wy)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence w-y')
grid on

subplot(2, 3, 6)
plot(FrequencySet, Coherence_wz, 'k')
hold on  
plot(FrequencySet, Coherence_Ideal_wz)
ylim([0 1])
xlim([0 SamplingFrequency / 2])
ylabel('Coherence w-z')
grid on

%% Ideal Coherence 3D

figure

% u y
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Ny) * Data.dy;
Coherence3Duy               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 1)
surf(FrequencySet, DistanceSet, Coherence3Duy, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of u-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)

% u z
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Nz) * Data.dz;
Coherence3Duz               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'u');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 4)
surf(FrequencySet, DistanceSet, Coherence3Duz, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of u-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)

% v y
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Ny) * Data.dy;
Coherence3Dvy               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 2)
surf(FrequencySet, DistanceSet, Coherence3Dvy, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of v-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)

% v z
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Nz) * Data.dz;
Coherence3Dvz               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'v');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 5)
surf(FrequencySet, DistanceSet, Coherence3Dvz, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of v-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)

% w y
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Ny) * Data.dy;
Coherence3Dwy               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 3)
surf(FrequencySet, DistanceSet, Coherence3Dwy, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of w-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)

% w z
FrequencySet                = SamplingFrequency / 2 * linspace(0, 1, Data.FftLength / 2 + 1); 
DistanceSet                 = (0 : Data.Nz) * Data.dz;
Coherence3Dwz               = TurbulentWindField.Coherence.Kaimal(Data.MeanWindSpeed, FrequencySet, DistanceSet, Data.CoherenceDecay, Data.CoherenceLengthScale, 'w');
[FrequencySet, DistanceSet] = ndgrid(FrequencySet, DistanceSet);

subplot(2, 3, 6)
surf(FrequencySet, DistanceSet, Coherence3Dwz, 'EdgeColor', 'none', 'LineStyle', 'none', 'FaceLighting', 'phong');
xlabel('Frequency (Hz) of w-component')
ylabel('Distance (m) in x-direction')
xlim([0 SamplingFrequency / 2])
ylim([0 200])
view(2)