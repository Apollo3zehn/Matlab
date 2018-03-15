clc
close all

AH(1) = subplot(4, 2, 1);
plot(W1_004_BF_Windgeschwindigkeit_1.dataset_100_Hz ./ 10)
ylabel('wind speed in m/s')

AH(2) = subplot(4, 2, 2);
plot(W1_WCX_155_Achse_1_angular_encoder_RCA.dataset_100_Hz ./ 10)

AH(3) = subplot(4, 2, 3);
plot(W1_WCX_152_Achse_1_blade_bearing_RCA.dataset_100_Hz)

AH(4) = subplot(4, 2, 4);
plot(W1_WCX_156_Achse_2_angular_encoder_RCA.dataset_100_Hz ./ 10)

AH(5) = subplot(4, 2, 5);
plot(W1_WCX_153_Achse_2_blade_bearing_RCA.dataset_100_Hz)

AH(6) = subplot(4, 2, 6);
plot(W1_WCX_157_Achse_3_angular_encoder_RCA.dataset_100_Hz ./ 10)

AH(7) = subplot(4, 2, 7);
plot(W1_WCX_154_Achse_3_blade_bearing_RCA.dataset_100_Hz)

linkaxes(AH, 'x')