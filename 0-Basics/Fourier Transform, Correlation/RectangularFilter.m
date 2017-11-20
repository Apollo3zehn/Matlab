clc
clear
close all
    
fs          = 1;
t           = 1/fs : 1/fs : 100;
df          = 1 / max(t);
[m, n]      = size(t);
f           = linspace(0, fs/2, n / 2 + 1);
f           = [-flipdim(f(2 : end - 1), 2) f];

%% Plot 1

FigureHandle        = figure (...
                            'PaperPositionMode', 'manual', ...
                            'PaperUnits', 'points', ... 
                            'PaperSize', [1000 250], ...  
                            'PaperPosition', [0 0 1000 250], ...
                            ...
                            'Units', 'Points', ...
                            'Position', [0 0 1000 250]);
                                
% Sinc
fs_s        = 10;
t_s         = (1/fs_s : 1/fs_s : 100) - 100 / 2;
[m_s, n_s]  = size(t_s);
f_s     	= linspace(0, fs/2, n_s / 2 + 1);
f_s         = [-flipdim(f_s(2 : end - 1), 2) f_s];

x       = ones(m, n);
X       = fft(x);
X       = [-X(n / 2 + 2 : end) X(1 : n / 2 + 1)];

subplot(2, 2, 1)
plot(1, 1)
hold on
plot(t, x, 'k')
ylim([-0.5 1.5])
title('Continuous rectangle window in time domain')
grid on

subplot(2, 2, 3)
plot(t, x, 'k--')
hold on
plot(t, x, 'k.')
ylim([-0.5 1.5])
title('Discrete rectangle window in time domain')
xlabel('Time in s')
grid on

subplot(2, 2, 2)
plot(f_s, sin(t_s * pi) ./ (t_s * pi), 'k')
hold on
plot(f, zeros(numel(f)), 'r.', 'MarkerSize', 10)
xlim([-0.1 0.1]);
ylim([-0.5 1.5])
set(gca, 'YTick', [0 0.5 1])
title('Continuous Fourier transform of rectangle window function')
grid on

subplot(2, 2, 4)
plot(f, abs(X) / numel(x), 'k--');
hold on
plot(f, abs(X) / numel(x), 'r.', 'MarkerSize', 10);
xlim([-0.1 0.1]);
ylim([-0.5 1.5])
set(gca, 'YTick', [0 0.5 1])
title('Discrete Fourier transform of rectangle window function')
xlabel('Frequency in Hz')
grid on

%% Plot 2



FigureHandle        = figure (...
                            'PaperPositionMode', 'manual', ...
                            'PaperUnits', 'points', ... 
                            'PaperSize', [1000 250], ...  
                            'PaperPosition', [0 0 1000 250], ...
                            ...
                            'Units', 'Points', ...
                            'Position', [0 0 1000 250]);

fs          = 1;
t           = 1/fs : 1/fs : 100;
df          = 1 / max(t);
[m, n]      = size(t);
f           = linspace(0, fs/2, n / 2 + 1);
f           = [-flipdim(f(2 : end - 1), 2) f];

% Sinc
fs_s        = 10;
t_s         = (1/fs_s : 1/fs_s : 50) - 50 / 2;
[m_s, n_s]  = size(t_s);
f_s     	= linspace(0, fs/2, n_s / 2 + 1);
f_s         = [-flipdim(f_s(2 : end - 1), 2) f_s];  

x           = [ones(m, 0.5 * n) zeros(m, 0.5 * n)];
X           = fft(x);
X           = [-X(n / 2 + 2 : end) X(1 : n / 2 + 1)];

subplot(2, 2, 1)
plot(t, x, 'k')
hold on
ylim([-0.5 1.5])
title('Continuous rectangle window in time domain')
grid on

subplot(2, 2, 3)
plot(t, x, 'k--')
hold on
plot(t, x, 'k.')
ylim([-0.5 1.5])
title('Discrete rectangle window in time domain')
xlabel('Time in s')
grid on

subplot(2, 2, 2)
plot(f_s, sin(t_s * pi) ./ (t_s * pi * 2), 'k')
hold on
plot(f, zeros(numel(f)), 'r.', 'MarkerSize', 10)
xlim([-0.1 0.1]);
ylim([-0.5 1.5])
set(gca, 'YTick', [0 0.5 1])
title('Continuous Fourier transform of rectangle window function')
grid on

subplot(2, 2, 4)
plot(f, abs(X) / numel(x), 'k--');
hold on
plot(f, abs(X) / numel(x), 'r.', 'MarkerSize', 15);
xlim([-0.1 0.1]);
ylim([-0.5 1.5])
set(gca, 'YTick', [0 0.5 1])
title('Discrete Fourier transform of rectangle window function')
xlabel('Frequency in Hz')
grid on
