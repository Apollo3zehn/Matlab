clc
clear
close all

DecimalPoints = 5;
ScalingFactor = 10^DecimalPoints;

a = uint32(10);
b = uint32(27);
fprintf('a = %d; b = %d\n\n', a, b);

%%
c = double(a) / double(b);
fprintf('Floating point arithmetic:\na / b = %f\n\n', c);

%%
c = a / b;

fprintf('Fixed point arithmetic with no decimal point:\na / b = %f\n\n', c);

c = a * 10^DecimalPoints / b;
fprintf('Fixed point arithmetic with decimal point at %d:\na / b = %u.%u\n\n', DecimalPoints, c / ScalingFactor, mod(c, ScalingFactor));