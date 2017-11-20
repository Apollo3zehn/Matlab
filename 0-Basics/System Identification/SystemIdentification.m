clc
clear
close all

addpath(genpath('SystemIdentification'))

%%

T_s     = 15.0e-3; 
d       = 0.30;
g       = 9.80665;
r2d   	= 180.0 / pi;
kf      = 0.01;         % friction coefficient
mp      = 0.2;          % mass of pendulum
kfp     = kf / mp / d;

sim('Pendulum')

%% Non-linear model

u       = pdident(:, 1);
y       = pdident(:, 3);
t       = T_s * (0 : numel(u) - 1)';

AH1     = subplot(3, 2, 1);
n       = 1;
p       = lsqid(y, u, n);
G_id    = tf(p(n + 1 : end)', [1 p(1 : n)'], T_s);
y_id    = lsim(G_id, u, t);
plot(AH1, t, [y y_id])
title(AH1, 'Non-Linear Model Identification n = 1')

AH2     = subplot(3, 2, 3);
n       = 2;
p       = lsqid(y, u, n);
G_id    = tf(p(n + 1 : end)', [1 p(1 : n)'], T_s);
y_id    = lsim(G_id, u, t);
plot(AH2, t, [y y_id])
title(AH2, 'Non-Linear Model Identification n = 2')

fprintf('Non-Linear-Model earth gravitation: %7.4f\n', -1 / dcgain(G_id))

AH3     = subplot(3, 2, 5);
n       = 5;
p       = lsqid(y, u, n);
G_id    = tf(p(n + 1 : end)', [1 p(1 : n)'], T_s);
y_id    = lsim(G_id, u, t);
plot(AH3, t, [y y_id])
title(AH3, 'Non-Linear Model Identification n = 5')

%% Linear model

AH4     = subplot(3, 2, 2);
y       = pdident(:, 5);
n       = 2;
p       = lsqid(y, u, n);
G_id    = tf(p(n + 1 : end)', [1 p(1 : n)'], T_s);
y_id    = lsim(G_id, u, t);
plot(AH4, t, [y y_id])
title(AH4, 'Linear Model Identification n = 2')

fprintf('    Linear-Model earth gravitation: %7.4f\n', -1 / dcgain(G_id))

z_p  	= pole(G_id);
s_p     = log(z_p) / T_s;
damp(G_id)

%% Alternative for dcgain(...): 
% set all poles of the transfer function to 
% 0              (s-domain) 
% exp(-Ts*s) = 1 (z-domain)

%% Alternative for poles(...):
% zp = roots([1 p(1:2)'])

%% Alternative for damp(...):
AH5     = subplot(3, 2, [4 6]);
w0      = abs(s_p(1));
D       = -cos(atan2(imag(s_p(1)), real(s_p(1))));
d_id    = g / w0^2;
fprintf('\nNatural frequency: %.4f rad/s\nDamping factor: %.4f\nPendulum length: %.4f m\n', w0, D, d_id)

hold(AH5, 'on')
plot(AH5, real(s_p), imag(s_p), 'r.', 'MarkerSize', 15)
plot(AH5, [0; real(s_p(1))], [0; imag(s_p(1))], 'k')
plot(AH5, [0; real(s_p(2))], [0; imag(s_p(2))], 'k')
text(real(s_p(1)) / 2, imag(s_p(1)) * 1.5 / 2, '\omega_0 = |s_p|')
text(real(s_p(1)), 0, 'D = angle(s_p)')
grid(AH5, 'on')
title(AH5, 's-plane')
xlabel(AH5, 'real - \sigma')
ylabel(AH5, 'imaginary - j·\omega')
xlim(AH5, [-1 1])
ylim(AH5, [-10 10])
hold(AH5, 'off')
