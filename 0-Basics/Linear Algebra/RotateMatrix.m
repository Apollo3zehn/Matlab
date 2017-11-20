clc
clear
close all

theta = 30 / 180 * pi;

Transform = [cos(theta)  -sin(theta); sin(theta)  cos(theta)];

a = [5 5; 5 6; 6 6; 6 5; 5 5].';

line(a(1, :), a(2, :))

hold on

c = Transform * a;

line(c(1, :), c(2, :))

xlim([-10 10])
ylim([-10 10])
grid on
