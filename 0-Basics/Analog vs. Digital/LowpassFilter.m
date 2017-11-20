clc
clear
close all

%% Calculation of Bode diagram for a lowpass filter 1. order (a1 = 1, b1 = 0)
figure(1)

w   = (0.1:0.1:1000);
wc  = 1;

% Plot 1
AH1 = subplot(3, 1, 1);
hold(AH1, 'on')
RC  = 1/wc;
a1  = 1;
dB  = 20*log(abs(1./(1+a1*RC*w*1j)))/log(10);
plot(AH1, [1e-1 1e3], [-3 -3], 'r')
plot(AH1, w, dB, 'k')
set(AH1, 'XScale', 'log');
grid(AH1, 'on')
xlim(AH1, [1e-1 1e3])
ylim(AH1, [-40 0])
title(AH1, 'Bode diagram of low pass filter, cut-off frequency \bf{{wc = 1 rad/s}}')
ylabel(AH1, 'Magnitude (dB)')
hold(AH1, 'off')

% Plot 2
AH2 = subplot(3, 1, 2);
hold(AH2, 'on')
wc  = 10;
RC  = 1/wc;
dB  = 20*log(abs(1./(1+RC*w*1j)))/log(10);
plot(AH2, [0.001 1000], [-3 -3], 'r')
plot(AH2, w, dB, 'k')
set(AH2, 'XScale', 'log');
grid(AH2, 'on')
xlim(AH2, [1e-1 1e3])
ylim(AH2, [-40 0])
title(AH2, 'Bode diagram of low pass filter, cut-off frequency {\bf{wc = 10 rad/s}}')
ylabel(AH2, 'Magnitude (dB)')
hold(AH2, 'off')

% Plot 3
AH4 = subplot(3, 1, 3);
hold(AH4, 'on')
s   = 1j*w/wc;
dB  = 20*log(abs(1./(1+wc*RC*s)))/log(10);
plot(AH4, [1e-1 1e3], [-3 -3], 'r')
plot(AH4, abs(s), dB, 'k')
set(AH4, 'XScale', 'log');
grid(AH4, 'on')
xlim(AH4, [1e-1 1e3])
ylim(AH4, [-40 0])
title(AH4, '{\bf{Normalized}} bode diagram of low pass filter, cut-off frequency {\bf{wc = 10 rad/s}}')
xlabel(AH4, 'Frequency (rad/s)')
ylabel(AH4, 'Magnitude (dB)')
hold(AH4, 'off')

%% Analog lowpass filter(6. order, cut-off frequency wc = 10 rad/s)
figure(2)
wc      = 10;

% second order sections (table coefficients)
% advantage: more stable, no signal processing toolbox needed
AH1     = subplot(4, 1, 1);
a(1)    = 1.9319;
a(2)    = 1.4142;
a(3)    = 0.5176;
b(1)    = 1;
b(2)    = 1;
b(3)    = 1;
LP1     = tf(1, [b(1)/wc^2 a(1)/wc 1]);
LP2     = tf(1, [b(2)/wc^2 a(2)/wc 1]);
LP3     = tf(1, [b(3)/wc^2 a(3)/wc 1]);
bodemag(LP1 * LP2 * LP3);
grid(AH1, 'on')
title(AH1, '{\bf{second order sections (table coefficients)}}, cut-off frequency {\bf{wc = 10 rad/s}}, 6. order')
xlim(AH1, [1e-1 1e3])
ylim(AH1, [-40 0])

% second order sections (using 'butter' + 'zp2sos' to calculate coefficients)
% advantage: more stable (use sosfilt(...) * g instead of filter)
AH2         = subplot(4, 1, 2);
[z, p, k]   = butter(6, wc, 'low', 's');
[sos, k]    = zp2sos(z, p, k);
b           = sos(:, 1:3);
a           = sos(:, 4:6);
LP1         = tf(b(1, :), a(1, :));
LP2         = tf(b(2, :), a(2, :));
LP3         = tf(b(3, :), a(3, :));
bodemag(LP1 * LP2 * LP3 * k)
grid(AH2, 'on')
title(AH2, '{\bf{second order sections (using ''butter'' + ''zp2sos'' to calculate coefficients)}}, cut-off frequency {\bf{wc = 10 rad/s}}, 6. order')
xlim(AH2, [1e-1 1e3])
ylim(AH2, [-40 0])

% second order sections (using 'butter' + 'tf2sos' to calculate coefficients)
% advantage: more stable
AH3     = subplot(4, 1, 3);
[b, a]  = butter(6, wc, 'low', 's');
[sos,g] = tf2sos(b, a, 'down');
b       = sos(:, 1:3);
a       = sos(:, 4:6);
LP1     = tf(b(1, :), a(1, :));
LP2     = tf(b(2, :), a(2, :));
LP3     = tf(b(3, :), a(3, :));
bodemag(LP1 * LP2 * LP3 * g)
grid(AH3, 'on')
title(AH3, '{\bf{second order sections (using ''butter'' + ''tf2sos'' to calculate coefficients)}}, cut-off frequency {\bf{wc = 10 rad/s}}, 6. order')
xlim(AH3, [1e-1 1e3])
ylim(AH3, [-40 0])

% single transfer function (using 'butter' to calculate coefficients)
% advantage: simple
AH4     = subplot(4, 1, 4);
[b, a]  = butter(6, wc, 'low', 's');
bodemag(tf(b, a))
grid(AH4, 'on')
title(AH4, '{\bf{single transfer function (using ''butter'' to calculate coefficients)}}, cut-off frequency {\bf{wc = 10 rad/s}}, 6. order')
xlim(AH4, [1e-1 1e3])
ylim(AH4, [-40 0])

%% Digital filter comparison (digital)
figure(3)
fs      = 100;
fc      = 10;
[b, a]  = butter(4, fc/(fs/2), 'low');

A1      = 1;
A2      = 0.3;
f1      = 5;
f2      = 20;
t       = (0 : 0.01 : 1)';
Data  	= A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t);

% original data
AH1             = subplot(5, 1, 1);
plot(AH1, t, Data, 'k')
ylim(AH1, [-1.3 1.3])
xlabel(AH1, 'Time (s)')
title(AH1, '{\bf{original data}}, f_1 = 5 Hz, f_2 = 20 Hz')

% filtered data using 'filter'
AH2             = subplot(5, 1, 2);
FilteredData    = filter(b, a, Data);
hold(AH2, 'on')
plot(AH2, t, Data, '-.k')
plot(AH2, t, FilteredData, 'k')
hold(AH2, 'off')
ylim(AH2, [-1.3 1.3])
xlabel(AH2, 'Time (s)')
title(AH2, '{\bf{filtered data using ''filter''}}, cut-off frequency {\bf{f_c = 10 Hz}}, 4. order')

% filtered data using 'sosfilt'
AH3             = subplot(5, 1, 3);
[sos, g]        = tf2sos(b, a);
FilteredData    = sosfilt(sos, Data) * g;
hold(AH3, 'on')
plot(AH3, t, Data, '-.k')
plot(AH3, t, FilteredData, 'k')
hold(AH3, 'off')
ylim(AH3, [-1.3 1.3])
xlabel(AH3, 'Time (s)')
title(AH3, '{\bf{filtered data using ''sosfilt''}}, cut-off frequency {\bf{f_c = 10 Hz}}, 4. order')

% filtered data using direct form II implementation (simulink)
AH4                             = subplot(5, 1, 4);
SimulinkData.time               = t;
SimulinkData.signals.values     = Data;
SimulinkData                    = sim('DFII', 'SrcWorkspace', 'current');

FilteredData                    = get(SimulinkData, 'FilteredData');

hold('on')
plot(AH4, t, Data, '-.k')
plot(AH4, t, FilteredData.signals.values, 'k')
hold('off')
ylim(AH4, [-1.3 1.3])
xlabel(AH4, 'Time (s)')
title(AH4, '{\bf{filtered data using ''direct form II'' implementation (simulink)}}, cut-off frequency {\bf{f_c = 10 Hz}}, 4. order')

% filtered data using 'filtfilt'
AH5             = subplot(5, 1, 5);
FilteredData    = filtfilt(b, a, Data);
hold(AH5, 'on')
plot(AH5, t, Data, '-.k')
plot(AH5, t, FilteredData, 'k')
hold(AH5, 'off')
ylim(AH5, [-1.3 1.3])
xlabel(AH5, 'Time (s)')
title(AH5, '{\bf{filtered data using ''filtfilt''}}, cut-off frequency {\bf{f_c = 10 Hz}}, 4. order')

%% Filter discretization
figure(5)

LP_A            = tf(1, [1 1]);
LP_D_ZOH        = c2d(LP_A, 0.1, 'zoh');
LP_D_FOH        = c2d(LP_A, 0.1, 'foh');
LP_D_IMPULSE    = c2d(LP_A, 0.1, 'impulse');
LP_D_TUSTIN     = c2d(LP_A, 0.1, 'tustin');
LP_D_MATCHED    = c2d(LP_A, 0.1, 'matched');

AH1 = subplot(3, 2, 1);
step(LP_A, LP_D_ZOH)
ylim(AH1, [0 1.1])
title(AH1, 'Step response (zero-order hold)')
grid(AH1, 'on')

AH2 = subplot(3, 2, 2);
step(LP_A, LP_D_FOH)
ylim(AH2, [0 1.1])
title(AH2, 'Step response (first-order hold)')
grid(AH2, 'on')

AH3 = subplot(3, 2, 3);
step(LP_A, LP_D_IMPULSE)
ylim(AH3, [0 1.1])
title(AH3, 'Step response (impulse invariant)')
grid(AH3, 'on')

AH4 = subplot(3, 2, 4);
step(LP_A, LP_D_TUSTIN)
ylim(AH4, [0 1.1])
title(AH4, 'Step response (bilinear (tustin) method)')
grid(AH4, 'on')

AH5 = subplot(3, 2, 5);
step(LP_A, LP_D_MATCHED)
ylim(AH5, [0 1.1])
title(AH5, 'Step response (zero-pole matching method)')
grid(AH5, 'on')

%% Comments

% The commands freqs and freqz are used for frequency responses of 
% analog (s) and % digital (z) filters. Calculated b and a coefficients can
% be used directly.