clc
clear
close all

x = linspace(-0.5, 0.5, 100);

hold on

plot(x, exp(-x), 'k')
text(x(5), exp(-x(1)), 'f(x) = e^{-x}', 'Color', 'k')

plot(x, [1-x/2; 1+x/2], 'g')
text(x(5), 1-x(1)/2, 'f(x) = 1 - x/2', 'Color', 'g')
text(x(5), 1+x(1)/2, 'f(x) = 1 + x/2', 'Color', 'g')

plot(x, (1-x/2)./(1+x/2), 'r')
text(x(15), (1-x(10)/2)./(1+x(10)/2), 'f(x) = (1 - x/2) ./ (1 + x/2)', 'Color', 'r')

hold off