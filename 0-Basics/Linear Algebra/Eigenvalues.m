close all
clc
clear

%% Complex eigenvalues
 
A = [ 1.01  0.84 0.66 1.70 0.28;
      1.00  0.92 0.70 1.93 0.30;
     -0.99  0.80 0.66 1.70 0.20;
     -0.83 -0.70 0.53 0.19 0.43;
     -0.45 -0.30 0.30 0.29 0.87];
 
[EV, EW] = eig(A);

T = [real(EV(:, 1)) imag(EV(:, 1)) real(EV(:, 3)) imag(EV(:, 3)) real(EV(:, 5))];
 
A2 = T^-1*A*T;
A2(abs(A2)<1e-5) = 0;

%%

AH1 = subplot(1, 2, 1);
AH2 = subplot(1, 2, 2);

%%

T = [2 1; 1 2];
A = [0 0; 1 0; 1 1; 0 1; 0 0]; 
B = A * T;

[Vectors, Values] = eig(T);

hold(AH1, 'on')
plot(AH1, A(:, 1), A(:, 2), 'r.--') 
plot(AH1, B(:, 1), B(:, 2), 'r.--')
plot(AH1, [0 Vectors(2, 1)], [0 Vectors(1, 1)], 'b.--')
plot(AH1, [0 Vectors(2, 2)], [0 Vectors(1, 2)], 'g.--')
hold(AH1, 'off')

title(AH1, sprintf('{\\color{blue}Eigenwert: %.0f}, {\\color{darkgreen}Eigenwert: %.0f}', Values(1, 1), Values(2, 2)))
axis(AH1, 'image')
xlim(AH1, [-1 4])
ylim(AH1, [-1 4])

%% Ludyik Theoretische Regelungstechnik Seite 136

[x, y] = meshgrid(-10 : 10, -10 : 10);
   
A = [reshape(x, [], 1) reshape(y, [], 1)];
a = 0.95;
T = [a*cosd(10)  a*-sind(10); 
     a*sind(10)  a*cosd(10)];
B = A;

Size = 20;

while true
    
    cla(AH2)
    B = B * T;

    hold(AH2, 'on')
    plot(A(:, 1), A(:, 2), 'b.')
    plot(B(:, 1), B(:, 2), 'r.')
    hold(AH2, 'off')

    axis(AH2, 'image')
    
    Size = mean(mean(abs(B))) * 5;
    
    title(AH2, '{\color{blue}Originalmatrix} || {\color{red}mehrmals transformierte Matrix (gedämpfe Rotation)}')
    xlim(AH2, [-Size Size])
    ylim(AH2, [-Size Size])

    pause(0.3)
    
end
