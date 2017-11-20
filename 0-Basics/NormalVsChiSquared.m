% http://stats.stackexchange.com/questions/76444/why-is-chi-square-used-when-creating-a-confidence-interval-for-the-variance
% http://www.kean.edu/~fosborne/bstat/06evar.html

clc
clear
close all

%% Steps:
% Create population that follows the normal distribution: X1 ~ N(mu, sigma)
% Take random samples of this population.
% Calculate the sampling variance S².
% Calculate X2 = S² * (N-1) / sigma²
% This random variable follows the chi squared distribution. X2 ~ X²(n - 1)

%% Normal distribution

Population  = randn(10000, 1);
Variance    = var(Population);

[Counts1, Centers1]     = hist(Population, 100);
dx1                     = diff(Centers1(1:2));

%% Theoretical normal distribution

X2 = -5 : 10/100 : 5;
p2 = Distribution.NormalPdf(X2, 0, 1);

%% Chi Squared

k       = 8;
Cycles 	= 10000;
X3      = NaN(Cycles, 1);

for i = 1 : Cycles
    
   while true
        Indices = round(length(Population)*rand(k, 1));
        if all(Indices ~= 0)
            break
        end
   end
   
   Samples  = Population(Indices);
   X3       = [X3; var(Samples)*(k-1) / Variance];   

end

[Counts3, Centers3]	= hist(X3, 100);
dx3              	= diff(Centers3(1:2));

%% Theoretical Chi Squared

X4 = 0 : 30/100 : 30;
p4 = Distribution.ChiSquaredPdf(X4, repmat(k-1, 1, size(X4, 2)));

%% Plot

AH1 = subplot(2, 1, 1);
hold(AH1, 'on')
bar(AH1, Centers1, Counts1 / sum(Counts1 * dx1))
plot(AH1, X2, p2, 'r')
xlim(AH1, [-5 5])
title(AH1, 'Normal distribution')
hold(AH1, 'off')

AH2 = subplot(2, 1, 2);
hold(AH2, 'on')
bar(AH2, Centers3, Counts3 / sum(Counts3 * dx3))
plot(AH2, X4, p4, 'r')
hold(AH2, 'off')
title(AH2, 'Chi^2 distribution')
xlim(AH2, [0 30])



