clc
clear
close all

%%

%source = '5cd9b7a6-1018-43a5-834d-33dd9e8a796b';
source = 'bb8073e1-7836-4a53-a296-7280821c14c3';

%path = '/Adwen/Validation/MDAS Prototype/';
path = '/ET_Control_test_bench/Simulation/MDAS_prototype_validation/';

FileName = 'C:\Users\viwilms\Desktop\2017-01-31T00-00-00Z.h5';
H5FileId = H5F.open(FileName);

info = h5info(FileName);

Data    = h5read(FileName, [path source '/100 Hz']);
Status  = h5read(FileName, [path source '/100 Hz_status']);
%Range   = 5950000 : 8640000;
Range   = 1 : 8640000;
s       = (Range - Range(1)) / 100 / 86400;

AH1 = subplot(3, 1, 1);
plot(s, Data(Range))
xlim([s(1) s(end)])
title('Data')

AH2 = subplot(3, 1, 2);
plot(s, Status(Range))
xlim([s(1) s(end)])
ylim([0 1])
title('Availability')

AH3 = subplot(3, 1, 3);
%plot(s, [diff(Data(Range)); 0])
Data = double(Data);
Data(~logical(Status)) = NaN;
plot(s, Data(Range))
xlim([s(1) s(end)])
title('Diff')

xlabel('Time in s')
datetick('x', 'keeplimits')

linkaxes([AH1 AH2 AH3], 'x');

%%

fprintf('Availability: %.4f %%\n', (1 - sum(diff(Status(Range)) == 1)  / sum(Status(Range) == 1) ) * 100)