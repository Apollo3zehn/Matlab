% see http://www.fhnw.ch/technik/ime/publikationen/2012/how-to-use-the-fft-and-matlab2019s-pwelch-function-for-signal-and-noise-simulations-and-measurements

clc
clear
close all


fs  = 300;
f   = 10;
t   = 0 : 1/fs : 4;
N   = numel(t);

%%

Data        = 5 + 5 * sin(2*pi*f*t);
[Frequency1, Amplitude1, ~] = SpectralAnalysis.FFT(Data, fs, false);

Data        = 5 + 5 * sin(2*pi*f*t);
[Frequency2, Amplitude2, ~] = SpectralAnalysis.FFT(Data, fs, true);

Data        = 5 + 5 * sin(2*pi*f*t) + t;
[Frequency3, Amplitude3, ~] = SpectralAnalysis.FFT(Data, fs, false);

% Windowing

Data        = 5 + 5 * sin(2*pi*f*t);
Window      = SpectralAnalysis.WindowFunction.Hann(N);

[Frequency5, Amplitude5, ~] = SpectralAnalysis.FFT(Data .* Window.', fs, false);

[Frequency6, Amplitude6, ~] = SpectralAnalysis.FFT(Data .* Window.', fs, false);
CG          = mean(Window);
Amplitude6  = Amplitude6 / CG;

% Power Spectral Density

Random      = rand(1, N);
Data        = 5 + 5 * sin(2*pi*f*t) + Random - mean(Random);

[Frequency4, Amplitude4, ~] = SpectralAnalysis.FFT(Data, fs, false);

[Frequency7, Amplitude7, ~] = SpectralAnalysis.FFT(Data, fs, false);
Pxx7        = Amplitude7.^2;

Window      = SpectralAnalysis.WindowFunction.Hann(N);
CG          = mean(Window);
NG          = mean(Window.^2);

[Frequency8, Amplitude8, ~] = SpectralAnalysis.FFT(Data .* Window.', fs, false);
Pxx8        = Amplitude8.^2;

[Frequency9, Amplitude9, ~] = SpectralAnalysis.FFT(Data .* Window.', fs, false);
Pxx9        = Amplitude9.^2 / NG;

%% Plot

AH1 = subplot(3, 4, 1);
AH2 = subplot(3, 4, 5);
AH3 = subplot(3, 4, 9);

AH4 = subplot(3, 4, 2);
AH5 = subplot(3, 4, 6);
AH6 = subplot(3, 4, 10);

AH7 = subplot(3, 4, 3);
AH8 = subplot(3, 4, 7);
AH9 = subplot(3, 4, 11);

AH10 = subplot(3, 4, 4);
AH11 = subplot(3, 4, 8);
AH12 = subplot(3, 4, 12);

bar(AH1, Frequency1, Amplitude1)
bar(AH2, Frequency2, Amplitude2)
bar(AH3, Frequency3, Amplitude3)

bar(AH5, Frequency5, Amplitude5)
bar(AH6, Frequency6, Amplitude6)

bar(AH4, Frequency4, Amplitude4)
plot(AH7, Frequency7, 10*log10(Pxx7)); hold(AH7, 'on'); plot(AH7, [0 150], [1 1] * 20*log10(5), 'r')
plot(AH8, Frequency8, 10*log10(Pxx8)); hold(AH8, 'on'); plot(AH8, [0 150], [1 1] * 20*log10(5), 'r')
plot(AH9, Frequency9, 10*log10(Pxx9)); hold(AH9, 'on'); plot(AH9, [0 150], [1 1] * 20*log10(5), 'r')

xlim(AH1, [0 15])
xlim(AH2, [0 15])
xlim(AH3, [0 15])
xlim(AH4, [0 15])
xlim(AH5, [0 15])
xlim(AH6, [0 15])
xlim(AH7, [0 15])
xlim(AH8, [0 15])
xlim(AH9, [0 15])

ylim(AH1, [0 10])
ylim(AH2, [0 10])
ylim(AH3, [0 10])
ylim(AH4, [0 10])
ylim(AH5, [0 10])
ylim(AH6, [0 10])
ylim(AH7, [-60 20])
ylim(AH8, [-60 20])
ylim(AH9, [-60 20])

grid(AH1, 'on')
grid(AH2, 'on')
grid(AH3, 'on')
grid(AH4, 'on')
grid(AH5, 'on')
grid(AH6, 'on')
grid(AH7, 'on')
grid(AH8, 'on')
grid(AH9, 'on')

title(AH1, 'FFT')
title(AH2, 'FFT - zero padding')
title(AH3, 'FFT - trend')

title(AH5, 'FFT - window')
title(AH6, 'FFT - window with coherent gain correction')

title(AH4, 'FFT - white noise')
title(AH7, 'PSD - white noise')
title(AH8, 'PSD - white noise and window')
title(AH9, 'PSD - white noise, window and noise gain correction')

