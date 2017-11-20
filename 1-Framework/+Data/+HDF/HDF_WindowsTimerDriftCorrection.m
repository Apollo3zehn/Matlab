clc
clear
close all

%%

load('C:\Users\viwilms\Desktop\9h issue\w32tm drift correction\w32tm.mat')

AH(1) = subplot(2, 1, 1);
plot(w32tm(:, 1), w32tm(:, 2))
title('time difference (Windows clock - NTP server clock)')
ylabel('s')
datetick('x', 'keeplimits')
dragzoom
grid on

AH(2) = subplot(2, 1, 2);
plot(w32tm(:, 1), [diff(w32tm(:, 2)) * 1000 ./ 10; 0])
title('time adjustment')
ylabel('ms/s')
xlabel('time')
datetick('x', 'keeplimits')
dragzoom
grid on

linkaxes(AH, 'x')
