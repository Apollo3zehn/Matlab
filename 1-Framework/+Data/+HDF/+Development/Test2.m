clc
clear
close all

datasetGroupPath        = '/TEST_BENCH/WK52/thermal_behavior/0be30c58-56b4-4904-9481-b2cea6652e8d';
datasetName             = '1 Hz';
dateTimeBegin           = datetime(2018, 03, 07, 'TimeZone', 'UTC');
dateTimeEnd             = datetime(2018, 03, 10, 'TimeZone', 'UTC');

% datasetGroupPath        = '/LEHE/LEHE03/GENERAL_DAQ/e5d628c9-3592-4245-92a5-deb3e678b788';
% datasetName             = '100 Hz';
% dateTimeBegin           = datenum(2017, 02, 16);
% dateTimeEnd             = datenum(2017, 02, 17);

hdfDataProvider         = Data.HDF.HdfDataProvider('M:\DATABASE');

variableNameSet         = {'P2090_EnableLTD(2)'
                           };
                       
datasetNameSet          = {'25 Hz'};
                          
dataInfoSet             = hdfDataProvider.LoadDatasets('/AIRPORT/AD8_PROTOTYPE/GENERAL_DAQ', variableNameSet, datasetNameSet, dateTimeBegin, dateTimeEnd);

plot(dataInfoSet(1).Dataset);
title(strrep(dataInfoSet(1).NameSet(1), '_', '\_'));
ylabel(dataInfoSet(1).Unit(1));
