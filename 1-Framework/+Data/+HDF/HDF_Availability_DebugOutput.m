clc
clear
close all

%%

% source = 'bb8073e1-7836-4a53-a296-7280821c14c3';
% path = '/ET_Control_test_bench/Simulation/MDAS_prototype_validation/';
% FileName = 'C:\Users\viwilms\Desktop\2017-02-02T00-00-00Z.h5';

source = '34881be9-7a2f-43c3-b0fe-99230316731b';
path = '/LEHE/LEHE03/GENERAL_DAQ/';
FileName = 'M:\DATA\2017-02-27T00-00-00Z.h5';

%info = h5info(FileName);
H5FileId = H5F.open(FileName);

Data    = h5read(FileName, [path source '/100 Hz']);
Status  = h5read(FileName, [path source '/100 Hz_status']);
DateTime= datenum(2017, 02, 25) + (1 : 8640000) ./ 100 ./ 86400;

disp(sum(~Status))

return

% xLimit = [datenum(2017, 01, 19) datenum(2017, 02, 05)];

AH(1) = subplot(3, 1, 1);
plot(DateTime, Status)
grid on
datetick('x', 'keeplimits')
ylabel('Availablitiy')
xlabel('Date / Time')
ylim([0 5])

AH(2) = subplot(3, 1, 2);
plot(DateTime, double(Data))
grid on
datetick('x', 'keeplimits')
ylabel('Data')
xlabel('Date / Time')
%ylim([0 5])

linkaxes(AH, 'x')
%xlim(xLimit)