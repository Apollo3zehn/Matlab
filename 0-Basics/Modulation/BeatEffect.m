% This method is useful to calculate the frequency shift of two signals.
% 1. envelope signal frequency = |f1 - f2| / 2
% 2. beat frequency = |f1 - f2| 
% 3. and the frequency of the carrier signal is (f1 + f2) / 2.

clc
clear
close all

f1  = 25;
f2  = 30;

t   = linspace(0, 4, 10000);

a   = sin(2*pi*f1*t + pi);
b   = sin(2*pi*f2*t);

subplot(2, 4, 1)
plot(t, a)
xlim([0 0.5])

subplot(2, 4, 2)
plot(t, b)
xlim([0 0.5])

subplot(2, 4, [5 6])
plot(t, a + b)
xlim([0 1])

subplot(2, 4, [3 4 7 8])
[Frequency, AmplitudePhase] = SpectralAnalysis.FFT(a + b, 10000/4, false);
plot(Frequency, real(AmplitudePhase))
xlim([0 50]);

