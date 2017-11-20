clc
clear
close all

dateTimeBegin           = datetime(2017, 07, 01, 0, 0, 0, 'TimeZone', 'UTC');
dateTimeEnd             = datetime(2017, 09, 02, 0, 0, 0, 'TimeZone', 'UTC');

hdfDataProvider         = Data.HDF.HdfDataProvider('D:\DATABASE');
variableNameSet         = {'W1_004_BF_Windgeschwindigkeit_1'};  
datasetNameSet          = {'600 s_mean'};
dataInfoSet             = hdfDataProvider.LoadDatasets('/LEHE/LEHE03/GENERAL_DAQ', variableNameSet, datasetNameSet, dateTimeBegin, dateTimeEnd);

plot(dataInfoSet(1).Dataset);
% title(strrep(dataInfoSet(1).NameSet(1), '_', '\_'));
% ylabel(dataInfoSet(1).Unit(1));

% ylim([0 50])
% grid on