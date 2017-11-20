clc
clear
close all

f1  = 5;
f2  = 14;

t   = linspace(0, 16, 10000);

a   = sin(2*pi*f1*t);
b   = sin(2*pi*f2*t);

subplot(2, 4, 1)
plot(t, a, 'Color', [0.85 0.325 0.098])
xlim([0 1])
ylim([-1.1 1.1]);
title(sprintf('%d Hz', f1))
grid on

subplot(2, 4, 2)
plot(t, b, 'Color', [0.85 0.325 0.098])
xlim([0 1])
ylim([-1.1 1.1]);
title(sprintf('%d Hz', f2))
grid on

subplot(2, 4, [5 6])
plot(t, a .* b, 'k')
xlim([0 2])
ylim([-1.1 1.1]);
title(sprintf('%d Hz + %d Hz', abs(f1 - f2), abs(f1 + f2)))
xlabel('Time (s)')
grid on

subplot(2, 4, [3 4 7 8])
[Frequency, Amplitude, ~] = SpectralAnalysis.FFT(a .* b, 10000/16, false);
area(Frequency, Amplitude, 'FaceColor', 'k')

[Frequency, Amplitude, ~] = SpectralAnalysis.FFT(a, 10000/16, false);
hold on
area(Frequency, Amplitude, 'FaceColor', [0.85 0.325 0.098], 'EdgeColor', [0.85 0.325 0.098])

[Frequency, Amplitude, ~] = SpectralAnalysis.FFT(b, 10000/16, false);
hold on
area(Frequency, Amplitude, 'FaceColor', [0.85 0.325 0.098], 'EdgeColor', [0.85 0.325 0.098])
xlim([0 25]);
ylim([0 1.1]);
xlabel('Frequency (Hz)')
grid on

set(gcf, 'Position', [200 300 1500 350])
set(gcf, 'PaperPositionMode', 'manual', ...
                                    'PaperUnits', 'points', ... 
                                    'PaperSize', [1500 350], ...  
                                    'PaperPosition', [0 0 1500 350])
Figure.SaveCurrentFigure

