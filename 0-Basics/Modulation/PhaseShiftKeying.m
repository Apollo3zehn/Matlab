clc
clear
close all

FigureHandle        = figure ('name', '', ...
                                    'color', 'w', ...
                                    'PaperPositionMode', 'manual', ...
                                    'PaperUnits', 'points', ... 
                                    'PaperSize', [1000 400], ...  
                                    'PaperPosition', [0 0 1000 400], ...
                                    ...
                                    'Units', 'Points', ...
                                    'Position',[0 0 1000 400], ...
                                    ...
                                    'WindowStyle', 'docked');

%%
BitRate     = 1;
fc          = 20;
f0          = BitRate * 2;
f1          = BitRate * 8;
t           = (0 : 0.0001 : 5)';

SquareSignal= (square(2*pi*BitRate*t) + 1) / 2;

f           = f0 * ones(numel(t), 1);
f(SquareSignal > 0) = f1;
SineSignal  = (sin(2*pi.*f.*t) + 1) / 2;

%%
AH1 = subplot(2, 1, 1);
plot(AH1, t, SquareSignal, 'k')
ylim(AH1, [-0.2 1.2])
xlim(AH1, [0.25 4.25])
set(AH1, 'YTick', [])
title(AH1, 'Binary Signal')

%%
AH2 = subplot(2, 1, 2);
plot(AH2, t, SineSignal, 'k')
title(AH2, 'FSK Modulated Signal')
set(AH2, 'YTick', [])
xlabel(AH2, 'time (s)')
xlim(AH2, [00.25 4.25])
ylim(AH2, [-0.2 1.2])