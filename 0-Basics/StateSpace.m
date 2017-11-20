clc
clear
close all

%% Intitialization
fprintf('\n############################################################################################################################\n')
fprintf('########################################################### SISO ###########################################################\n')
fprintf('############################################################################################################################\n')

h       = 2;
m_f     = 3;
J       = 0.1;
g       = 9.81;

A       = [0  m_f*g*h/J 0 -m_f*g/J;
           1  0         0  0;
           0 -g         0  0;
           0  0         1  0];
B       = [1/J 0 0 0]';
C       = [0 0 0 1];
D       = 0;

n       = size(A, 1);

%%
fprintf('\n########################################################## General #########################################################\n')

fprintf('\n          system matrix A:            input matrix B:\n\n')
fprintf('|%7.2f %7.2f %7.2f %7.2f|         |%5.2f|\n', [A B]')

fprintf('\n          output matrix C:         feedthrough matrix D:\n\n')
fprintf('             |%.0f %.0f %.0f %.0f|                     |%.0f|\n', [C D]')

if rank(A) == n
    fprintf('\nSystem matrix A has full rank.\n')
end

%%
fprintf('\n###################################################### Controllability #####################################################\n')

% controllability matrix
% S = [B A*B A^2*B ... A^n-1*B]

S       = ctrb(A, B);

if rank(S) == n
    fprintf('\nControllability matrix S has full rank. System is fully controllable.\n')
end

% controllable canonical form
% T_R   = [q q*A q*A^2 ... q*A^n-1]
% q     = i_n' * S^-1

fprintf('\nControllable canonical form:\n')

t_1     = [zeros(1, n - 1) 1] * S^-1 ;
q       = t_1;

T_R     = zeros(n);
for i = 0 : n - 1 
    T_R(i + 1, :) = q * A^i;
end

A_R     = T_R^-1 * A * T_R;
B_R     = T_R^-1 * B;
C_R     = C * T_R;
D_R     = D;

EW      = eig(A);
A_R2    = flip(-A_R(end, :), 2);
Roots   = roots([1 A_R2]);
Poly    = poly(EW);

fprintf('\n  eigenvalues of A:     last row of A_R:     modified A_R (A_R2):     roots of [1 A_R2]:     polynomial of eigenvalues of A:\n\n')
fprintf('%8.4f +%8.4fi           %10.4f               %10.4f    %8.4f +%8.4fi                          %10.4f\n', [real(EW) imag(EW) A_R(end, :).' A_R2.' real(Roots) imag(Roots) Poly(2 : end)'].')
fprintf('                                                                                                                  %10.4f\n', Poly(1))

%%
fprintf('\n################################################# Feedback vector k / k* ###################################################\n')

Poles   = [-10 -10 -10 -10];

S       = ctrb(A, B);
alpha   = poly(Poles);
t_1     = [zeros(1, n - 1) 1] * S^-1 ;
q       = t_1;
P_aA    = polyvalm(alpha, A);
k       = q * P_aA;
% k     = acker(A, B, Poles);
p       = 1 / (C * (B*k-A)^-1 * B);

k_star  = k - p*C;
p_star  = p;

FbPoles = eig(A-B*k);

fprintf('\ndesired eigenvalues of the                                                     new eigenvalues of the\n')
fprintf('  feedback system (A-b*k):      feedback vector k:      preamplifier p:      feedback system (A-b*k):\n\n')
fprintf('       %8.4f +%8.4fi              %10.4f           %10.4f           %8.4f +%8.4fi\n', [real(Poles).' imag(Poles).' k.' [p NaN NaN NaN].' real(FbPoles) imag(FbPoles)].')

fprintf('\n\n                               feedback vector k*:     preamplifier p*:\n\n')
fprintf('                                        %10.4f           %10.4f \n', [k_star.' [p_star NaN NaN NaN].'].')

%%
fprintf('\n####################################################### Observability ######################################################\n')

% observability matrix
% R = [c c*A c*A^2 ... c*A^n-1]'

R       = obsv(A, C);

if rank(R) == n
    fprintf('\nObservability matrix R has full rank. System is fully observable.\n')
end

% observable canonical form
% T_B   = [t_1 q*A q*A^2 ... q*A^n-1]
% q     = i_n' * S^-1

fprintf('\nObservable canonical form:\n')

t_1     = R^-1 * [zeros(n - 1, 1); 1];

T_B     = zeros(n);
for i = 0 : n - 1 
    T_B(:, i + 1) = A^i * t_1;
end

A_B     = T_B^-1 * A * T_B;
B_B     = T_B^-1 * B;
C_B     = C * T_B;
D_B     = D;

EW      = eig(A);
A_B2    = flip(-A_B(:, end), 1);
Roots   = roots([1; A_B2]);
Poly    = poly(EW);

fprintf('\n  eigenvalues of A:  last column of A_B:     modified A_R (A_B2):    roots of [1; A_B2]:     polynomial of eigenvalues of A:\n\n')
fprintf('%8.4f +%8.4fi           %10.4f               %10.4f    %8.4f +%8.4fi                          %10.4f\n', [real(EW) imag(EW) A_B(:, end) A_B2 real(Roots) imag(Roots) Poly(2 : end).'].')
fprintf('                                                                                                                  %10.4f\n', Poly(1))

%%
fprintf('\n##################################################### observer vector h ####################################################\n')

Poles   = [-10 -10 -10 -10];
beta    = poly(Poles);
R       = obsv(A, C);
t_1     = R^-1 * [zeros(n - 1, 1); 1];
P_bA    = polyvalm(beta, A);
h       = P_bA * t_1;
% h     = acker(A.', C.', Poles);

FbPoles = eig(A-h*C);

fprintf('\ndesired eigenvalues of the                                new eigenvalues of the\n')
fprintf('  observer system (A-h*k):      observer vector h:      observer system (A-h*k):\n\n')
fprintf('       %8.4f +%8.4fi             %11.4f           %8.4f +%8.4fi\n', [real(Poles).' imag(Poles).' h real(FbPoles) imag(FbPoles)].')

%% Intitialization
fprintf('\n############################################################################################################################\n')
fprintf('########################################################### MIMO ###########################################################\n')
fprintf('############################################################################################################################\n')

A       = [ 1.38 -0.21  6.72 -5.68;
           -0.58 -4.29  0.00  0.68;
            1.07  4.27 -6.65  5.89;
            0.05  4.27  1.34 -2.10];
B       = [0.00  0.00;
           5.68  0.00;
           1.14 -3.15;
           1.14  0.00];
C       = [1 0 1 -1;
           0 1 0  0];
D       = [0 0;
           0 0];

n       = size(A, 1);

%%
fprintf('\n########################################################## General #########################################################\n')

fprintf('\n     system matrix A:            input matrix B:\n\n')
fprintf('|%5.2f %5.2f %5.2f %5.2f|         |%5.2f %5.2f|\n', [A B]')

fprintf('\n     output matrix C:         feedthrough matrix D:\n\n')
fprintf('      |%2.0f %2.0f %2.0f %2.0f|                   |%.0f|\n', [C D]')

if rank(A) == n
    fprintf('\nSystem matrix A has full rank.\n')
end

%%
fprintf('\n##################################################### Feedback matrix K ####################################################\n')

% Method 0: no preselection of x or p. The vector [x; p] is carried out by Kern(H(Lambda))

Poles   = [-6 -7 -8 -9];

H_1     = [A - Poles(1)*eye(n) -B];
H_Null1 = null(H_1);

H_2     = [A - Poles(2)*eye(n) -B];
H_Null2 = null(H_2);

H_3     = [A - Poles(3)*eye(n) -B];
H_Null3 = null(H_3);

H_4     = [A - Poles(4)*eye(n) -B];
H_Null4 = null(H_4);

% [U,S,V] = svd(H)

x       = [H_Null1(1 : n, 1) H_Null2(1 : n, 1) H_Null3(1 : n, end, 1) H_Null4(1 : n, 1)];
p       = [H_Null1(n+1 : end, 1) H_Null2(n+1 : end, 1) H_Null3(n+1 : end, 1) H_Null4(n+1 : end, 1)];

K       = p * x^-1;
V_star  = (C * (B*K-A)^-1 * B)^-1;

FbPoles = flip(eig(A-B*K), 1);

fprintf('\ndesired eigenvalues of the                                                                        new eigenvalues of the\n')
fprintf('  feedback system (A-B*K):                 feedback matrix K:      preamplifier matrix V*:      feedback system (A-b*k):\n\n')
fprintf('       %8.4f +%8.4fi      |%6.3f %6.3f %6.3f %6.3f|              |%6.3f %6.3f|           %8.4f +%8.4fi\n', [real(Poles).' imag(Poles).' [K; NaN(2, 4)] [V_star.'; NaN(2, 2)] real(FbPoles) imag(FbPoles)].')

% Example: http://www.rt.mw.tum.de/fileadmin/w00bhf/www/lehre/mm1/loesungen/uebung_loesung3_SS12.pdf
% see also Ludyk p. 91/2

% A       = [-0.5 0.5 0;
%             0.5 -1  0.5;
%             0  0.5 -1];
% B       = [1;
%            0;
%            0];
% 
% n       = size(A, 1);
% 
% Poles   = [-0.5 -1 -2];
% 
% % Method 1: Select x and calculate p / This method enables the selection of robust eigenvalues 
% 
% % x       = xxx;
% % p       = [(B.'*B)^-1 * B.' * (A-Poles(1)*eye(n)) * x(:, 1) (B.'*B)^-1 * B.' * (A-Poles(2)*eye(n)) * x(:, 1) (B.'*B)^-1 * B.' * (A-Poles(3)*eye(n)) * x(:, 1)];
% % K       = p * x^-1; 
% 
% K       = place(A, B, Poles);
% 
% % Method 2: Select p and calculate x
% p       = [1 1 1];
% x       = [(A-Poles(1)*eye(n))^-1*B*p(1) (A-Poles(2)*eye(n))^-1*B*p(2) (A-Poles(3)*eye(n))^-1*B*p(3)];
% K       = p * x^-1;

%%
fprintf('\n########################################## Linear-quadratic regulator / K (discrete) #######################################\n')

Ts      = 0.5;
sysd    = c2d(ss(A, B, C, D), Ts);

A_d     = sysd.A;
B_d     = sysd.B;
C_d     = sysd.C;
D_d     = sysd.D;

Q       = C_d.'*C_d;
R       = eye(size(B, 2));

H_star  = [A_d + B_d * R^-1 * B_d.' * (A_d^-1).' * Q, -B_d * R * B_d.' * (A_d^-1).';
           (-A_d^-1).' * Q, (A_d^-1).'];
      
[EV, EW]= eig(H_star);

V       = EV(:, sum(abs(EW) < 1) == size(EW, 1));
V_1     = V(1 : end/2, :);
V_2     = V(end/2 + 1 : end, :);
P       = real(V_2 * V_1^-1);
K       = (R + B_d.' * P * B_d)^-1 * B_d.' * P * A_d;
       
fprintf('\nfeedback matrix K:\n\n')
fprintf(' |%8.4f%8.4f|     \n', K.')

%%
fprintf('\n######################################### Linear-quadratic regulator / K (continuous) ######################################\n')

Q       = C.' * C;
R       = eye(size(B, 2));

H       = [A B * R^-1 * B.';
           Q -A.'];

[EV, EW]= eig(H);

V       = EV(:, sum(real(EW) < 0) == 1);
V_1     = V(1 : end/2, :);
V_2     = V(end/2 + 1 : end, :);
P       = real(-V_2 * V_1^-1);
K       = R^-1 * B.' * P;
%K      = lqr(A, B, Q, R, 0)

fprintf('\nfeedback matrix K:\n\n')
fprintf('|%8.4f %8.4f %8.4f %8.4f|     \n', K.')

%%
fprintf('\n##################################################### Kalmann filter / K_k #################################################\n')

% see p. S. 193 / 2; M must be solved iteratively; M is needed to solve for K_k

% kalman(ss(A, B, C, D), Q, R);
