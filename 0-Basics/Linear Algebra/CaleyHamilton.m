clc
clear
close all

%% Power
fprintf('##############################################\n')
Power   = 5;
fprintf('Calculate the %dth power the following Matrix:\n', Power)
Matrix  = [6 -2;
           6 -1];
disp(Matrix)

% Caley-Hamilton
n       = size(Matrix, 1);
EV      = eig(Matrix); 
k     	= [EV ones(numel(EV), 1)] \ EV.^Power;
Powered = k(1) * Matrix + k(2) * eye(n);
fprintf('Caley-Hamiltons method says:\n')
disp(Powered)

% Eigenvalues and eigenvectors:

[V, D]  = eig(Matrix);
Powered = V*D.^Power/V;
fprintf('The other method (eigenvector and eigenvalues) says:\n')
disp(Powered)

% Matlab
fprintf('Matlab says:\n')
disp(Matrix^Power)

%% Inverse (Ineffective because of Matrix^-1 and Matrix^2)
fprintf('###########################################\n')
fprintf('Calculate the inverse the following Matrix:\n')
Matrix  = [ 2 0 1;
           -2 3 4;
           -5 5 6];
disp(Matrix)

% Caley-Hamilton
fprintf('Caley-Hamiltons method says:\n')
n       = size(Matrix, 1);
CF      = sum(sum(diag(det(Matrix) * Matrix^-1 * eye(n))));
TR      = trace(Matrix);
Inverse = Matrix^2 - TR * Matrix + CF * eye(n);
disp(Inverse)

% Matlab
fprintf('Matlab says:\n')
disp(Matrix^-1)