clc
clear
close all

Distance        = 60;
MeanWindSpeed   = 10.5;
FftLength       = 1024;
T               = 512 - 1;

f1              = 1.0;
f2              = 1.1;

% T 1
t_1             = linspace(0, T, FftLength);
Signal_1        = sin(2*pi*f1*t_1) + sin(2*pi*f2*t_1);

% T 2
dt              = 0.2;
t_2             = linspace(0, T, FftLength) + dt;
Signal_2        = sin(2*pi*f1*t_2) + sin(2*pi*f2*t_2);

subplot(5, 1, 1)
plot(Signal_1)
subplot(5, 1, 2)
plot(Signal_2, 'r')

% CPSD
fs              = 1/T * (FftLength - 1);
[Power, Frequency, ~]   = SpectralAnalysis.WelchPowerSpectralDensity(Signal_1, Signal_2, SpectralAnalysis.WindowFunction.Hann(numel(t_1)), 0.5, fs, []);
subplot(5, 1, 3) 
plot(real(Power))
subplot(5, 1, 4) 
plot(imag(Power))
subplot(5, 1, 5) 
plot(imag(Power))
Angle           = angle(Power);
plot(Angle)
dAngle          = diff(Angle);
df              = Frequency(2);
Speed           = 2 * pi * df * 60 ./ dAngle;
Speed           = 2 * pi * Frequency * 60 ./ Angle;

Expected        = Distance / dt;





