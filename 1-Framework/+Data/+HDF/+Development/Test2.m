clc
clear
close all

datasetGroupPath        = '/TEST_BENCH/WK52/thermal_behavior/0be30c58-56b4-4904-9481-b2cea6652e8d';
datasetName             = '1 Hz';
dateTimeBegin           = datenum(2017, 04, 08);
dateTimeEnd             = datenum(2017, 04, 11);

% datasetGroupPath        = '/LEHE/LEHE03/GENERAL_DAQ/e5d628c9-3592-4245-92a5-deb3e678b788';
% datasetName             = '100 Hz';
% dateTimeBegin           = datenum(2017, 02, 16);
% dateTimeEnd             = datenum(2017, 02, 17);

hdfDataProvider         = Data.HDF.HdfDataProvider('M:\DATA');

variableNameSet         = {'t1_hot_air_duct'
                           't2_cold_section'
                           't3_hot_section'
                           't4_water_jacket_undernath'
                           't5_air_gap_underneath'
                           't6_connection_to_gearbox'
                           't7_heat_exchanger_outlet'
                           't8_generator_cover'
                           't9_oil_heat_exchanger_outlet'
                           't_10_ambient'
                           't_front_left_1_center_top'
                           't_front_left_2_center_bottom'
                           't_front_left_3_top'
                           't_front_left_4_bottom'
                           't_front_right_5_top'
                           't_front_right_6_center_bottom'
                           't_front_right_7_bottom'
                           't_front_right_8_center_top'
                           };
                       
datasetNameSet          = {'1 Hz' 
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'
                          '1 Hz'};
                          
dataInfoSet             = hdfDataProvider.LoadDatasets('/TEST_BENCH/WK52/thermal_behavior', variableNameSet, datasetNameSet, dateTimeBegin, dateTimeEnd);

plot(dataInfoSet(1).Dataset);
title(strrep(dataInfoSet(1).NameSet(1), '_', '\_'));
ylabel(dataInfoSet(1).Unit(1));
