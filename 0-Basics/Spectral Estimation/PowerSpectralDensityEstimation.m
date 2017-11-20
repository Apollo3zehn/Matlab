clc
clear
close all

%% Spectrum

Fs = 1000;   
t = 0 : 1/Fs : 10;  

x = zeros(1, numel(Fs));
for i = 1 : 20
    f       = round(rand(1)*Fs/2); 
    phi     = rand(1)*pi; 
    random  = 30*rand(size(t));
    x = x + rand(1)*10 * (cos(2*pi*f*t) + sin(2*pi*f*t + phi)) + random - mean(random);
end

%x = 10*cos(2*pi*t*200) + 0.5*cos(2*pi*t*100) + randn(size(t));
%y = 5*cos(2*pi*t*150) + 0.5*cos(2*pi*t*210) + randn(size(t));
y = [];

subplot(3, 2, 1)
plot(t, x)
xlabel('Time (s)')
ylabel('Amplitude (-)')
title('Input signal')
xlim([0 t(end)])

subplot(3, 2, 2)
[Frequency, Amplitude, ~] = SpectralAnalysis.FFT(x, Fs, false);
plot(Frequency, Amplitude)              
xlabel('Frequency (Hz)')
ylabel('Amplitude (-)')
title('Fourier transform of the input signal')

%% Thomson's Multitaper Method

% subplot(3, 2, 3)
% pmtm(x,3.5,[],Fs, 'ConfidenceLevel', 0.95); 
% title('Thomson Multitaper Power Spectral Density Estimate (MATLAB)')
% ylim([-40 20])
% xlim([0 Fs/2])

subplot(3, 2, 5)
hold on
[Power, Frequency, ~] = SpectralAnalysis.MultitaperPowerSpectralDensity(x, y, 20, 'Adaptive', Fs, []);
plot(Frequency, 10*log10(Power))              
%plot(Frequency, 10*log10(ConfidenceIntervals), 'r')  
xlabel('Frequency (Hz)')
ylabel('Power / Frequency (dB/Hz)')
title('Thomson Multitaper Power Spectral Density Estimate (own version)')
ylim([0 20])
xlim([0 Fs/2])

%% Welch's Method

% subplot(3, 2, 4)
% pwelch(x, SpectralAnalysis.WindowFunction.Hann(150), 150/2, [], Fs, 'ConfidenceLevel', 0.95) 
% cpsd(x, y, SpectralAnalysis.WindowFunction.Hann(150), 150/2, [], Fs) 
% title('Welch Power Spectral Density Estimate (MATLAB)')
% ylim([-40 20])
% xlim([0 Fs/2])

subplot(3, 2, 6)
hold on
[Power, Frequency, ~] = SpectralAnalysis.WelchPowerSpectralDensity(x, y, SpectralAnalysis.WindowFunction.Hann(700), 0.5, Fs, []);
plot(Frequency, 10*log10(abs(Power)))
%plot(Frequency, 10*log10(abs(ConfidenceIntervals)), 'r')  
xlabel('Frequency (Hz)')
ylabel('Power / Frequency (dB/Hz)')
title('Welch Power Spectral Density Estimate (own version)')
ylim([0 20])
xlim([0 Fs/2])